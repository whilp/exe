# Linking debug notes

## What we've learned

### Build system structure
- `3p/lua/BUILD.mk.patch` is NOT a patch file - it's the complete BUILD.mk that gets copied to `cosmopolitan-4.0.2/third_party/lua/BUILD.mk` (see `3p/lua/cook.mk:8`)
- The build process:
  1. Extracts cosmopolitan-4.0.2 source
  2. Applies `linit.c.patch` to register modules
  3. Copies module source files (lre.c, lpath.c, largon2.c, lsqlite3.c) from tool/net/
  4. **REPLACES** the entire BUILD.mk with our BUILD.mk.patch
  5. Builds lua inside cosmopolitan
  6. Copies the built binary to o/3p/lua/

### Current state of BUILD.mk.patch
- Lines 88-89: largon2.c and lsqlite3.c are in THIRD_PARTY_LUA_A_SRCS ✅
- Lines 150-151: THIRD_PARTY_ARGON2 and THIRD_PARTY_SQLITE3 are in DIRECTDEPS ✅
- Line 151: Does NOT have trailing backslash (correct - it's the last item) ✅

### Compilation success
- Both `largon2.o` and `lsqlite3.o` compile successfully without errors
- argon2.a and sqlite3.a libraries build successfully when built explicitly
- No "undefined reference" errors during compilation phase

### The persistent error
```
.pkg: open failed with ENOENT

.cosmocc/3.9.2/bin/package.ape -o o//third_party/lua/lua.a.pkg \
  -do//libc/calls/syscalls.a.pkg \
  ... [many dependencies] ...
  -do//third_party/tz/tz.a.pkg \
  -d.pkg \  # ← THIS IS THE PROBLEM
  @o/tmp/o__third_party_lua_lua.a.pkg.tmp.args
```

The `-d.pkg` indicates an empty/undefined variable in DIRECTDEPS.

### Package command analysis
From the error, we can see all packages up to `-do//third_party/tz/tz.a.pkg`, then `-d.pkg`.

According to our BUILD.mk.patch DIRECTDEPS order:
```
...
THIRD_PARTY_REGEX
THIRD_PARTY_TZ        ← last successful one
THIRD_PARTY_ARGON2    ← this becomes -d.pkg!
THIRD_PARTY_SQLITE3
```

So `THIRD_PARTY_ARGON2` variable is resolving to empty string during the package.ape command.

### Make variable check
Running `make -p` shows:
```
THIRD_PARTY_ARGON2 = $(THIRD_PARTY_ARGON2_A_DEPS) $(THIRD_PARTY_ARGON2_A)
```

This proves the variable IS defined in the makefile.

### Successful reference: redbean
Checked `tool/net/BUILD.mk` and confirmed that redbean successfully uses both:
```
TOOL_NET_DIRECTDEPS = \
    ...
    THIRD_PARTY_ARGON2 \
    ...
    THIRD_PARTY_SQLITE3 \
    ...
```

And redbean builds successfully with largon2.c and lsqlite3.c.

## Hypotheses for what could be wrong

### Hypothesis 1: Build order issue (MOST LIKELY)
**Theory:** The package.ape command runs before argon2 and sqlite3 packages are built, so the variable expands to empty string.

**Evidence:**
- We had to manually build `o//third_party/argon2/argon2.a` and `o//third_party/sqlite3/sqlite3.a`
- The error persists even after building them explicitly
- But the .pkg file might need to be built, not just the .a file

**Test:** Check if `o//third_party/argon2/argon2.a.pkg` exists
**Fix:** Add explicit dependencies in lua's BUILD.mk.patch to ensure .pkg files are built first

### Hypothesis 2: Package name mismatch
**Theory:** The Makefile variable name doesn't match the actual package target name.

**Evidence:**
- In redbean BUILD.mk, it uses `THIRD_PARTY_ARGON2` in DIRECTDEPS
- The argon2 BUILD.mk defines `PKGS += THIRD_PARTY_ARGON2`
- But the actual .a file is `argon2.a` not `ARGON2.a`

**Test:** Check how the foreach loop in THIRD_PARTY_LUA_A_DEPS expands
**Fix:** May need to use different variable name format

### Hypothesis 3: Missing package variable definition
**Theory:** `THIRD_PARTY_ARGON2_A` variable is not defined/exported properly.

**Evidence:**
- `make -p` shows `THIRD_PARTY_ARGON2 = $(THIRD_PARTY_ARGON2_A_DEPS) $(THIRD_PARTY_ARGON2_A)`
- But if THIRD_PARTY_ARGON2_A is empty, the whole variable would be empty

**Test:** Check if `THIRD_PARTY_ARGON2_A` is defined in argon2/BUILD.mk
**Fix:** Verify all required variables are properly defined

### Hypothesis 4: Cosmopolitan version mismatch
**Theory:** The cosmopolitan-4.0.2 source we're using has the variables defined, but our BUILD.mk.patch is overriding/missing something.

**Evidence:**
- We confirmed the extracted cosmopolitan BUILD.mk already has ARGON2 and SQLITE3 in DIRECTDEPS
- But we're copying our BUILD.mk.patch over it
- Maybe we based our patch on an older version?

**Test:** Diff our BUILD.mk.patch against the original cosmopolitan-4.0.2/third_party/lua/BUILD.mk
**Fix:** Update BUILD.mk.patch to match the current cosmopolitan version exactly

### Hypothesis 5: The .pkg rule issue
**Theory:** The `$(foreach x,$(THIRD_PARTY_LUA_A_DIRECTDEPS),$($(x)_A).pkg)` expansion is wrong.

**Evidence:**
- Line 163 in BUILD.mk.patch:
  ```
  $(foreach x,$(THIRD_PARTY_LUA_A_DIRECTDEPS),$($(x)_A).pkg)
  ```
- This should expand `THIRD_PARTY_ARGON2` to `$(THIRD_PARTY_ARGON2_A).pkg`
- If `THIRD_PARTY_ARGON2_A` is not set, this becomes `.pkg`

**Test:** Check the actual value of `THIRD_PARTY_ARGON2_A` variable
**Fix:** Ensure the _A suffix variable exists for both packages

## Systematic hypothesis testing

### Test 1: Verify _A variable definitions exist

**Purpose:** Invalidate Hypothesis 3 (missing variable definition)

**Commands:**
```bash
cd o/3p/cosmopolitan/cosmopolitan-4.0.2

# Check if THIRD_PARTY_ARGON2_A is defined
rg "^THIRD_PARTY_ARGON2_A\b" third_party/argon2/BUILD.mk

# Check if THIRD_PARTY_SQLITE3_A is defined
rg "^THIRD_PARTY_SQLITE3_A\b" third_party/sqlite3/BUILD.mk

# Also check using make -p for the actual resolved value
make -p 2>&1 | rg "^THIRD_PARTY_ARGON2_A ="
make -p 2>&1 | rg "^THIRD_PARTY_SQLITE3_A ="
```

**Expected results:**
- If both `_A` variables are defined → Hypothesis 3 INVALIDATED
- If either is missing/empty → Hypothesis 3 CONFIRMED, root cause found

**Interpretation:**
- The _A variable should be `o//third_party/argon2/argon2.a`
- If it's empty or undefined, the foreach expansion `$($(x)_A).pkg` becomes `.pkg`

---

### Test 2: Check if .pkg files exist and can be built

**Purpose:** Invalidate Hypothesis 1 (build order issue)

**Commands:**
```bash
cd o/3p/cosmopolitan/cosmopolitan-4.0.2

# Check if .pkg files exist
ls -la o//third_party/argon2/argon2.a.pkg 2>&1
ls -la o//third_party/sqlite3/sqlite3.a.pkg 2>&1

# Try to build them explicitly
make o//third_party/argon2/argon2.a.pkg
make o//third_party/sqlite3/sqlite3.a.pkg

# Verify they now exist
ls -la o//third_party/argon2/argon2.a.pkg
ls -la o//third_party/sqlite3/sqlite3.a.pkg
```

**Expected results:**
- If .pkg files don't exist but build successfully → Hypothesis 1 CONFIRMED (build order)
- If .pkg files already exist but lua still fails → Hypothesis 1 INVALIDATED
- If .pkg files fail to build → Different problem, check error

**Follow-up if Hypothesis 1 confirmed:**
```bash
# After building .pkg files, retry lua build
make o//third_party/lua/lua.a.pkg
```

---

### Test 3: Trace the actual variable expansion

**Purpose:** Definitively see what Make resolves each variable to

**Commands:**
```bash
cd o/3p/cosmopolitan/cosmopolitan-4.0.2

# Print the full THIRD_PARTY_ARGON2 expansion
make -p 2>&1 | rg -A2 "^THIRD_PARTY_ARGON2 ="

# Print what THIRD_PARTY_LUA_A_DIRECTDEPS contains
make -p 2>&1 | rg "^THIRD_PARTY_LUA_A_DIRECTDEPS ="

# Use make's info function to debug (add to BUILD.mk temporarily)
# Or use make's internal debugging:
make --debug=v o//third_party/lua/lua.a.pkg 2>&1 | head -200
```

**Key debugging technique - add to BUILD.mk.patch:**
```make
# Add after THIRD_PARTY_LUA_A_DIRECTDEPS definition:
$(info DEBUG: DIRECTDEPS = $(THIRD_PARTY_LUA_A_DIRECTDEPS))
$(info DEBUG: ARGON2 = $(THIRD_PARTY_ARGON2))
$(info DEBUG: ARGON2_A = $(THIRD_PARTY_ARGON2_A))
$(info DEBUG: SQLITE3 = $(THIRD_PARTY_SQLITE3))
$(info DEBUG: SQLITE3_A = $(THIRD_PARTY_SQLITE3_A))
```

**Expected results:**
- Shows exactly which variable is empty
- Pinpoints whether it's the DIRECTDEPS list or the _A suffix variable

---

### Test 4: Compare BUILD.mk.patch with original

**Purpose:** Invalidate Hypothesis 4 (version mismatch)

**Commands:**
```bash
# First, check if we have the original
ls -la o/3p/cosmopolitan/cosmopolitan-4.0.2/third_party/lua/BUILD.mk

# If our patch has already been applied, extract fresh:
cd o/3p/cosmopolitan
tar -xzf ../cosmopolitan-4.0.2.tar.gz --strip-components=1 \
    -C /tmp cosmopolitan-4.0.2/third_party/lua/BUILD.mk

# Diff
diff -u /tmp/third_party/lua/BUILD.mk 3p/lua/BUILD.mk.patch
```

**Expected results:**
- Major structural differences → Hypothesis 4 LIKELY, need to sync
- Only our additions differ → Hypothesis 4 INVALIDATED
- Pay attention to: variable names, foreach syntax, dependency lists

---

### Test 5: Test the foreach expansion directly

**Purpose:** Invalidate Hypothesis 5 (.pkg rule issue)

**Commands:**
```bash
cd o/3p/cosmopolitan/cosmopolitan-4.0.2

# Create a test makefile to verify foreach behavior
cat > /tmp/test_foreach.mk << 'EOF'
THIRD_PARTY_ARGON2_A = o//third_party/argon2/argon2.a
THIRD_PARTY_SQLITE3_A = o//third_party/sqlite3/sqlite3.a
THIRD_PARTY_TZ_A = o//third_party/tz/tz.a

TEST_DEPS = THIRD_PARTY_TZ THIRD_PARTY_ARGON2 THIRD_PARTY_SQLITE3

test:
	@echo "Expansion:"
	@echo "$(foreach x,$(TEST_DEPS),$($(x)_A).pkg)"
EOF

make -f /tmp/test_foreach.mk test
```

**Expected results:**
- If expansion is correct → Hypothesis 5 INVALIDATED
- If expansion shows `.pkg` for ARGON2 → Confirms the _A variable is the issue

---

### Test 6: Check BUILD.mk include order

**Purpose:** Verify argon2/BUILD.mk is included before lua/BUILD.mk

**Commands:**
```bash
cd o/3p/cosmopolitan/cosmopolitan-4.0.2

# Find where BUILD.mk files are included
rg "include.*BUILD.mk" Makefile | head -20

# Check if there's an explicit include order or if it's glob-based
rg "third_party.*BUILD" Makefile

# Check the order of PKGS variable additions
make -p 2>&1 | rg "^PKGS" | head -5
```

**Expected results:**
- If argon2/BUILD.mk is included after lua/BUILD.mk → variables won't be defined yet
- If alphabetical (argon2 before lua) → should be fine

---

### Test 7: Build redbean to verify argon2/sqlite3 work elsewhere

**Purpose:** Establish baseline - prove argon2/sqlite3 work in another context

**Commands:**
```bash
cd o/3p/cosmopolitan/cosmopolitan-4.0.2

# Build redbean (which uses argon2 and sqlite3)
make o//tool/net/redbean.com

# Check if it succeeded
ls -la o//tool/net/redbean.com
```

**Expected results:**
- If redbean builds → proves argon2/sqlite3 variables work, issue is lua-specific
- If redbean fails similarly → systemic issue with argon2/sqlite3 packages

---

### Test 8: Minimal reproduction - isolate the exact failure

**Purpose:** Create smallest test case

**Commands:**
```bash
cd o/3p/cosmopolitan/cosmopolitan-4.0.2

# Try building lua.a first (without .pkg)
make o//third_party/lua/lua.a

# Then try the .pkg
make o//third_party/lua/lua.a.pkg

# If .pkg fails, check the command that's run:
make -n o//third_party/lua/lua.a.pkg 2>&1 | rg "package.ape" -A20
```

**Expected results:**
- See the exact `-d` arguments to package.ape
- Identify which `-d.pkg` (empty) arguments appear

---

## Decision tree for root cause

```
START
  │
  ├─► Test 1: Are _A variables defined?
  │     │
  │     ├─ NO → ROOT CAUSE: Missing variable definitions
  │     │        Fix: Check why argon2/BUILD.mk isn't being included
  │     │
  │     └─ YES → Continue to Test 2
  │
  ├─► Test 2: Do .pkg files exist?
  │     │
  │     ├─ NO, but build succeeds → ROOT CAUSE: Build order
  │     │        Fix: Add explicit dependencies or build .pkg first
  │     │
  │     ├─ NO, build fails → Different error, investigate
  │     │
  │     └─ YES → Continue to Test 3
  │
  ├─► Test 3: What do variables expand to?
  │     │
  │     ├─ ARGON2_A is empty → ROOT CAUSE: Variable not exported/defined
  │     │
  │     └─ ARGON2_A has value → Continue to Test 5
  │
  ├─► Test 5: Does foreach work correctly?
  │     │
  │     ├─ NO → ROOT CAUSE: Makefile syntax issue
  │     │
  │     └─ YES → Continue to Test 6
  │
  └─► Test 6: Include order correct?
        │
        ├─ NO → ROOT CAUSE: lua/BUILD.mk processed before argon2/BUILD.mk
        │        Fix: Ensure proper include ordering
        │
        └─ YES → Need deeper investigation
```

## Quick diagnostic script

Run this all at once:

```bash
#!/bin/bash
set -x
cd o/3p/cosmopolitan/cosmopolitan-4.0.2

echo "=== Test 1: _A variable definitions ==="
make -p 2>&1 | rg "^THIRD_PARTY_ARGON2_A\s*="
make -p 2>&1 | rg "^THIRD_PARTY_SQLITE3_A\s*="

echo "=== Test 2: .pkg file existence ==="
ls -la o//third_party/argon2/argon2.a.pkg 2>&1 || echo "MISSING"
ls -la o//third_party/sqlite3/sqlite3.a.pkg 2>&1 || echo "MISSING"

echo "=== Test 3: Full variable expansion ==="
make -p 2>&1 | rg "^THIRD_PARTY_ARGON2\s*=" | head -1
make -p 2>&1 | rg "^THIRD_PARTY_SQLITE3\s*=" | head -1

echo "=== Test 7: Can redbean build? ==="
make o//tool/net/redbean.com -n 2>&1 | tail -5

echo "=== Test 8: Package.ape command for lua ==="
make -n o//third_party/lua/lua.a.pkg 2>&1 | rg "package.ape" -A5 | head -20
```

- NEVER cd from the repository. ALWAYS inspect using absolute paths

## Iterating on lua patches

To iterate on patches in `3p/lua/*.patch`:

1. Setup temp directory with original and working copies:
```bash
mkdir -p /tmp/cosmo-patch/a /tmp/cosmo-patch/b
cp o/3p/cosmopolitan/cosmopolitan-4.0.2/third_party/lua/BUILD.mk /tmp/cosmo-patch/a/
cp o/3p/cosmopolitan/cosmopolitan-4.0.2/third_party/lua/lua.main.c /tmp/cosmo-patch/a/
cp o/3p/cosmopolitan/cosmopolitan-4.0.2/third_party/lua/BUILD.mk /tmp/cosmo-patch/b/
cp o/3p/cosmopolitan/cosmopolitan-4.0.2/third_party/lua/lua.main.c /tmp/cosmo-patch/b/
```

2. Apply current patches to b/ (working copy):
```bash
cd /tmp/cosmo-patch && patch -p1 b/BUILD.mk < ~/build/3p/lua/BUILD.mk.patch
cd /tmp/cosmo-patch && patch -p1 b/lua.main.c < ~/build/3p/lua/lua.main.c.patch
```

3. Edit files in `/tmp/cosmo-patch/b/` (a/ is pristine reference)

4. Generate updated patches:
```bash
diff -u /tmp/cosmo-patch/a/BUILD.mk /tmp/cosmo-patch/b/BUILD.mk | \
  sed 's|/tmp/cosmo-patch/a/|a/third_party/lua/|g' | \
  sed 's|/tmp/cosmo-patch/b/|b/third_party/lua/|g' > 3p/lua/BUILD.mk.patch

diff -u /tmp/cosmo-patch/a/lua.main.c /tmp/cosmo-patch/b/lua.main.c | \
  sed 's|/tmp/cosmo-patch/a/|a/third_party/lua/|g' | \
  sed 's|/tmp/cosmo-patch/b/|b/third_party/lua/|g' > 3p/lua/lua.main.c.patch
```

5. Test the updated patches:
```bash
make clean && make test
```

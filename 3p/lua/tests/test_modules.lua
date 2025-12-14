#!/usr/bin/env lua
-- Discover what modules are available in cosmopolitan's lua

local function try_require(name)
    local ok, mod = pcall(require, name)
    if ok then
        return true, type(mod)
    else
        return false, nil
    end
end

print("Built-in modules:")
print()

-- Standard lua modules that should always be available
local standard_modules = {
    "string",
    "table",
    "math",
    "io",
    "os",
    "debug",
    "package",
    "coroutine",
    "utf8",
}

-- Modules that might be in cosmopolitan's lua
local cosmo_modules = {
    "unix",
    "re",      -- redbean regex
    "path",    -- redbean path utilities
    "sqlite3", -- sqlite
    "argon2",  -- password hashing
    "bsd",     -- bsd functions
    "json",    -- json encoding
    "maxmind", -- geoip
    "net",     -- networking
    "crypto",  -- cryptography
    "zlib",    -- compression
    "http",    -- http utilities
}

print("Standard Lua modules:")
for _, name in ipairs(standard_modules) do
    local ok, typ = try_require(name)
    local status = ok and "✓" or "✗"
    print(string.format("  %-20s %s (%s)", name, status, typ or "not available"))
end

print()
print("Potential cosmopolitan/redbean modules:")
for _, name in ipairs(cosmo_modules) do
    local ok, typ = try_require(name)
    local status = ok and "✓" or "✗"
    print(string.format("  %-20s %s (%s)", name, status, typ or "not available"))
end

-- Check what's in package.preload
print()
print("Preloaded modules:")
for name, _ in pairs(package.preload) do
    print(string.format("  %s", name))
end

-- Check package.loaded
print()
print("Already loaded modules:")
for name, _ in pairs(package.loaded) do
    print(string.format("  %s", name))
end

#!/usr/bin/env lua
-- Test unix module availability and basic functionality

local function test(name, fn)
    io.write(string.format("%-50s ", name .. "..."))
    local ok, err = pcall(fn)
    if ok then
        print("✓")
        return true
    else
        print("✗")
        print("  Error: " .. tostring(err))
        return false
    end
end

local function main()
    local passed = 0
    local failed = 0

    -- Test: can require unix module
    if test("require('unix')", function()
        unix = require('unix')
        assert(unix ~= nil, "unix module is nil")
        assert(type(unix) == "table", "unix module is not a table")
    end) then
        passed = passed + 1
    else
        failed = failed + 1
        os.exit(1)
    end

    -- Test: unix.getpid
    if test("unix.getpid()", function()
        local pid = unix.getpid()
        assert(type(pid) == "number", "getpid() should return number")
        assert(pid > 0, "pid should be positive")
    end) then
        passed = passed + 1
    else
        failed = failed + 1
    end

    -- Test: unix.getcwd
    if test("unix.getcwd()", function()
        local cwd = unix.getcwd()
        assert(type(cwd) == "string", "getcwd() should return string")
        assert(#cwd > 0, "cwd should not be empty")
    end) then
        passed = passed + 1
    else
        failed = failed + 1
    end

    -- Test: unix.clock_gettime
    if test("unix.clock_gettime()", function()
        local t = unix.clock_gettime()
        assert(type(t) == "number", "clock_gettime() should return number")
        assert(t > 0, "time should be positive")
    end) then
        passed = passed + 1
    else
        failed = failed + 1
    end

    -- Test: unix.stat
    if test("unix.stat('.')", function()
        local st = unix.stat('.')
        assert(st ~= nil, "stat should return result")
        assert(type(st) == "userdata" or type(st) == "table", "stat should return userdata or table")
    end) then
        passed = passed + 1
    else
        failed = failed + 1
    end

    -- Test: unix.fork (test availability, don't actually fork)
    if test("unix.fork exists", function()
        assert(type(unix.fork) == "function", "fork should be a function")
    end) then
        passed = passed + 1
    else
        failed = failed + 1
    end

    -- Test: unix.socket (test availability)
    if test("unix.socket exists", function()
        assert(type(unix.socket) == "function", "socket should be a function")
    end) then
        passed = passed + 1
    else
        failed = failed + 1
    end

    print()
    print(string.format("Results: %d passed, %d failed", passed, failed))

    if failed > 0 then
        os.exit(1)
    end
end

main()

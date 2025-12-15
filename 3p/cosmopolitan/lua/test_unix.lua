local lu = require('luaunit')

TestUnixModule = {}

function TestUnixModule:testRequire()
    local unix = require('unix')
    lu.assertNotNil(unix)
    lu.assertEquals(type(unix), 'table')
end

function TestUnixModule:testGetpid()
    local unix = require('unix')
    local pid = unix.getpid()
    lu.assertEquals(type(pid), 'number')
    lu.assertTrue(pid > 0)
end

function TestUnixModule:testGetcwd()
    local unix = require('unix')
    local cwd = unix.getcwd()
    lu.assertEquals(type(cwd), 'string')
    lu.assertTrue(#cwd > 0)
end

function TestUnixModule:testClockGettime()
    local unix = require('unix')
    local t = unix.clock_gettime()
    lu.assertEquals(type(t), 'number')
    lu.assertTrue(t > 0)
end

function TestUnixModule:testStat()
    local unix = require('unix')
    local st = unix.stat('.')
    lu.assertNotNil(st)
    lu.assertTrue(type(st) == 'userdata' or type(st) == 'table')
end

function TestUnixModule:testForkExists()
    local unix = require('unix')
    lu.assertEquals(type(unix.fork), 'function')
end

function TestUnixModule:testSocketExists()
    local unix = require('unix')
    lu.assertEquals(type(unix.socket), 'function')
end

os.exit(lu.LuaUnit.run())

local lu = require('luaunit')

local function try_require(name)
    local ok, mod = pcall(require, name)
    if ok then
        return true, type(mod)
    else
        return false, nil
    end
end

TestStandardModules = {}

function TestStandardModules:testString()
    local ok, typ = try_require('string')
    lu.assertTrue(ok)
    lu.assertEquals(typ, 'table')
end

function TestStandardModules:testTable()
    local ok, typ = try_require('table')
    lu.assertTrue(ok)
    lu.assertEquals(typ, 'table')
end

function TestStandardModules:testMath()
    local ok, typ = try_require('math')
    lu.assertTrue(ok)
    lu.assertEquals(typ, 'table')
end

function TestStandardModules:testIo()
    local ok, typ = try_require('io')
    lu.assertTrue(ok)
    lu.assertEquals(typ, 'table')
end

function TestStandardModules:testOs()
    local ok, typ = try_require('os')
    lu.assertTrue(ok)
    lu.assertEquals(typ, 'table')
end

function TestStandardModules:testDebug()
    local ok, typ = try_require('debug')
    lu.assertTrue(ok)
    lu.assertEquals(typ, 'table')
end

function TestStandardModules:testPackage()
    local ok, typ = try_require('package')
    lu.assertTrue(ok)
    lu.assertEquals(typ, 'table')
end

function TestStandardModules:testCoroutine()
    local ok, typ = try_require('coroutine')
    lu.assertTrue(ok)
    lu.assertEquals(typ, 'table')
end

function TestStandardModules:testUtf8()
    local ok, typ = try_require('utf8')
    lu.assertTrue(ok)
    lu.assertEquals(typ, 'table')
end

TestCosmopolitanModules = {}

function TestCosmopolitanModules:testUnix()
    local ok, typ = try_require('unix')
    lu.assertTrue(ok)
    lu.assertEquals(typ, 'table')
end

function TestCosmopolitanModules:testLuaunit()
    local ok, typ = try_require('luaunit')
    lu.assertTrue(ok)
    lu.assertEquals(typ, 'table')
end

os.exit(lu.LuaUnit.run())

local lu = require('luaunit')

TestReModule = {}

function TestReModule:testRequire()
    local re = require('re')
    lu.assertNotNil(re)
    lu.assertEquals(type(re), 'table')
end

function TestReModule:testCompile()
    local re = require('re')
    local pattern = re.compile('hello')
    lu.assertNotNil(pattern)
    lu.assertEquals(type(pattern), 'userdata')
end

function TestReModule:testSearch()
    local re = require('re')
    local match = re.search('hello', 'hello')
    lu.assertEquals(match, 'hello')
end

function TestReModule:testCompileSearch()
    local re = require('re')
    local pattern = re.compile('world')
    local match = pattern:search('hello world')
    lu.assertEquals(match, 'world')
end

function TestReModule:testSearchExists()
    local re = require('re')
    lu.assertEquals(type(re.search), 'function')
end

function TestReModule:testCompileExists()
    local re = require('re')
    lu.assertEquals(type(re.compile), 'function')
end

os.exit(lu.LuaUnit.run())

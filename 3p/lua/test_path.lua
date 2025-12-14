local lu = require('luaunit')

TestPathModule = {}

function TestPathModule:testRequire()
    local path = require('path')
    lu.assertNotNil(path)
    lu.assertEquals(type(path), 'table')
end

function TestPathModule:testBasename()
    local path = require('path')
    lu.assertEquals(type(path.basename), 'function')
    lu.assertEquals(path.basename('/foo/bar/baz.txt'), 'baz.txt')
    lu.assertEquals(path.basename('/foo/bar/'), 'bar')
    lu.assertEquals(path.basename('file.txt'), 'file.txt')
end

function TestPathModule:testDirname()
    local path = require('path')
    lu.assertEquals(type(path.dirname), 'function')
    lu.assertEquals(path.dirname('/foo/bar/baz.txt'), '/foo/bar')
    lu.assertEquals(path.dirname('/foo/bar/'), '/foo')
    lu.assertEquals(path.dirname('file.txt'), '.')
end

function TestPathModule:testJoin()
    local path = require('path')
    lu.assertEquals(type(path.join), 'function')
    lu.assertEquals(path.join('foo', 'bar'), 'foo/bar')
    lu.assertEquals(path.join('/foo', 'bar', 'baz'), '/foo/bar/baz')
end

function TestPathModule:testExists()
    local path = require('path')
    lu.assertEquals(type(path.exists), 'function')
    lu.assertTrue(path.exists('.'))
    lu.assertFalse(path.exists('/nonexistent/path/to/nowhere'))
end

os.exit(lu.LuaUnit.run())

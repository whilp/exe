function test_unix_module_exists()
    lu.assertNotNil(unix, "unix module should be compiled into lua")
end

function test_path_module_exists()
    lu.assertNotNil(path, "path module should be compiled into lua")
end

function test_path_basename()
    lu.assertEquals(path.basename("/foo/bar/baz.txt"), "baz.txt")
    lu.assertEquals(path.basename("/foo/bar/"), "bar")
    lu.assertEquals(path.basename("file.txt"), "file.txt")
end

function test_path_dirname()
    lu.assertEquals(path.dirname("/foo/bar/baz.txt"), "/foo/bar")
    lu.assertEquals(path.dirname("/foo/bar/"), "/foo")
end

function test_path_join()
    lu.assertEquals(path.join("foo", "bar"), "foo/bar")
    lu.assertEquals(path.join("/foo", "bar"), "/foo/bar")
    lu.assertEquals(path.join("foo", "/bar"), "/bar")
end

function test_re_module_exists()
    lu.assertNotNil(re, "re module should be compiled into lua")
end

function test_re_search()
    lu.assertEquals(re.search([[hello]], "hello world"), "hello")
    lu.assertNil(re.search([[xyz]], "hello world"))
end

function test_argon2_module_exists()
    lu.assertNotNil(argon2, "argon2 module should be compiled into lua")
end

function test_lsqlite3_module_exists()
    lu.assertNotNil(lsqlite3, "lsqlite3 module should be compiled into lua")
end

function test_lsqlite3_open_memory()
    local db = lsqlite3.open_memory()
    lu.assertNotNil(db)
    db:close()
end

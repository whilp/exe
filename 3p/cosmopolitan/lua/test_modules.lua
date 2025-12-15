function test_unix_module_exists()
    lu.assertNotNil(unix, "unix module should be compiled into lua")
end

function test_path_module_exists()
    lu.skipIf(true, "path module is redbean-specific")
    lu.assertNotNil(path, "path module should be compiled into lua")
end

function test_re_module_exists()
    lu.skipIf(true, "re module is redbean-specific")
    lu.assertNotNil(re, "re module should be compiled into lua")
end

function test_argon2_module_exists()
    lu.skipIf(true, "argon2 module is redbean-specific")
    lu.assertNotNil(argon2, "argon2 module should be compiled into lua")
end

function test_lsqlite3_module_exists()
    lu.skipIf(true, "lsqlite3 module is redbean-specific")
    lu.assertNotNil(lsqlite3, "lsqlite3 module should be compiled into lua")
end

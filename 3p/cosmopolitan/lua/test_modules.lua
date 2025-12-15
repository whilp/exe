function test_unix_module_exists()
    lu.assertNotNil(unix, "unix module should be compiled into lua")
end

function test_path_module_exists()
    lu.assertNotNil(path, "path module should be compiled into lua")
end

function test_re_module_exists()
    lu.assertNotNil(re, "re module should be compiled into lua")
end

function test_argon2_module_exists()
    lu.assertNotNil(argon2, "argon2 module should be compiled into lua")
end

function test_lsqlite3_module_exists()
    lu.assertNotNil(lsqlite3, "lsqlite3 module should be compiled into lua")
end

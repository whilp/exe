local lu = require('luaunit')

function test_unix_module_exists()
    lu.assertNotNil(unix, "unix module should be compiled into lua")
end

os.exit(lu.LuaUnit.run())

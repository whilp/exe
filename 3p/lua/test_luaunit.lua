local lu = require('luaunit')

TestMath = {}
function TestMath:testAddition()
    lu.assertEquals(1 + 1, 2)
end

function TestMath:testSubtraction()
    lu.assertEquals(5 - 3, 2)
end

os.exit(lu.LuaUnit.run())

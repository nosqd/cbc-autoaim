local cannons = {peripheral.find("cbc_cannon_mount")}
local fncs = {}

for i, cannon in ipairs(cannons) do
    cannon.assemble()
    fncs[i] = cannon.fire
end

parallel.waitForAll(table.unpack(fncs))

for i, cannon in ipairs(cannons) do
    cannon.disassemble()
end

print("reloading")

local MOVE_SIDE = "front"
local SCREW_SIDE = "left"
local PLACE_SIDE = "right"
local ROTATE_SIDE = "back"
local PUSH_SIDE = "top"
local cannons = {peripheral.find("cbc_cannon_mount")}
local fncs = {}

for i, cannon in ipairs(cannons) do
    fncs[i] = cannon.disassemble
end
parallel.waitForAll(table.unpack(fncs))

redstone.setOutput(SCREW_SIDE, true)
os.sleep(1)
redstone.setOutput(SCREW_SIDE, false)
redstone.setOutput(MOVE_SIDE, true)
os.sleep(1)
redstone.setOutput(MOVE_SIDE, false)
redstone.setOutput(PLACE_SIDE, true)
os.sleep(1)
redstone.setOutput(PLACE_SIDE, false)
redstone.setOutput(ROTATE_SIDE, true)
os.sleep(1)
redstone.setOutput(ROTATE_SIDE, false)
redstone.setOutput(PUSH_SIDE, true)
os.sleep(3)
redstone.setOutput(PUSH_SIDE, false)
redstone.setOutput(MOVE_SIDE, true)
os.sleep(1)
redstone.setOutput(MOVE_SIDE, false)
redstone.setOutput(SCREW_SIDE, true)
os.sleep(0.25)
redstone.setOutput(SCREW_SIDE, false)
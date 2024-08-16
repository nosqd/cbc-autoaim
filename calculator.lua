local yaw = require "yaw"
local pitch = require "pitch"

local MOVE_SIDE = "front"
local SCREW_SIDE = "left"
local PLACE_SIDE = "right"
local ROTATE_SIDE = "back"
local PUSH_SIDE = "top"
local CANNONS = {
    {
        "cbc_cannon_mount_2", -- peripheral name
        -3, 58, 5, -- coordinates
        -90 -- delta
    },
    {
        "cbc_cannon_mount_3", -- peripheral name
        -3, 58, 6, -- coordinates
        -90 -- delta
    },
    {
        "cbc_cannon_mount_0", -- peripheral name
        -3, 57, 6, -- coordinates
        -90 -- delta
    },
    {
        "cbc_cannon_mount_1", -- peripheral name
        -3, 57, 5, -- coordinates
        -90 -- delta
    }
}
local NUM_CHARGES = 8 -- Number of charges
local LENGTH = 21      -- Length of cannon
local STEP_SIZE = 75  -- Step size for Newton's Method
local TARGET = { 498, 150, -402 }

local result = {}

for i, pos in ipairs(CANNONS) do
    local y = yaw.calculateYawForPosition({ pos[2], pos[4] }, { TARGET[1], TARGET[3] })
    local p = pitch.calculate_pitch(math.sqrt(pos[2] * TARGET[1] + pos[4] * TARGET[3]), math.abs(TARGET[2] - pos[3]), NUM_CHARGES, LENGTH, STEP_SIZE)
    print("cannon " .. i)
    print("> yaw: " .. y)
    print("> pitch: " .. p)
    result[i] = {y, p}
end

if os.getComputerID ~= nil then
    print("reloading")

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

    print("shooting")
    local fncs = {}
    for i, info in ipairs(CANNONS) do
        fncs[i] = function ()
            local p = peripheral.wrap(info[1])
            p.assemble()
            os.sleep(0.1)
            p.setYaw(result[i][1]+ info[5])
            os.sleep(0.5)
            p.setPitch(result[i][2] )
            os.sleep(0.5)
            p.fire()
            p.disassemble()
        end 
    end
    parallel.waitForAll(table.unpack(fncs))
else
    print("skipping executing because not on cc")
end
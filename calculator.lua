local yaw = require "yaw"
local pitch = require "pitch"


local CANNONS = {
    {
        "cbc_cannon_mount_2", -- peripheral name
        -3, 58, 5,            -- coordinates
        -90                   -- delta
    },
    {
        "cbc_cannon_mount_3", -- peripheral name
        -3, 58, 6,            -- coordinates
        -90                   -- delta
    },
    {
        "cbc_cannon_mount_0", -- peripheral name
        -3, 57, 6,            -- coordinates
        -90                   -- delta
    },
    {
        "cbc_cannon_mount_1", -- peripheral name
        -3, 57, 5,            -- coordinates
        -90                   -- delta
    }
}
local NUM_CHARGES = 8 -- Number of charges
local LENGTH = 21     -- Length of cannon
local STEP_SIZE = 75  -- Step size for Newton's Method
local TARGET = { 497, 91, -402 }

local result = {}

local function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

for i, pos in ipairs(CANNONS) do
    local y = yaw.calculateYawForPosition({ pos[2], pos[4] }, { TARGET[1], TARGET[3] })
    local raw_dx = distance(pos[2], pos[4], TARGET[1], TARGET[3])
    local raw_dy = pos[3] - TARGET[2]
    local p = pitch.calculate_pitch(raw_dx, raw_dy,
        NUM_CHARGES, LENGTH, STEP_SIZE)
    print("cannon " .. i)
    print("> target: " .. TARGET[1] .. ", " .. TARGET[2] .. ", " .. TARGET[3])
    print("> position: " .. pos[2] .. ", " .. pos[3] .. ", " .. pos[4])
    print("> raw delta: " .. raw_dx .. ", " .. raw_dy)
    print("> yaw: " .. y)
    print("> pitch: " .. p)
    result[i] = { y, p }
end

if os.getComputerID ~= nil then
    print("aiming")
    local fncs = {}
    for i, info in ipairs(CANNONS) do
        fncs[i] = function()
            local p = peripheral.wrap(info[1])
            p.assemble()
            os.sleep(0.1)
            p.setYaw(result[i][1] + info[5])
            os.sleep(0.5)
            p.setPitch(result[i][2])
            os.sleep(0.5)
        end
    end
    parallel.waitForAll(table.unpack(fncs))
else
    print("skipping executing because not on cc")
end

local yaw = require "lib/yaw"
local pitch = require "lib/pitch"

local CANNONS = {
    {
        -3, 58, 5,
    },
    {
        -3, 58, 6,
    },
    {
        -3, 57, 6,
    },
    {
        -3, 57, 5,
    }
}
local NUM_CHARGES = 8
local LENGTH = 21
local STEP_SIZE = 75
local TARGET = { 497, 91, -402 }

local function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

for i, pos in ipairs(CANNONS) do
    local y = yaw.calculateYawForPosition({ pos[1], pos[3] }, { TARGET[1], TARGET[3] })
    local raw_dx = distance(pos[1], pos[3], TARGET[1], TARGET[3])
    local raw_dy = pos[2] - TARGET[2]
    local p = pitch.calculate_pitch(raw_dx, raw_dy,
        NUM_CHARGES, LENGTH, STEP_SIZE)
    print("cannon " .. i)
    print("> target: " .. TARGET[1] .. ", " .. TARGET[2] .. ", " .. TARGET[3])
    print("> position: " .. pos[1] .. ", " .. pos[2] .. ", " .. pos[3])
    print("> raw delta: " .. raw_dx .. ", " .. raw_dy)
    print("> yaw: " .. y)
    print("> pitch: " .. p)
end
local yaw = require "yaw"
local pitch = require "pitch_orig"

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
local TARGET = { 498, 57, -402 }

local result = {}

function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function calculate_raw_dx_dy(pivot_x, pivot_y, pivot_z, target_x, target_y, target_z, facing)
    local dx = target_x - pivot_x
    local dy = target_y - pivot_y
    local dz = target_z - pivot_z
    
    local raw_dx, raw_dy
    
    if facing == "north" then
        raw_dx = -dz
        raw_dy = dy
    elseif facing == "south" then
        raw_dx = dz
        raw_dy = dy
    elseif facing == "east" then
        raw_dx = dx
        raw_dy = dy
    elseif facing == "west" then
        raw_dx = -dx
        raw_dy = dy
    else
        error("Invalid facing direction. Use 'north', 'south', 'east', or 'west'.")
    end
    
    return raw_dx, raw_dy
end

for i, pos in ipairs(CANNONS) do
    local y = yaw.calculateYawForPosition({ pos[2], pos[4] }, { TARGET[1], TARGET[3] })
    local raw_dx, raw_dy = calculate_raw_dx_dy(pos[2], pos[3], pos[4], TARGET[1], TARGET[2], TARGET[3], "east")
    local p = pitch.calculate_pitch(raw_dx, raw_dy)
    print("cannon " .. i)
    print("> position: " .. pos[2] .. ", " .. pos[3] .. ", " .. pos[4])
    print("> target: " .. TARGET[1] .. ", " .. TARGET[2] .. ", " .. TARGET[3])
    print("> raw delta: " .. raw_dx .. ", " .. raw_dy)
    print("> yaw: " .. y)
    print("> pitch: " .. p)
    result[i] = { y, p }
end
local yaw = require "lib/yaw"
local pitch = require "lib/pitch"

local CANNONS = {peripheral.find("cbc_cannon_mount")}
local NUM_CHARGES = 8 -- Number of charges
local LENGTH = 21     -- Length of cannon
local STEP_SIZE = 75  -- Step size for Newton's Method
local YAW_DELTA = -90
print(CANNONS)

local detector = peripheral.find("playerDetector")
local TARGET_PLAYER = "nosqd"
local function getPlayerPosition()
    return detector.getPlayer(TARGET_PLAYER)
end

local function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

local function aimCannons()
    while true do
        local TARGET = getPlayerPosition()
        local fncs = {}
        for i, cannon in ipairs(CANNONS) do
            local pos = {"", cannon.getX(), cannon.getY(), cannon.getZ()}
            local fnc = function()
                local y = yaw.calculateYawForPosition({ pos[2], pos[4] }, { TARGET.x, TARGET.z })
                local raw_dx = distance(pos[2], pos[4], TARGET.x, TARGET.z)
                local raw_dy = pos[3] - TARGET.y
                local p = pitch.calculate_pitch(raw_dx, raw_dy, NUM_CHARGES, LENGTH, STEP_SIZE)

                print("cannon " .. i)
                print("> target: " .. TARGET.x .. ", " .. TARGET.y .. ", " .. TARGET.z)
                print("> position: " .. pos[2] .. ", " .. pos[3] .. ", " .. pos[4])
                print("> raw delta: " .. raw_dx .. ", " .. raw_dy)
                print("> yaw: " .. y)
                print("> pitch: " .. p)
                cannon.assemble()
                cannon.setYaw(y + YAW_DELTA)
                cannon.setPitch(p * -1)
            end
            fncs[i] = fnc
        end
        parallel.waitForAll(table.unpack(fncs))

        os.sleep(0.1)
    end
end

aimCannons()

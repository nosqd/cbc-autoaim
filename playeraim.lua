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
        for i, pos in ipairs(CANNONS) do
            local fnc = function()
                local y = yaw.calculateYawForPosition({ pos[2], pos[4] }, { TARGET.x, TARGET.z })
                local raw_dx = distance(pos[2], pos[4], TARGET.x, TARGET.z)
                local raw_dy = pos[3] - TARGET.y
                local p = pitch.calculate_pitch(raw_dx, raw_dy, NUM_CHARGES, LENGTH, STEP_SIZE)
                local c = peripheral.wrap(pos[1])

                print("cannon " .. i)
                print("> target: " .. TARGET.x .. ", " .. TARGET.y .. ", " .. TARGET.z)
                print("> position: " .. pos[2] .. ", " .. pos[3] .. ", " .. pos[4])
                print("> raw delta: " .. raw_dx .. ", " .. raw_dy)
                print("> yaw: " .. y)
                print("> pitch: " .. p)
                c.assemble()
                c.setYaw(y + pos[5])
                c.setPitch(p * -1)
            end
            fncs[i] = fnc
        end
        parallel.waitForAll(table.unpack(fncs))

        os.sleep(0.1)
    end
end

aimCannons()

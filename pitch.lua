--[[ 
    Create: Big Cannons pitch calculation code using Newton's Method
    Author: Lugia831999
 ]]
 
-- Variables
local pitch_range = { min = -30, max = 60 }

 
-- Constants
local D = 0.99
local G = -0.05
local K = 0.5 * (D + 1)
local L = 0.5 * G * D
local M = (G * D) / (D - 1)
 
 
--[[ 
    Function to calculate the cannon's target pitch using Newton's Method
 
    raw_dx - Horizontal distance between cannon pivot point and target point
    raw_dy - Vertical distance between cannon pivot and target point
 ]]
function calculate_pitch(raw_dx, raw_dy, num_charges, length, step_size)
    local vel = 2 * num_charges
    local pitch, new_pitch, F_val
    local pitch_limit = math.deg(math.acos( raw_dx / ( K*vel*(D / (1 - D) + 1) + length ) )) - 0.001
    local min_pitch = math.max(pitch_range.min, -pitch_limit)
    local max_pitch = math.min(pitch_range.max, pitch_limit)
 
    local best = { pitch = 0, diff = math.huge }
    
    -- Try max pitch first
    pitch = max_pitch
    F_val, new_pitch = F(pitch, raw_dx, raw_dy, min_pitch, max_pitch, num_charges, length, step_size, vel)
    if math.abs(F_val) < best.diff then best.pitch = pitch; best.diff = math.abs(F_val) end
 
    -- If too high, try min pitch next
    if F_val > 0 then
        pitch = min_pitch
        F_val, new_pitch = F(pitch, raw_dx, raw_dy, min_pitch, max_pitch, num_charges, length, step_size, vel)
        if math.abs(F_val) < best.diff then best.pitch = pitch; best.diff = math.abs(F_val) end
 
        -- If still not good, then return the pitch with best diff
        if F_val > 0 then
            return best.pitch
        end
    end
 
    -- Execute Newton's Method iterations
    for i = 1, 50 do
        pitch = new_pitch
        F_val, new_pitch = F(pitch, raw_dx, raw_dy, min_pitch, max_pitch, num_charges, length, step_size, vel)
        if math.abs(F_val) < best.diff then best.pitch = pitch; best.diff = math.abs(F_val) end
 
        if math.abs(pitch - new_pitch) < 1e-6 then break end
    end
 
    return best.pitch
end
 
 
--[[ 
    The meat and potatoes of the pitch calculation.
    Calculates the vertical difference between the target point and the projectile given the pitch `pitch_deg`.
    Refer to this Desmos graph for a clearer view of the function and more details: https://www.desmos.com/calculator/1xzyp2f2bp
 ]]
function F(pitch_deg, raw_dx, raw_dy, min_pitch, max_pitch, num_charges, length, step_size, vel)
    local pitch = math.rad(pitch_deg)
    local sin_p = math.sin(pitch)
    local cos_p = math.cos(pitch)
    local dx = raw_dx - length * cos_p
    local dy = raw_dy - length * sin_p
 
    local inner_log = ((D - 1) / D) * ((dx / (K*vel*cos_p)) - 1) + 1
    local t = math.log( inner_log, D ) + 1
    local F_val = (L - K*M)*t + ( sin_p + M/vel )*( dx/cos_p ) - dy
    local dF = ( ( -G / (K * inner_log * math.log(D)) + M) * (sin_p / vel) + 1 ) * raw_dx / cos_p^2
 
    local new_pitch = pitch_deg - step_size * (F_val / dF)
    new_pitch = math.min(math.max(new_pitch, min_pitch), max_pitch)
 
    return F_val, new_pitch
end
 
 
return {calculate_pitch = calculate_pitch}
function calculateYawForPosition(myPos, enemyPos)
  -- Calculate the difference in coordinates
  local dx = enemyPos[1] - myPos[1]
  local dz = enemyPos[2] - myPos[2]

  -- Calculate the angle in radians
  local angleRad = math.atan2(dz, dx)

  -- Convert the angle to degrees
  local angleDeg = math.deg(angleRad)

  -- Adjust the angle to be in the range 0-360
  local yaw = (angleDeg + 360) % 360

  return yaw
end

return {calculateYawForPosition = calculateYawForPosition}

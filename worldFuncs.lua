function resetWorld()
  world:destroy()
  world = love.physics.newWorld(0, 0, true)
  world:setCallbacks(nil, nil, nil, postSolveCallback)
  bodies = {planets={}, players={}, bullets={}, missiles={}}
  areas = {}
end

function clearBullets()
  for i=1, #bodies.bullets do
    bodies.bullets[i].body:destroy()
  end
  bodies.bullets = {}
end

function destroyBullet(i) -- index of bullet in bullet table
  bodies.bullets[i].body:destroy()
  table.remove(bodies.bullets, i)
end

function checkSmallObjectsInBounds()
  -- local blt = bodies.bullets
  local plt = bodies.planets

  if #plt > 0 then
    local i = 1
    while i <= #plt do
      if plt[i].body:isDestroyed() then
        table.remove(plt, i)
      else
        local x, y = plt[i].body:getX(), plt[i].body:getY()
        if (plt[i].r < 3) and (x < -MAP_WIDTH or x > MAP_WIDTH or y < -MAP_HEIGHT or y > MAP_HEIGHT) then
          plt[i].body:destroy()
          table.remove(plt, i)
        else
          i = i + 1
        end
      end
    end
  end

  -- if #blt > 0 then
  --   local i = 1
  --   while i <= #blt do
  --     local x, y = blt[i].body:getX(), blt[i].body:getY()
  --     if x <-MAP_WIDTH or x > MAP_WIDTH or y < -MAP_HEIGHT or y > MAP_HEIGHT then
  --       destroyBullet(i)
  --     else
  --       i = i + 1
  --     end
  --   end
  -- end
end

function getBodTable(type)
  if type == "planet" then
    return bodies.planets
  elseif type == "lander" then
     return bodies.players
  elseif type == "bullet" then
     return bodies.bullets
  elseif type == "missile" then
     return bodies.missiles
  end
end

function getBody(type, idNum, table)
  if table == nil then
    table = getBodTable(type)
  end

  for i=1, #table do
    if table[i].id.num == idNum then
      return table[i], i
    end
  end
end

function removeBody(type, idNum)
  tabl = getBodTable(type)
  local b, i = getBody(type, idNum, tabl)
  if b ~= nil then
    b.body:destroy()
    --print("Len before:", #bodies.bullets)
    table.remove(tabl, i)
    --print("Removed body at:", i, "id:", b.id.num, "Len bodies:", #bodies.bullets)
  end
end

function changeHpAfterCollisionFunc()
  local i = 1
  while i <= #changeHpAfterCollision do
    if not changeHpAfterCollision[i].bod.destroyed then
      changeHpAfterCollision[i].bod:changeHp(changeHpAfterCollision[i].change)
      table.remove(changeHpAfterCollision, i)
    else
      i = i + 1
    end
  end
end

function getTotalMassInWorld()
  local bods = world:getBodies()
  total = 0
  for i=1, #bods do
    total = total + bods[i]:getMass()
  end
  return total
end

function checkBulletTimeouts()  -- Needs to be separate from bullet:update due to loop in main update
  local i = 1
  while i <= #bodies.bullets do
    if bodies.bullets[i].totalTime >= BLT_TIMEOUT then
      bodies.bullets[i].body:destroy()
      table.remove(bodies.bullets, i)
    else
      i = i + 1
    end
  end
end

function checkSmallPlanetTimeouts()  -- Needs to be separate from bullet:update due to loop in main update
  local i = 1
  while i <= #bodies.planets do
    if bodies.planets[i].hasTimeout then
      if bodies.planets[i].totalTime >= bodies.planets[i].timeLimit then
        bodies.planets[i].body:destroy()
        table.remove(bodies.planets, i)
      end
    end
    i = i + 1
  end
end

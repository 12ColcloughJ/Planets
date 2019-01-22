require "statusBar"

function HpBar(parent, width, height, pW, pH)
  local h = StatusBar(parent, width, height, pW, pH) -- Inherits
  h.timeOpen = 0
  h.open = false
  h.doingFade = false

  h.alpha = 1

  function h:fade(dt)
    self.alpha = self.alpha - dt*HPBAR_FADE_RATE
    if self.alpha <= 0 then
      self.doingFade = false
      self.open = false
      self.timeOpen = 0
    end
  end

  function h:showEnable()
    self.open = true
    self.timeOpen = 0
    self.alpha = 1
    self.doingFade = false
  end

  function h:getXY()
    local x = self.parentX - (self.width/2)
    local y = self.parentY + (self.pH+10)
    return x, y
  end

  function h:update(dt)
    self.timeOpen = self.timeOpen + dt
    if (self.timeOpen >= HPBAR_OPEN_TIME) and (not self.doingFade) and (self.open) then
      self.doingFade = true
    end

    if self.doingFade then
      self:fade(dt)
    end
  end

  function h:draw()
    if self.open then
      lg.setColor(1, 1, 1, self.alpha)
      self.parentX, self.parentY = self.parent.body:getX(), self.parent.body:getY()
      local x, y = self:getXY()
      self:drawFrame(x, y)
      local normHp = self.parent.hp/self.parent.maxHp
      lg.setColor(1-normHp, normHp, 0, self.alpha)
      lg.rectangle("fill", x+1, y+1, self.width*(normHp)-2, self.height-2) -- -2 for the frame width
    end
  end

  return h
end

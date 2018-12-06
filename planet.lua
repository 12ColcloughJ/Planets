
function Planet(id, pos, vel, m, r)
    local p  = {}
    p.id     = id
    p.pos    = pos or Vec2(0, 0)
    p.vel    = vel or Vec2(0, 0)
    p.mass   = m
    p.radius = r

    function p:getPlanetForces()
        local x_force, y_force = 0, 0

        for i=1, #planets do
            if i ~= self.id then
                local angle = getAngle(self.pos.x, self.pos.y, planets[i].pos.x, planets[i].pos.y)

                local dist  = ((self.pos.x - planets[i].pos.x)^2) + ((self.pos.y - planets[i].pos.x)^2)^0.5     -- Pythag meme
                print(dist, "Dist")

                x_force = x_force + math.cos(angle)*(1/dist)
                y_force = y_force + math.sin(angle)*(1/dist)
            end
        end

        x_force = x_force / (#planets-1)
        y_force = y_force / (#planets-1)

        return x_force, y_force
    end

    function p:applyXForce(dx)
        self.vel.x = self.vel.x + dx
    end

    function p:applyYForce(dy)
        self.vel.y = self.vel.y + dy
    end

    function p:applyVel()
        self.pos.x = self.pos.x + self.vel.x
        self.pos.y = self.pos.y + self.vel.y
    end

    function p:update()
        local x_force, y_force = self:getPlanetForces()

        self:applyXForce(x_force)
        self:applyYForce(y_force)
        self:applyVel()
    end

    function p:draw()
        love.graphics.setColor({255, 255, 255})
        love.graphics.circle("line", self.pos.x, self.pos.y, self.radius)
    end

    table.insert(planets, p)
    return p
end

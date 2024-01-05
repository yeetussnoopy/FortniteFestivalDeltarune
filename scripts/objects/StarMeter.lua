local StarMeter, super = Class(Object)

function StarMeter:init(x, y)
    self.radius = 30 -- radius for the progress ring
    super:init(self, x, y, self.radius * 2, self.radius * 2)
    self:setOrigin(0.5, 0.5)
    self.inner_radius = 20 -- radius for the middle circle

    self.progress = 0      -- value from 0 to 1
    self.draw_prog = 0

    self.activate_threshold = nil
    self.layer = WORLD_LAYERS["ui"]

    self.font = Assets.getFont("main")

    self.draw_width = 200

    self.activate = nil

    self.textdisplay = "Meter: " .. self.progress
end

function StarMeter:draw()
    super:draw(self)
    love.graphics.push()
    love.graphics.translate(self.width / 2, self.height / 2)
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.rectangle("fill", -105, 45, 210, 30)
    love.graphics.setColor(1, 1, 0, self.alpha)

    love.graphics.rectangle("fill", -100, 50, 200, 20)
    love.graphics.setColor(0.5, 0.5, 0.5, self.alpha)
    love.graphics.rectangle("fill", -100, 50, self.draw_width, 20)

    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.setFont(self.font)
    love.graphics.print(self.textdisplay, -100, 10, 0, 0.9)
    love.graphics.pop()
end

function StarMeter:update()
 
    if self.progress > 1 then
        self.draw_prog = 1
    else
        self.draw_prog = self.progress
    end

    self.draw_width = 200 - (200 * self.draw_prog)
    self.textdisplay = "Star Meter: " .. (self.progress * 100) .. "%"
    if self.progress >= self.activate_threshold then
        self.textdisplay = "(Press " .. self.activate .. ") Meter: " .. (self.progress * 100) .. "%"
    end
end

return StarMeter

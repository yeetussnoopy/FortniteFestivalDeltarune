local GuitarHeroHitCircle, super = Class(Object)

function GuitarHeroHitCircle:init(x, y, speed, color1, isStar)
    self.speed = speed
    super:init(self, x, y)
    --self.rotation = angle
    self:setOrigin(0, 0)
    self.radius = 4
    self.layer = WORLD_LAYERS["above_ui"] + 300

    self.color1 = color1
    self.star_check = isStar

    self:setScale(4, 4)

    self.pressed = false
    self.collider = CircleCollider(self, 0, 0 + self.radius, 2)
    self.collider.y = self.collider.y - 4
end

function GuitarHeroHitCircle:update()
    if self.y < 100 then
        self.y = Utils.approach(self.y, 101, self.speed * DTMULT)
    else
        self:remove()
    end
    super:update(self)
end

function GuitarHeroHitCircle:draw()
if self.star_check then
    love.graphics.setColor(1,1,0, 1)
    love.graphics.polygon("line", {-4,2,0,-4,4,2})

else
    love.graphics.setLineWidth(1)
    if self.color1 == "red" then
    love.graphics.setColor(1,0,0, 1)
    elseif self.color1 == "purple" then
    love.graphics.setColor(1,0,1, 1)
elseif self.color1 == "green" then
    love.graphics.setColor(0,1,0, 1)

    end
    love.graphics.circle("line", 0, 0, self.radius)

end
    super:draw(self)
    if DEBUG_RENDER then
        self.collider:draw(1, 0, 0)
    end
end

function GuitarHeroHitCircle:setSprite(sprite)
    if self.sprite then
        self.sprite:remove()
    end
    self.sprite = Sprite(sprite, 0, 0)
    self:addChild(self.sprite)
    self:setSize(self.sprite:getSize())
end

return GuitarHeroHitCircle

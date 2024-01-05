local GuitarHeroConfirmCircle, super = Class(Object)

function GuitarHeroConfirmCircle:init(x, y, letter, color1, norm, star)
    self.radius = 20 -- radius for the progress ring

    super:init(self, x, y)
    self.letter = letter
    self.color1 = color1
    self.mutiplier = 1

    self.norm_point = norm
    self.star_point = star

    self.success = false
    self:setOrigin(0.5, 0.5)

    self.collider = CircleCollider(self, 0, 0, self.radius)

    self.inner_radius = 15 -- radius for the middle circle

    self.layer = WORLD_LAYERS["above_ui"]

    self.font = Assets.getFont("main")

    if self.color1 == "red" then
        self.colorrr = COLORS.red
    elseif self.color1 == "purple" then
        self.colorrr = COLORS.fuchsia
    elseif self.color1 == "green" then
        self.colorrr = COLORS.lime
    end
    self.star_score = 0

    self.score = 0
    self.shot = nil
end

function GuitarHeroConfirmCircle:update()
    self.sel1 =Game.stage:getObjects(GuitarHero)[1]

    if Input.pressed(self.letter) then
        local collided_bullets = {}
        local missed = false
        Object.startCache()
        for _, bullet in ipairs(Game.stage:getObjects(GuitarHeroHitCircle)) do
            if bullet:collidesWith(self.collider) then
                table.insert(collided_bullets, bullet)
            else
                missed = true
            end
        end

        Object.endCache()
        if missed then
            self.score = self.score - 10
            missed = false
        end
        for _, bullet in ipairs(collided_bullets) do
            Assets.playSound("back_attack")

            self.success = true
            local score_add =0
            if self.mutiplier == 1 then
                score_add = self.norm_point * 2
            else
                score_add = ((self.norm_point * 2) * self.mutiplier) - self.norm_point
            end
                
            self.score = self.score + score_add --it double counts that missed even when you dont miss? idk it works
            local clour
            clour = self.colorrr
            if bullet.star_check then
                clour=COLORS.yellow
                self.star_score = self.star_score+self.star_point
            else
                
        end
        local px1, py1 = self:getScreenPos()

        local pe =ParticleEmitter( px1,py1 , {
            texture    = "star",
            color      = clour,
            alpha      = { 0.7, 0.9 },
            size       = { 10, 20 },
            grow       = 0.2,
            dist       = 1,
            spin       = 0.2,
            speed      = { 2, 4 },
            --friction = 0.5,
            fade       = 0.04,
            fade_after = 0.1,
            amount     = { 4, 9 },
            layer = WORLD_LAYERS["above_ui"] + 5
            ,
        })
        pe:setLayer(WORLD_LAYERS["above_ui"] + 5)
        Game.stage:addChild(pe)

        bullet:remove()

        end

    end
    super:update(self)
end

function GuitarHeroConfirmCircle:draw()
    super:draw(self)
    love.graphics.push()
    love.graphics.translate(self.width / 2, self.height / 2)
    love.graphics.setColor(COLORS.white)
    love.graphics.setLineWidth(1.3)

    love.graphics.line(0, 0, 0, -400)

    love.graphics.setColor(1, 1, 1, self.alpha - 0.4)
    love.graphics.arc("fill", "pie", 0, 0, self.radius, -math.pi / 2, -math.pi / 2 + (math.pi * 2 * 1)) -- progress part of ring
    love.graphics.setColor(0, 0, 0, self.alpha)
    love.graphics.circle("fill", 0, 0, self.inner_radius)                                                           -- middle circle of ring



    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.setFont(self.font)
    love.graphics.print(self.letter, -7, -16)



    love.graphics.pop()

    if DEBUG_RENDER then
        self.collider:draw(1, 0, 0)
    end
end

function GuitarHeroConfirmCircle:spawnShot(speed)
    self.shot = GuitarHeroHitCircle(0, 0, speed, self.color1, false)
    self.shot.layer = self.layer + 1
    self.shot.y = -400
    self:addChild(self.shot)
end

function GuitarHeroConfirmCircle:spawnStarShot(speed)
    self.shot = GuitarHeroHitCircle(0, 0, speed, self.color1, true)
    self.shot.layer = self.layer + 1
    self.shot.y = -400
    self:addChild(self.shot)

end

return GuitarHeroConfirmCircle

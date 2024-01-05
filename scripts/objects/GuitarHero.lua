local GuitarHero, super = Class(Object)

function GuitarHero:init(x, y)
    self.radius = 30
    self.letter = letter
    self.music = Music()
    self.speed = speed
    super:init(self, x, y)
    self.layer = 0
    self.mutiplier = 1

    --name of the music track
    self.music:play("Big_shot")

    self.star_point = 10
    self.normal_point = 10

    --letters correspond to the keyboard you press
    self.button1 = GuitarHeroConfirmCircle(15, 400, "f", "red",  self.normal_point, self.star_point) 
    self.button2 = GuitarHeroConfirmCircle(70, 400, "g", "purple",self.normal_point, self.star_point)
    self.button3 = GuitarHeroConfirmCircle(125, 400, "h", "green",self.normal_point, self.star_point)
    
    --self explanatory
    self.star_meter_score_mutiplier_activate_key = "u"
    self.star_meter_activate_threshold = 0.5


    self:setOrigin(0.5, 0.5)
    self.box = UIBox(0, 0, 150, 350)
    self.box.layer = 10000
    self.box.debug_select = true
    self.negative_star_score = 0

    self.box.y = self.box.y - 40
    self:addChild(self.box)

    self.text = Text("", -252, 317, (SCREEN_WIDTH - 100 * 2) + 14, SCREEN_HEIGHT, nil, "GONER")
    self.text.parallax_x = 0
    self.text.parallax_y = 0
    self.text:setLayer(WORLD_LAYERS.top)
    self.box:addChild(self.text)

    self.star_meter = StarMeter(-150, 300)
    self.star_meter.activate = self.star_meter_score_mutiplier_activate_key
    self.star_meter.activate_threshold = self.star_meter_activate_threshold
    self:addChild(self.star_meter)

    self.cur = 1

    self.total_score = 0 --ur total score lol

    self.text:setText("Score: " .. self.total_score)


    --self.enable_ghost_tapping = true --losing points if you whiff

    self.box:addChild(self.button1)
    self.box:addChild(self.button2)
    self.box:addChild(self.button3)

    self.button2:spawnShot(4)
    self.button3:spawnShot(5)
    self.button2:spawnShot(6)
    self.button1:spawnShot(7)

    self.button1:spawnStarShot(10)
    self.button2:spawnStarShot(12)
    self.button3:spawnStarShot(14)

    self.counter = 0
end

function GuitarHero:update()

    --the way music is generated is so scuffed but like :skull: i cant think of anything better for now

     if self.music:tell() > 3.01 and self.music:tell() < 3.03 and self.cur == 1 then
        self.button1:spawnShot(3)
        self.button2:spawnStarShot(7)
        self.button3:spawnShot(5)
        self.cur = 2
    elseif self.music:tell() > 5.01 and self.music:tell() < 5.02 and self.cur == 2 then
        self.button1:spawnShot(4)
        self.button3:spawnShot(4)
        self.cur = 3
    elseif self.music:tell() > 6.01 and self.music:tell() < 6.02 and self.cur == 3 then
        self.button2:spawnShot(7)
        self.button2:spawnShot(8)
        self.button2:spawnStarShot(9)
        self.cur = 4
    elseif self.music:tell() > 7.01 and self.music:tell() < 7.02 and self.cur == 4 then
        self.button1:spawnShot(5)
        self.button2:spawnStarShot(5)
        self.button3:spawnShot(5)
        self.cur = 5
    elseif self.music:tell() > 9.01 and self.music:tell() < 9.02 and self.cur == 5 then
        self.button1:spawnShot(5)
        self.button2:spawnShot(4)
        self.button3:spawnShot(5)
        self.cur = 6
    elseif self.music:tell() > 11.01 and self.music:tell() < 11.02 and self.cur == 6 then
        self.button1:spawnShot(7)
        self.button1:spawnShot(9)
        self.button2:spawnShot(8)
        self.button3:spawnStarShot(5)
        self.button3:spawnShot(4)

        self.cur = 7
    elseif self.music:tell() > 13.01 and self.music:tell() < 13.02 and self.cur == 7 then
        self.button1:spawnShot(5)
        self.button2:spawnStarShot(7)
        self.button3:spawnShot(9)
        self.cur = 8
    elseif self.music:tell() > 15.01 and self.music:tell() < 15.02 and self.cur == 8 then
        self.button1:spawnShot(9)
        self.button2:spawnShot(10)
        self.cur = 9
    end
    

    if Input.pressed(self.star_meter_score_mutiplier_activate_key) then
        if self.star_meter.progress >= self.star_meter_activate_threshold then
            
        self.mutiplier = self.mutiplier + 1
        self.negative_star_score = self.negative_star_score + ((self.star_meter_activate_threshold * 10) * self.star_point)
        Assets.playSound("cardrive")

        end

    end

    self.button1.mutiplier = self.mutiplier
    self.button2.mutiplier = self.mutiplier
    self.button3.mutiplier = self.mutiplier

    self.total_score = (self.button1.score + self.button2.score + self.button3.score) 
    self.total_star_score = (self.button1.star_score + self.button2.star_score + self.button3.star_score)  - self.negative_star_score
    self.star_meter.progress = self.total_star_score/100
    
    self.text:setText("Score: " .. self.total_score.. " (x".. self.mutiplier..")")


   
    super:update(self)
end

function GuitarHero:draw()
    super:draw(self)
end
return GuitarHero

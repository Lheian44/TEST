_G.love = require("love")


function love.load()
    

    camera = require "libraries/camera"
    cam = camera()

    cameraBorder = 2.8

    anim8 = require "libraries/anim8"
    love.graphics.setDefaultFilter("nearest", "nearest")

    sti = require "libraries/sti"
    gameMap = sti("maps/testmap.lua")

    player = {}
    player.x = 400
    player.y = 250
    player.speed = 1.2
    player.sprite = love.graphics.newImage("sprites/parrot.png")
    player.spriteSheet = love.graphics.newImage("sprites/player-sheet.png")
    player.grid = anim8.newGrid( 12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight() )

    player.animations = {}
    player.animations.down = anim8.newAnimation( player.grid('1-4', 1), 0.2 )
    player.animations.left = anim8.newAnimation( player.grid('1-4', 2), 0.2 )
    player.animations.right = anim8.newAnimation( player.grid('1-4', 3), 0.2 )
    player.animations.up = anim8.newAnimation( player.grid('1-4', 4), 0.2 )

    player.anim = player.animations.left

    background = love.graphics.newImage("sprites/background.png")
end

function love.update(dt)
    local isMoving = false

    if love.keyboard.isDown("right") then
        player.x = player.x + player.speed
        player.anim = player.animations.right
        isMoving = true 
    end

    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed
        player.anim = player.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("down") then
        player.y = player.y + player.speed
        player.anim = player.animations.down
        isMoving = true
    end

    if love.keyboard.isDown("up") then
        player.y = player.y - player.speed
        player.anim = player.animations.up
        isMoving = true
    end 

    if isMoving == false then 
        player.anim:gotoFrame(2)
    end

    player.anim:update(dt)

    cam:lookAt( player.x, player.y )

    

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    
    if cam.x < w/cameraBorder then 
        cam.x = w/cameraBorder
    end

    if cam.y < h/cameraBorder then 
        cam.y = h/cameraBorder
    end

    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    if cam.x > (mapW - w/cameraBorder) then 
        cam.x = (mapW - w/cameraBorder)
    end

    if cam.y > (mapH - h/cameraBorder) then 
        cam.y = (mapH - h/cameraBorder)
    end

    cam.scale = 1.4
    
end


function love.draw()  
    cam:attach()
        gameMap:drawLayer(gameMap.layers["background"])
        gameMap:drawLayer(gameMap.layers["tress and bush"])
        gameMap:drawLayer(gameMap.layers["buildings"])
        player.anim:draw( player.spriteSheet, player.x, player.y, nil, 1, nil, 6, 9 )
   cam:detach()
    --a
end



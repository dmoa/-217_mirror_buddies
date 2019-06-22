function love.load()
    WW, WH = love.graphics:getDimensions()
    scale = 4
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    -- player + mirrored player
    player = {
        {
            image = love.graphics.newImage("player1.png"),
            tileX = 4,
            tileY = 2
        },
        {
            image = love.graphics.newImage("player2.png"),
            tileX = 5,
            tileY = 2
        }
    }
    bgImage = love.graphics.newImage("bg.png")
    startImage = love.graphics.newImage("start.png")
    playing = false
    maxTime = 1.5
    timer = maxTime
    spawning = false

    evilImage = love.graphics.newImage("enemy.png")
    evilBlocks = {}

    gameLoop = love.audio.newSource("gameLoop.wav", "static")
    gameLoop:setLooping(true)

    font = love.graphics.newFont(35)
    timerText = love.graphics.newText(font, tostring(math.ceil(timer * 10) / 10))
end

function love.draw()
    if playing then
        love.graphics.draw(bgImage, 0, 0, 0, scale, scale)
        for _, block in ipairs(evilBlocks) do
            love.graphics.draw(evilImage,(block.tileX - 1) * scale * 16, (block.tileY - 1) * scale * 16, 0, scale, scale)
        end
        love.graphics.draw(player[1].image, (player[1].tileX - 1) * scale * 16, (player[1].tileY - 1) * scale * 16, 0, scale, scale)
        love.graphics.draw(player[2].image, (player[2].tileX - 1) * scale * 16, (player[2].tileY - 1) * scale * 16, 0, scale, scale)
    else
        love.graphics.draw(startImage, 0, 0, 0, scale, scale)
    end
    love.graphics.draw(timerText)
end

function love.update(dt)
    if playing then
        if spawning then
            timer = timer - dt
            if timer < 0 then
                if hasDied() then 
                    playing = false 
                    gameLoop:stop()
                end
                spawnBlocks()
                maxTime = maxTime - 0.1
                timer = maxTime
            end
        end
        timerText = love.graphics.newText(font, tostring(math.ceil(timer * 10) / 10))
    end
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end
    if key == "space" and not playing then
        gameLoop:play()
        playing = true
        player = {
            {
                image = love.graphics.newImage("player1.png"),
                tileX = 4,
                tileY = 2
            },
            {
                image = love.graphics.newImage("player2.png"),
                tileX = 5,
                tileY = 2
            }
        }
        spawning = true
        evilBlocks = {}
        maxTime = 1.5
    end
    if key == "a" and player[1].tileX > 1 then 
        player[1].tileX = player[1].tileX - 1
        player[2].tileX = player[2].tileX + 1
    end
    if key == "d" and player[1].tileX < 4 then 
        player[1].tileX = player[1].tileX + 1
        player[2].tileX = player[2].tileX - 1
    end
    if key == "w" and player[1].tileY > 1 then 
        player[1].tileY = player[1].tileY - 1
        player[2].tileY = player[2].tileY - 1
    end
    if key == "s" and player[1].tileY < 4 then 
        player[1].tileY = player[1].tileY + 1
        player[2].tileY = player[2].tileY + 1
    end
end

function spawnBlocks()
    evilBlocks = {}
    for i = 1, 10 do
        table.insert(evilBlocks, {tileX = math.ceil(love.math.random(8)), tileY = math.ceil(love.math.random(4))})
    end
end

function hasDied()
    for _, block in ipairs(evilBlocks) do
        if (block.tileX == player[1].tileX and block.tileY == player[1].tileY) or 
        (block.tileX == player[2].tileX and block.tileY == player[2].tileY) then
            return true
        end
    end
end
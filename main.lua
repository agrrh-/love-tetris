-- ------------------------------------------
-- I, O, L, r, S, Z, T
figures = {
    { -- O
        color = { 255, 255, 255 },
        offset = {0, -1},
        map = {
            {0,0,0,0},
            {0,1,1,0},
            {0,1,1,0},
            {0,0,0,0}
        }
    },
    { -- I
        color = { 0, 255, 255 },
        offset = {0, -2},
        map = {
            {0,0,0,0},
            {0,0,0,0},
            {1,1,1,1},
            {0,0,0,0}
        }
    },
    { -- L
        color = { 255, 0, 255 },
        offset = {0, -1},
        map = {
            {0,0,0,0},
            {0,0,1,0},
            {1,1,1,0},
            {0,0,0,0}
        }
    },
    { -- r
        color = { 255, 0, 0 },
        offset = {0, -1},
        map = {
            {0,0,0,0},
            {0,1,0,0},
            {0,1,1,1},
            {0,0,0,0}
        }
    },
    { -- S
        color = { 0, 255, 0 },
        offset = {0, -1},
        map = {
            {0,0,0,0},
            {0,0,1,1},
            {0,1,1,0},
            {0,0,0,0}
        }
    },
    { -- Z
        color = { 0, 0, 255 },
        offset = {0, -1},
        map = {
            {0,0,0,0},
            {1,1,0,0},
            {0,1,1,0},
            {0,0,0,0}
        }
    },
    { -- T
        color = { 255, 255, 0 },
        offset = {0, -1},
        map = {
            {0,0,0,0},
            {0,0,1,0},
            {0,1,1,1},
            {0,0,0,0}
        }
    }
}

-- ------------------------------------------

function love.load()
    blockImage = love.graphics.newImage("res/block.png")
    blockBgImage = love.graphics.newImage("res/block_bg.png")

    window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()

    field_width_blocks = 10
    field_height_blocks = 20

    block_size = 32
    block_scale = block_size / blockImage:getWidth()

    field_width = field_width_blocks * block_size
    field_height = field_height_blocks * block_size

    scoreboard_width = window_width - field_width * block_size
    scoreboard_height = window_height

    clrMain = {255, 255, 255, 255}
    clrBg = {0, 0, 0, 255}
    clrBgAlt = {32, 32, 32, 255}
    clrBlock = {127, 255, 127, 255}

    score = 0
    isAlive = true

    -- active and next figures
    figure_a = figures[love.math.random(#figures)]
    figure_n = figures[love.math.random(#figures)]

    direction = false
    rotation = false
end

function love.keypressed(key)
    if key == "up" then
        rotation = true
    --elseif key == "down" then
    --    direction = "down"
    elseif key == "left" then
        direction = "left"
    elseif key == "right" then
        direction = "right"
    elseif key == "escape" then
        love.event.quit()
    end
end

function love.update(dt)
    --while isAlive do
    --end
end

function love.draw()
    -- love.graphics.setBackgroundColor(255, 255, 255)

    update_scoreboard()
    draw_field()

    if figure_a then
        draw_figure_at_field(figure_a, 0, 0)
    end
end

----------------------------------------------------------------------

function draw_figure_at_field(figure, posx, posy)
    x = 1
    while x <= 4 do
        y = 1
        while y <= 4 do
            if figure['map'][y][x] == 1 then
                draw_block_at_field(
                    posx + x - 1 + figure['offset'][1],
                    posy + y - 1 + figure['offset'][2],
                    figure['color']
                )
            end
            y = y + 1
        end
        x = x + 1
    end
end

function draw_block_at_field(x, y, color)
    love.graphics.setColor( color )

    love.graphics.draw(
        blockImage,
        x * block_size,
        y * block_size,
        0, block_scale, block_scale
    )
end

function update_scoreboard()
    love.graphics.setColor( clrBgAlt )
    love.graphics.rectangle(
        "fill",
        field_width, 0,
        scoreboard_width, scoreboard_height
    )

    love.graphics.setColor( clrMain )
    love.graphics.print(
        "Score: " .. score,
        field_width + 16,
        16
    )
end

function draw_field()
    love.graphics.setColor( clrMain )
    w = 0
    while w < field_width_blocks do
        h = 0
        while h < field_height_blocks do
            love.graphics.draw(
                blockBgImage,
                w * block_size,
                h * block_size,
                0, block_scale, block_scale
            )

            h = h + 1
        end
        w = w + 1
    end
end

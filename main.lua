-- ------------------------------------------
-- I, O, L, r, S, Z, T
figures = {
    { -- O
        {0,0,0,0},
        {0,1,1,0},
        {0,1,1,0},
        {0,0,0,0}
    },
    { -- I
        {0,0,0,0},
        {0,0,0,0},
        {1,1,1,1},
        {0,0,0,0}
    },
    { -- L
        {0,0,0,0},
        {0,0,1,0},
        {1,1,1,0},
        {0,0,0,0}
    },
    { -- r
        {0,0,0,0},
        {0,1,0,0},
        {0,1,1,1},
        {0,0,0,0}
    },
    { -- S
        {0,0,0,0},
        {0,0,1,1},
        {0,1,1,0},
        {0,0,0,0}
    },
    { -- Z
        {0,0,0,0},
        {1,1,0,0},
        {0,1,1,0},
        {0,0,0,0}
    },
    { -- T
        {0,0,0,0},
        {0,0,1,0},
        {0,1,1,1},
        {0,0,0,0}
    }
}

figures = {
    { -- test single block
        {0,0,0,0},
        {0,0,1,0},
        {0,0,0,0},
        {0,0,0,0}
    }
}

clrBg = {0,0,0}
clrFieldBg = {32,32,32}
clrFieldBorder = {92,92,92}
clrMain = {255,255,255}

block_size = 32
field_w = 10
field_h = 20

figure_a = figures[love.math.random(#figures)]
figure_a_x = 3
figure_a_y = 0
figure_n = figures[love.math.random(#figures)]

-- ------------------------------------------

function love.load()
    window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()

    love.graphics.setBackgroundColor(clrBg)
end

function love.update(dt)

end

function love.draw()
    draw_interface()

    draw_figure_field(figure_a, figure_a_x, figure_a_y)
    draw_figure_side(figure_n)
end

-- ------------------------------------------

function draw_figure_field(figure, posx, posy)
    y = 1
    while y < 5 do
        x = 1
        while x < 5 do
            if figure[y][x] == 1 then
                posxd = (posx + x) * block_size
                posyd = (posy + y) * block_size
                draw_block(posxd, posyd, clrMain)
            else
                posxd = (posx + x) * block_size
                posyd = (posy + y) * block_size
                draw_block(posxd, posyd, clrFieldBg)
            end
            x = x + 1
        end
        y = y + 1
    end
end

function draw_figure_side(figure)
    y = 1
    while y < 5 do
        x = 1
        while x < 5 do
            if figure[y][x] == 1 then
                posx = (field_w + x + 0.5) * block_size
                posy = (y + 0.5) * block_size
                draw_block(posx, posy, clrMain)
            end
            x = x + 1
        end
        y = y + 1
    end
end

function draw_block(posx, posy, color)
    love.graphics.setColor(color)
    love.graphics.rectangle("fill",
        posx - block_size,
        posy - block_size,
        block_size,
        block_size
    )
end

function draw_interface()
    love.graphics.setColor(clrFieldBg)
    love.graphics.rectangle("fill", 0, 0, field_w * block_size, field_h * block_size)

    love.graphics.setColor(clrFieldBorder)
    y = 0
    while y <= field_h * block_size do
        x = 0
        while x <= field_w * block_size do

            love.graphics.line(x, 0, x, window_height)
            love.graphics.line(0, y, field_w * block_size, y)
            x = x + block_size
        end
        y = y + block_size
    end

    love.graphics.setColor(clrFieldBorder)
    love.graphics.rectangle( "line",
        (field_w + 0.5) * block_size,
        0.5 * block_size,
        block_size*4,
        block_size*4
    )
end

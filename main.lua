-- ------------------------------------------

-- test single block
figures = {
    {
        {0,0,0,0},
        {0,0,1,0},
        {0,0,0,0},
        {0,0,0,0}
    }
}

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

field = {
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {1,1,1,1,0,0,0,1,1,1},
    {1,1,1,1,0,0,0,1,1,1}
}

clrBg = {0,0,0}
clrFieldBg = {32,32,32}
clrFieldBorder = {92,92,92}
clrMain = {255,255,255}

block_size = 32
field_w = 10
field_h = 20

figure_a = figures[love.math.random(#figures)]
figure_a_fallen = false
figure_a_x = 3
figure_a_y = 0
figure_n = figures[love.math.random(#figures)]

dx = 0
rotation = false
force_fall = false

music_enabled = true
sound_enabled = true

is_alive = true
points = 0

delta = 0

-- ------------------------------------------

function love.load()
    window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()

    love.graphics.setBackgroundColor(clrBg)

    music = love.audio.newSource('res/ost.mp3')
    love.audio.play(music)

    sound_correct = love.audio.newSource('res/correct.wav')
    sound_wrong = love.audio.newSource('res/wrong.wav')
end

function love.keypressed(key, unicode)
    if key == 'escape' then
        r = love.event.quit()
    elseif key == 'w' or key == 'up' then
        rotation = true
    elseif key == 'a' or key == 'left' then
        dx = -1
    elseif key == 'd' or key == 'right' then
        dx = 1
    elseif key == 's' or key == 'down' then
        force_fall = true
    elseif key == 'm' then
        if music_enabled then
            love.audio.stop(music)
            love.audio.rewind(music)
            music_enabled = false
        else
            music_enabled = true
            love.audio.play(music)
        end
    elseif key == 'n' then
        if sound_enabled then
            sound_enabled = false
        else
            sound_enabled = true
        end
    end
end

function love.update(dt)
    if not is_alive then
        return true
    end

    delta = delta + dt

    if rotation then
        rotation = false

        if check_if_rotation_available(figure_a, figure_a_x, figure_a_y) then
            figure_a = rotate(figure_a)
        else
            play_sound(sound_wrong)
        end
    end

    if dx ~= 0 then
        mx = check_if_move_available(figure_a, figure_a_x, figure_a_y, dx)
        if mx == 0 then
            play_sound(sound_wrong)
        end
        dx = dx * mx
        figure_a_x = figure_a_x + dx
        dx = 0
    end

    if delta > .1 then
        figure_a_fallen = do_the_gravity(field, figure_a, figure_a_x, figure_a_y)

        if figure_a_fallen then
            merge_figure(field, figure_a, figure_a_x, figure_a_y)
            play_sound(sound_correct)

            gained_points = remove_filled()
            if gained_points > 0 then
                points = points + gained_points
            end

            figure_a = figure_n
            figure_a_x = 3
            figure_a_y = 0
            -- TODO check if game is over
                -- is_alive = false
                -- figure_a = do an empty figure here
            figure_n = figures[love.math.random(#figures)]
        end

        delta = 0
    end
end

function love.draw()
    draw_interface()
    draw_field(field)

    draw_figure_field(figure_a, figure_a_x, figure_a_y)
    draw_figure_side(figure_n)
end

-- ------------------------------------------

function remove_filled()
    removed_lines = 0

    y = field_h
    while y > 0 do
        filled_cells = 0
        for x = 1, field_w do
            print(x)
            filled_cells = filled_cells + field[y][x]
        end
        if filled_cells == 10 then
            i = y
            while i > 0 do
                if i > 1 then
                    field[i] = field[i-1]
                else
                    field[i] = {0,0,0,0,0,0,0,0,0,0}
                end
                i = i - 1
            end
            removed_lines = removed_lines + 1
        else
            y = y - 1
        end
    end

    return calculate_points(removed_lines)
end

function calculate_points(lines)
    if lines == 0 then
        return 0
    else
        return lines + calculate_points(lines-1)
    end
end

function check_if_rotation_available(figure, posx, posy)
    phantom_figure = {
        {},{},{},{}
    }

    phantom_figure = rotate(figure)

    y = 1
    while y < 5 do
        x = 1
        while x < 5 do
            if phantom_figure[y][x] == 1 then
                if posx+x+dx > field_w or posx+x+dx < 1 then
                    return false
                elseif field[posy+y][posx+x+dx] == 1 then
                    return false
                end
            end
            x = x + 1
        end
        y = y + 1
    end

    return true
end

function rotate(matrix_in)
    matrix_out = {
        {},{},{},{}
    }

    for j = 1, 4 do
        for i = 1, 4 do
            matrix_out[j][5-i] = matrix_in[i][j]
        end
    end

    return matrix_out
end

function play_sound(sound)
    if sound_enabled then
        love.audio.play(sound)
        love.audio.rewind(sound)
    end
end

function check_if_move_available(figure, posx, posy, dx)
    mx = 1

    y = 1
    while y < 5 do
        x = 1
        while x < 5 do
            if figure[y][x] == 1 then
                if posx+x+dx > field_w or posx+x+dx < 1 then
                    mx = 0
                elseif field[posy+y][posx+x+dx] == 1 then
                    mx = 0
                end
            end
            x = x + 1
        end
        y = y + 1
    end

    return mx
end

function merge_figure(field, figure, posx, posy)
    y = 1
    while y < 5 do
        x = 1
        while x < 5 do
            if figure[y][x] == 1 then
                field[posy+y][posx+x] = 1
            end
            x = x + 1
        end
        y = y + 1
    end
end

function do_the_gravity(field, figure, posx, posy)
    is_fallen = false

    y = 1
    while y < 5 do
        x = 1
        while x < 5 do
            if figure[y][x] == 1 then
                if posy + y + 1 > field_h or field[posy+y+1][posx+x] == 1 then
                    is_fallen = true
                end
            end
            x = x + 1
        end
        y = y + 1
    end

    if is_fallen then
        return true
    else
        figure_a_y = figure_a_y + 1
        return false
    end
end

function draw_field(field)
    y = 1
    while y < field_h + 1 do
        x = 1
        while x < field_w + 1 do
            if field[y][x] == 1 then
                posxd = x * block_size
                posyd = y * block_size
                draw_block(posxd, posyd, clrFieldBorder)
            end
            x = x + 1
        end
        y = y + 1
    end
end

function draw_figure_field(figure, posx, posy)
    y = 1
    while y < 5 do
        x = 1
        while x < 5 do
            if figure[y][x] == 1 then
                posxd = (posx + x) * block_size
                posyd = (posy + y) * block_size
                draw_block(posxd, posyd, clrMain)
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

local M = {}

local function to_6cube_index(v)
    if v < 48 then return 0 end
    if v < 114 then return 1 end
    return math.floor((v - 35) / 40)
end

local q2c = { 0x00, 0x5f, 0x87, 0xaf, 0xd7, 0xff }
local function to_6cube(v)
    local i = to_6cube_index(v)
    return i, q2c[i + 1]
end

local function dist_squared(R, G, B, r, g, b)
    local dr, dg, db = R - r, G - g, B - b
    return dr * dr + dg * dg + db * db
end

-- Convert an RGB triplet to the xterm(1) 256 color palette.
-- 
-- xterm provides a 6x6x6 color cube (16 - 231) and 24 greys (232 - 255). We
-- map our RGB color to the closest in the cube, also work out the closest
-- grey, and use the nearest of the two.
-- 
-- Note that the xterm has much lower resolution for darker colours (they are
-- not evenly spread out), so our 6 levels are not evenly spread: 0x0, 0x5f
-- (95), 0x87 (135), 0xaf (175), 0xd7 (215) and 0xff (255). Greys are more
-- evenly spread (8, 18, 28 ... 238).
-- 
-- Based on the original implementation by Avi Halachami, see:
-- https://github.com/tmux/tmux/commit/d9450bfccd3dc0c55c412a1871a70d3e94dd7be6
-- 
---@param r integer
---@param g integer
---@param b integer
---@return integer
function M.closest_xterm(r, g, b)
    -- Map RGB to 6x6x6 cube
    local qr, cr = to_6cube(r)
    local qg, cg = to_6cube(g)
    local qb, cb = to_6cube(b)

    -- If the color does not immediately match and its grey scale
    -- equivalent (average of RGB) is closer than the 6x6x6 cube value,
    -- then use this gray value.
    if cr ~= r or cg ~= g or cb ~= b then
        local grey_avg = math.floor((r + g + b) / 3)
        local grey_idx = grey_avg > 238 and 23 or math.floor((grey_avg - 3) / 10)
        local grey = 8 + (10 * grey_idx)

        local d_c6 = dist_squared(cr, cg, cb, r, g, b)
        local d_grey = dist_squared(grey, grey, grey, r, g, b)

        if d_grey < d_c6 then return 232 + grey_idx end
    end
    -- Otherwise, fallback to the 6x6x6 value
    -- (perfect if color did match, but suboptimal otherwise)
    return 16 + (36 * qr) + (6 * qg) + qb
end

---Convert a hex color string to its RGB components.
---Each component is parsed on its own and becomes nil if invalid.
---@param hex string -- e.g. #C0FFEE (#<R><G><B>, 7 bytes)
---@return integer?
---@return integer?
---@return integer?
function M.split_hex(hex)
    local r = tonumber(hex:sub(2, 3), 16)
    local g = tonumber(hex:sub(4, 5), 16)
    local b = tonumber(hex:sub(6, 7), 16)
    return r, g, b
end

---Convert a hex color string to a xterm(1) 256 color palette value.
---Returns nil if the given string is not in the expected format.
---@param hex string -- e.g. #C0FFEE (#<R><G><B>, 7 bytes)
---@return integer?
function M.hex_to_xterm(hex)
    local r, g, b = M.split_hex(hex)
    if r and g and b then return M.closest_xterm(r, g, b) end
end

return M

-- code128-encode.lua by ywnico

-- Code 128 encoding following https://en.wikipedia.org/wiki/Code_128

local patterns = {
    [0]   = {1,1,0,1,1,0,0,1,1,0,0},
    [1]   = {1,1,0,0,1,1,0,1,1,0,0},
    [2]   = {1,1,0,0,1,1,0,0,1,1,0},
    [3]   = {1,0,0,1,0,0,1,1,0,0,0},
    [4]   = {1,0,0,1,0,0,0,1,1,0,0},
    [5]   = {1,0,0,0,1,0,0,1,1,0,0},
    [6]   = {1,0,0,1,1,0,0,1,0,0,0},
    [7]   = {1,0,0,1,1,0,0,0,1,0,0},
    [8]   = {1,0,0,0,1,1,0,0,1,0,0},
    [9]   = {1,1,0,0,1,0,0,1,0,0,0},
    [10]  = {1,1,0,0,1,0,0,0,1,0,0},
    [11]  = {1,1,0,0,0,1,0,0,1,0,0},
    [12]  = {1,0,1,1,0,0,1,1,1,0,0},
    [13]  = {1,0,0,1,1,0,1,1,1,0,0},
    [14]  = {1,0,0,1,1,0,0,1,1,1,0},
    [15]  = {1,0,1,1,1,0,0,1,1,0,0},
    [16]  = {1,0,0,1,1,1,0,1,1,0,0},
    [17]  = {1,0,0,1,1,1,0,0,1,1,0},
    [18]  = {1,1,0,0,1,1,1,0,0,1,0},
    [19]  = {1,1,0,0,1,0,1,1,1,0,0},
    [20]  = {1,1,0,0,1,0,0,1,1,1,0},
    [21]  = {1,1,0,1,1,1,0,0,1,0,0},
    [22]  = {1,1,0,0,1,1,1,0,1,0,0},
    [23]  = {1,1,1,0,1,1,0,1,1,1,0},
    [24]  = {1,1,1,0,1,0,0,1,1,0,0},
    [25]  = {1,1,1,0,0,1,0,1,1,0,0},
    [26]  = {1,1,1,0,0,1,0,0,1,1,0},
    [27]  = {1,1,1,0,1,1,0,0,1,0,0},
    [28]  = {1,1,1,0,0,1,1,0,1,0,0},
    [29]  = {1,1,1,0,0,1,1,0,0,1,0},
    [30]  = {1,1,0,1,1,0,1,1,0,0,0},
    [31]  = {1,1,0,1,1,0,0,0,1,1,0},
    [32]  = {1,1,0,0,0,1,1,0,1,1,0},
    [33]  = {1,0,1,0,0,0,1,1,0,0,0},
    [34]  = {1,0,0,0,1,0,1,1,0,0,0},
    [35]  = {1,0,0,0,1,0,0,0,1,1,0},
    [36]  = {1,0,1,1,0,0,0,1,0,0,0},
    [37]  = {1,0,0,0,1,1,0,1,0,0,0},
    [38]  = {1,0,0,0,1,1,0,0,0,1,0},
    [39]  = {1,1,0,1,0,0,0,1,0,0,0},
    [40]  = {1,1,0,0,0,1,0,1,0,0,0},
    [41]  = {1,1,0,0,0,1,0,0,0,1,0},
    [42]  = {1,0,1,1,0,1,1,1,0,0,0},
    [43]  = {1,0,1,1,0,0,0,1,1,1,0},
    [44]  = {1,0,0,0,1,1,0,1,1,1,0},
    [45]  = {1,0,1,1,1,0,1,1,0,0,0},
    [46]  = {1,0,1,1,1,0,0,0,1,1,0},
    [47]  = {1,0,0,0,1,1,1,0,1,1,0},
    [48]  = {1,1,1,0,1,1,1,0,1,1,0},
    [49]  = {1,1,0,1,0,0,0,1,1,1,0},
    [50]  = {1,1,0,0,0,1,0,1,1,1,0},
    [51]  = {1,1,0,1,1,1,0,1,0,0,0},
    [52]  = {1,1,0,1,1,1,0,0,0,1,0},
    [53]  = {1,1,0,1,1,1,0,1,1,1,0},
    [54]  = {1,1,1,0,1,0,1,1,0,0,0},
    [55]  = {1,1,1,0,1,0,0,0,1,1,0},
    [56]  = {1,1,1,0,0,0,1,0,1,1,0},
    [57]  = {1,1,1,0,1,1,0,1,0,0,0},
    [58]  = {1,1,1,0,1,1,0,0,0,1,0},
    [59]  = {1,1,1,0,0,0,1,1,0,1,0},
    [60]  = {1,1,1,0,1,1,1,1,0,1,0},
    [61]  = {1,1,0,0,1,0,0,0,0,1,0},
    [62]  = {1,1,1,1,0,0,0,1,0,1,0},
    [63]  = {1,0,1,0,0,1,1,0,0,0,0},
    [64]  = {1,0,1,0,0,0,0,1,1,0,0},
    [65]  = {1,0,0,1,0,1,1,0,0,0,0},
    [66]  = {1,0,0,1,0,0,0,0,1,1,0},
    [67]  = {1,0,0,0,0,1,0,1,1,0,0},
    [68]  = {1,0,0,0,0,1,0,0,1,1,0},
    [69]  = {1,0,1,1,0,0,1,0,0,0,0},
    [70]  = {1,0,1,1,0,0,0,0,1,0,0},
    [71]  = {1,0,0,1,1,0,1,0,0,0,0},
    [72]  = {1,0,0,1,1,0,0,0,0,1,0},
    [73]  = {1,0,0,0,0,1,1,0,1,0,0},
    [74]  = {1,0,0,0,0,1,1,0,0,1,0},
    [75]  = {1,1,0,0,0,0,1,0,0,1,0},
    [76]  = {1,1,0,0,1,0,1,0,0,0,0},
    [77]  = {1,1,1,1,0,1,1,1,0,1,0},
    [78]  = {1,1,0,0,0,0,1,0,1,0,0},
    [79]  = {1,0,0,0,1,1,1,1,0,1,0},
    [80]  = {1,0,1,0,0,1,1,1,1,0,0},
    [81]  = {1,0,0,1,0,1,1,1,1,0,0},
    [82]  = {1,0,0,1,0,0,1,1,1,1,0},
    [83]  = {1,0,1,1,1,1,0,0,1,0,0},
    [84]  = {1,0,0,1,1,1,1,0,1,0,0},
    [85]  = {1,0,0,1,1,1,1,0,0,1,0},
    [86]  = {1,1,1,1,0,1,0,0,1,0,0},
    [87]  = {1,1,1,1,0,0,1,0,1,0,0},
    [88]  = {1,1,1,1,0,0,1,0,0,1,0},
    [89]  = {1,1,0,1,1,0,1,1,1,1,0},
    [90]  = {1,1,0,1,1,1,1,0,1,1,0},
    [91]  = {1,1,1,1,0,1,1,0,1,1,0},
    [92]  = {1,0,1,0,1,1,1,1,0,0,0},
    [93]  = {1,0,1,0,0,0,1,1,1,1,0},
    [94]  = {1,0,0,0,1,0,1,1,1,1,0},
    [95]  = {1,0,1,1,1,1,0,1,0,0,0},
    [96]  = {1,0,1,1,1,1,0,0,0,1,0},
    [97]  = {1,1,1,1,0,1,0,1,0,0,0},
    [98]  = {1,1,1,1,0,1,0,0,0,1,0},
    [99]  = {1,0,1,1,1,0,1,1,1,1,0},
    [100] = {1,0,1,1,1,1,0,1,1,1,0},
    [101] = {1,1,1,0,1,0,1,1,1,1,0},
    [102] = {1,1,1,1,0,1,0,1,1,1,0},
    [103] = {1,1,0,1,0,0,0,0,1,0,0},
    [104] = {1,1,0,1,0,0,1,0,0,0,0},
    [105] = {1,1,0,1,0,0,1,1,1,0,0},
    [106] = {1,1,0,0,0,1,1,1,0,1,0,1,1},
    ["QUIET"] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
}


-- https://stackoverflow.com/a/29177437
local function concatTables(t1, t2)
    for _,v in ipairs(t2) do
        table.insert(t1, v)
    end
    return t1
end

-- test if input string is ISO/IEC 8859-1 aka Latin-1
function isStringLatin1(str)
    if pcall(utf8ToLatin1, str) then
        return true
    else
        return false
    end
end

-- convert string to ISO/IEC 8859-1 aka Latin-1
-- from http://lua-users.org/lists/lua-l/2015-02/msg00170.html
function utf8ToLatin1(s)
    local r = ''
    for _, c in utf8.codes(s) do
        r = r .. string.char(c)
    end
    return r
end


-- Code A
-- ASCII value or special code -> numeric value of pattern
local function codeAGetval(var)
    if type(var) == "number" then
        if (var >= 32) and (var <= 95) then
            return var - 32
        elseif (var >= 0) and (var <= 31) then
            return var + 64
        end
    elseif type(var) == "string" then
        if     var == "FNC3"    then return 96
        elseif var == "FNC2"    then return 97
        elseif var == "SHIFTB"  then return 98
        elseif var == "CODEC"   then return 99
        elseif var == "CODEB"   then return 100
        elseif var == "FNC4"    then return 101
        elseif var == "FNC1"    then return 102
        elseif var == "STARTA"  then return 103
        elseif var == "STARTB"  then return 104
        elseif var == "STARTC"  then return 105
        elseif var == "STOP"    then return 106
        end
    end

    assert(false) -- invalid input
end

-- Code B
-- ASCII value or special code -> numeric value of pattern
local function codeBGetval(var)
    if type(var) == "number" then
        if (var >= 32) and (var <= 127) then
            return var - 32
        end
    elseif type(var) == "string" then
        if     var == "FNC3"    then return 96
        elseif var == "FNC2"    then return 97
        elseif var == "SHIFTA"  then return 98
        elseif var == "CODEC"   then return 99
        elseif var == "FNC4"    then return 100
        elseif var == "CODEA"   then return 101
        elseif var == "FNC1"    then return 102
        elseif var == "STARTA"  then return 103
        elseif var == "STARTB"  then return 104
        elseif var == "STARTC"  then return 105
        elseif var == "STOP"    then return 106
        end
    end

    print(var)
    assert(false) -- invalid input
end

-- Code C
-- numeric (NOT ASCII!) value or special code -> numeric value of pattern
local function codeCGetval(var)
    if type(var) == "number" then
        if (var >= 0) and (var <= 99) then
            return var
        end
    elseif type(var) == "string" then
        if     var == "CODEB"   then return 100
        elseif var == "CODEA"   then return 101
        elseif var == "FNC1"    then return 102
        elseif var == "STARTA"  then return 103
        elseif var == "STARTB"  then return 104
        elseif var == "STARTC"  then return 105
        elseif var == "STOP"    then return 106
        end
    end

    assert(false) -- invalid input
end

local function codeABGetval(code, var)
    if code == "A" then
        return codeAGetval(var)
    elseif code == "B" then
        return codeBGetval(var)
    else
        assert(false)
    end
end

local function codeABCGetval(code, var)
    assert(type(var) == "string")
    if code == "A" then
        return codeAGetval(var)
    elseif code == "B" then
        return codeBGetval(var)
    elseif code == "C" then
        return codeCGetval(var)
    else
        assert(false)
    end
end

local function getChecksum(vals)
    local checksum = vals[1]

    for pos = 1,(#vals-1) do
        checksum = checksum + pos*vals[pos+1]
    end

    checksum = checksum % 103

    return checksum
end

-- [quiet zone] [start code] [data] [checksum] [stop code] [quiet zone]

-- default to B, unless A is necessary
-- use C for 4+ digits at start/end, or 6+ digits in middle

-- Ideally we would use double FNC4 for 4+ 128-255 characters, but we're not
-- going to be that efficient. Instead, we'll do FNC4 before every high char.
-- It seems like there should rarely be 4 high values in a row.

local function code128EncodeVals(str)
    -- rewrite str as a list of bytes
    local str_latin  = utf8ToLatin1(str)
    local str_bytes = {}
    for j = 1,#str_latin do
        str_bytes[j] = string.byte(str_latin, j)
    end

    -- construct an array representing which code to use for each byte
    -- ultimately it should read "A", "B", or "C" for each byte, but we first
    -- initialize it to ""
    local str_codes = {}
    for j = 1,#str_bytes do
        str_codes[j] = ""
    end

    ----- Start with C

    -- find strings of 4+ numbers at start or end, or 6+ numbers in the middle
    -- of the string
    local C_start_i,C_start_i2 = string.find(str_latin, "^%d%d%d%d+")
    local C_end_i = string.find(str_latin, "%d%d%d%d+$")

    local C_is = {}
    if C_start_i then C_is[1] = C_start_i end

    local C_mid_search_i = C_start_i2 or 1
    while C_mid_search_i do
        local C_mid_i,C_mid_i2 = string.find(str_latin, "%d%d%d%d%d%d+", C_mid_search_i)
        if C_mid_i and ((not C_end_i) or (C_mid_i < C_end_i)) then
            C_is[#C_is+1] = C_mid_i
            C_mid_search_i = C_mid_i2
        else
            C_mid_search_i = nil
        end
    end

    if C_end_i then C_is[#C_is+1] = C_end_i end

    for cj = 1,#C_is do
        local j = C_is[cj]
        for k = j,#str_latin,2 do
            local this_2char = string.sub(str_latin, k, k+1)
            if string.find(this_2char, "%d%d") then
                str_codes[k] = "C"
                str_codes[k+1] = "C"
            else
                break
            end
        end
    end

    ----- Now find chars which should be encoded B or A

    local cur_code = "B"
    for j = 1,#str_latin do

        if str_codes[j] == "C" then
            cur_code = "B"
        else

            local this_char_byte = str_bytes[j] % 128

            if this_char_byte < 32 then
                cur_code = "A"
            elseif this_char_byte > 95 then
                cur_code = "B"
            end

            str_codes[j] = cur_code
        end

    end


    -- We now have the code (A,B,C) to use for each character and can construct
    -- the encoded values. The only remaining thing to be careful of is chars
    -- with byte value > 127, for which we need FNC4 beforehand.

    local encoded_vals = {}
    local k = 1
    local skip = false
    for j = 1,#str_bytes do
        if skip then
            skip = false
        else
            local prev_code = str_codes[j-1]
            local cur_code = str_codes[j]
            local next_code = str_codes[j+1]

            local this_byte = str_bytes[j]

            if j == 1 then
                encoded_vals[k] = codeAGetval("START" .. cur_code)
                k = k + 1
            elseif cur_code ~= prev_code then
                    encoded_vals[k] = codeABCGetval(prev_code, "CODE" .. cur_code)
                    k = k + 1
            end

            if cur_code == "C" then
                local this_num = tonumber(string.sub(str_latin, j, j))
                if next_code == "C" then
                    this_num = tonumber(string.sub(str_latin, j, j+1))
                    skip = true
                end
                encoded_vals[k] = codeCGetval(this_num)
            else
                if this_byte > 127 then
                        encoded_vals[k] = codeABCGetval(cur_code, "FNC4")
                        k = k + 1
                end
                encoded_vals[k] = codeABGetval(cur_code, this_byte % 128)
            end

            k = k + 1
        end
    end

    -- checksum
    encoded_vals[k] = getChecksum(encoded_vals)
    k = k + 1

    encoded_vals[k] = codeAGetval("STOP")

    return encoded_vals
end

function code128Encode(str)
    local output = {}
    local vals = code128EncodeVals(str)

    output = concatTables(output, patterns["QUIET"])
    for j = 1,#vals do
        output = concatTables(output, patterns[vals[j]])
    end
    output = concatTables(output, patterns["QUIET"])

    return output
end

-- This can be called in one of two ways:
-- 1. code128EncodeBMP(str, output_file, aspect_height, aspect_width)
--    In this case the height of the barcode will be determined by the provided
--    aspect ratio, while the width will be set by the number of bars in the
--    code.
-- 2. code128EncodeBMP(str, output_file, height)
--    In this case the height of the barcode will be set in pixels by 'height',
--    while the width will be set by the number of bars in the code.
function code128EncodeBMP(str, output_file, height_temp, width_temp)
    local code = code128Encode(str)

    -- to be safe, we will fail if str does not end in '.bmp'
    assert((#output_file >= 5) and (output_file:sub(-4,-1):lower() == '.bmp'))

    local width = #code
    local height = nil
    if not width_temp then
        -- if width_temp is not provided, then the height variable is absolute
        height = height_temp
    else
        -- otherwise, it is relative
        height = math.ceil(height_temp * width / width_temp)
    end

    -- create the bitmap
    local bitmap = require("bitmap")
    local palettes = require("bitmap/palettes")

    local bmp = bitmap.create(width, height)
    for x = 1,width do
        for y = 1,height do
            bmp[y][x] = 1 - code[x]
        end
    end

    bmp:save(output_file, 'RGB1', palettes.palette_2)
end

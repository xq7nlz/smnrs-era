--[[**************************************************************************]]
-- base64.lua
-- Copyright 2014 Ernest R. Ewert
--
--  This Lua module contains the implementation of a Lua base64 encode
--  and decode library.
--
--  The library exposes these methods.
--
--      Method      Args
--      ----------- ----------------------------------------------
--      encode      String in / out
--      decode      String in / out
--

local bit32 = require("lua.client.utils.Bit32")

--- @class Base64Helper
local Base64Helper = Class(Base64Helper)

--- @return void
function Base64Helper:Ctor()
    --------------------------------------------------------------------------------
    -- known_base64_alphabets

    self.c_alpha = {
        _alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
        _strip = "[^%a%d%+%/%=]",
        _term = "="
    }
    self.pattern_strip = nil

    --[[**************************************************************************]]
    --[[****************************** Encoding **********************************]]
    --[[**************************************************************************]]

    -- Precomputed tables (compromise using more memory for speed)
    self.b64e = nil -- 6 bit patterns to ANSI 'char' values
    self.b64e_a = nil-- ready to use
    self.b64e_a2 = nil-- byte addend
    self.b64e_b1 = nil-- byte addend
    self.b64e_b2 = nil-- byte addend
    self.b64e_c1 = nil-- byte addend
    self.b64e_c = nil-- ready to use

    -- Tail padding values
    self.tail_padd64 = {
        "==", -- two bytes modulo
        "="     -- one byte modulo
    }

    --[[**************************************************************************]]
    --[[****************************** Decoding **********************************]]
    --[[**************************************************************************]]

    -- Precomputed tables (compromise using more memory for speed)
    self.b64d = nil -- ANSI 'char' to right shifted bit pattern
    self.b64d_a1 = nil-- byte addend
    self.b64d_a2 = nil-- byte addend
    self.b64d_b1 = nil-- byte addend
    self.b64d_b2 = nil-- byte addend
    self.b64d_c1 = nil-- byte addend
    self.b64d_z = nil-- zero

    self:init()
end

--------------------------------------------------------------------------------
--- Sets and returns the encode / decode alphabet.
function Base64Helper:init()
    local magic = {
        [" "] = "% ",
        ["^"] = "%^",
        ["$"] = "%$",
        ["("] = "%(",
        [")"] = "%)",
        ["."] = "%.",
        ["["] = "%[",
        ["]"] = "%]",["*"] = "%*",
        ["+"] = "%+",
        ["-"] = "%-",
        ["?"] = "%?",
    }

    self.b64d = {}  -- Decode table alpha          -> right shifted int values
    self.b64e = {}  -- Encode table 0-63 (6 bits)  -> char table
    local s = ""
    for i = 1, 64 do
        local byte = self.c_alpha._alpha:byte(i)
        local str = string.char(byte)
        self.b64e[i - 1] = byte
        if self.b64d[byte] ~= nil then
            assert(false, "Duplicate value '" .. str .. "'")
        end
        self.b64d[byte] = i - 1
        s = s .. str
    end

    local ext = bit32.extract --Alias for extraction routine that avoids extra table lookups

    -- preload encode lookup tables
    self.b64e_a = {}
    self.b64e_a2 = {}
    self.b64e_b1 = {}
    self.b64e_b2 = {}
    self.b64e_c1 = {}
    self.b64e_c = {}

    for f = 0, 255 do
        self.b64e_a[f] = self.b64e[ext(f, 2, 6)]
        self.b64e_a2[f] = ext(f, 0, 2) * 16
        self.b64e_b1[f] = ext(f, 4, 4)
        self.b64e_b2[f] = ext(f, 0, 4) * 4
        self.b64e_c1[f] = ext(f, 6, 2)
        self.b64e_c[f] = self.b64e[ext(f, 0, 6)]
    end

    -- preload decode lookup tables
    self.b64d_a1 = {}
    self.b64d_a2 = {}
    self.b64d_b1 = {}
    self.b64d_b2 = {}
    self.b64d_c1 = {}
    self.b64d_z = self.b64e[0]

    for k, v in pairs(self.b64d) do
        -- Each comment shows the rough C expression that would be used to
        -- generate the returned triple.
        --
        self.b64d_a1[k] = v * 4                   -- ([b1]       ) << 2
        self.b64d_a2[k] = math.floor(v / 16)  -- ([b2] & 0x30) >> 4
        self.b64d_b1[k] = ext(v, 0, 4) * 16   -- ([b2] & 0x0F) << 4
        self.b64d_b2[k] = math.floor(v / 4)   -- ([b3] & 0x3c) >> 2
        self.b64d_c1[k] = ext(v, 0, 2) * 64   -- ([b3] & 0x03) << 6
    end

    if self.c_alpha._term ~= "" then
        self.tail_padd64[1] = string.char(self.c_alpha._term:byte(), self.c_alpha._term:byte())
        self.tail_padd64[2] = string.char(self.c_alpha._term:byte())
    else
        self.tail_padd64[1] = ""
        self.tail_padd64[2] = ""
    end

    local esc_term

    if magic[self.c_alpha._term] ~= nil then
        esc_term = self.c_alpha._term:gsub(magic[self.c_alpha._term], function(s1)
            return magic[s1]
        end)
    elseif self.c_alpha._term == "%" then
        esc_term = "%%"
    else
        esc_term = self.c_alpha._term
    end

    if not self.c_alpha._strip then
        local p = s:gsub("%%", function(s2)
            return "__unique__"
        end)
        for _, v in pairs(magic)
        do
            p = p:gsub(v, function(s3)
                return magic[s3]
            end)
        end
        local mr = p:gsub("__unique__", function()
            return "%%"
        end)

        self.c_alpha._strip = string.format("[^%s%s]", mr, esc_term)
    end

    if self.c_alpha._strip ~= nil then
        assert(self.c_alpha._strip, "Strip is nil")
    end

    self.pattern_strip = self.c_alpha._strip

    local c = 0
    for _ in pairs(self.b64d) do
        c = c + 1
    end

    if self.c_alpha._alpha ~= s then
        assert(false, "Integrity error.")
    end

    if c ~= 64 then
        assert(false, "The alphabet must be 64 unique values.")
    end

    if esc_term ~= "" then
        assert(not self.c_alpha._alpha:find(esc_term), "Tail characters must not exist in alphabet.")
    end

    return self.c_alpha._alpha, self.c_alpha._term
end

--[[**************************************************************************]]
--[[****************************** Encoding **********************************]]
--[[**************************************************************************]]

--------------------------------------------------------------------------------
---  Helper function to convert three eight bit values into four encoded
---  6 (significant) bit values.
---
---                 7             0 7             0 7             0
---             e64(a a a a a a a a,b b b b b b b b,c c c c c c c c)
---                 |           |           |           |
---  return    [    a a a a a a]|           |           |
---                        [    a a b b b b]|           |
---                                    [    b b b b c c]|
---                                                [    c c c c c c]
function Base64Helper:e64(a, b, c)
    -- Return pre-calculated values for encoded value 1 and 4
    -- Get the pre-calculated extractions for value 2 and 3, look them
    -- up and return the proper value.
    --
    return self.b64e_a[a],
    self.b64e[self.b64e_a2[a] + self.b64e_b1[b]],
    self.b64e[self.b64e_b2[b] + self.b64e_c1[c]],
    self.b64e_c[c]
end


--------------------------------------------------------------------------------
--- Send a tail pad value to the output predicate provided.
function Base64Helper:encode_tail64(out, x, y)
    -- If we have a number of input bytes that isn't exactly divisible
    -- by 3 then we need to pad the tail
    if x ~= nil then
        local a, b, r = x, 0, 1

        if y ~= nil then
            r = 2
            b = y
        end

        -- Encode three bytes of info, with the tail byte as zeros and
        -- ignore any fourth encoded ASCII value. (We should NOT have a
        -- forth byte at this point.)
        local b1, b2, b3 = self:e64(a, b, 0)

        -- always add the first 2 six bit values to the res table
        -- 1 remainder input byte needs 8 output bits
        local tail_value = string.char(b1, b2)

        -- two remainder input bytes will need 18 output bits (2 as pad)
        if r == 2 then
            tail_value = tail_value .. string.char(b3)
        end

        -- send the last 4 byte sequence with appropriate tail padding
        out(tail_value .. self.tail_padd64[r])
    end
end


--------------------------------------------------------------------------------
--- Implements the basic raw data --> base64 conversion. Each three byte
--- sequence in the input string is converted to the encoded string and
--- given to the predicate provided in 4 output byte chunks. This method
--- is slightly faster for traversing existing strings in memory.
function Base64Helper:encode64_with_predicate(raw, out)
    local rem = #raw % 3     -- remainder
    local len = #raw - rem   -- 3 byte input adjusted
    local sb = string.byte -- Mostly notational (slight performance)
    local sc = string.char -- Mostly notational (slight performance)

    -- Main encode loop converts three input bytes to 4 base64 encoded
    -- ACSII values and calls the predicate with the value.
    for i = 1, len, 3 do
        -- This really isn't intended as obfuscation. It is more about
        -- loop optimization and removing temporaries.
        --
        out(sc(self:e64(sb(raw, i, i + 3))))
        --   |   |    |
        --   |   |    byte i to i + 3
        --   |   |
        --   |   returns 4 encoded values
        --   |
        --   creates a string with the 4 returned values
    end

    -- If we have a number of input bytes that isn't exactly divisible
    -- by 3 then we need to pad the tail
    if rem > 0 then
        local x, y = sb(raw, len + 1)

        if rem > 1 then
            y = sb(raw, len + 2)
        end

        self:encode_tail64(out, x, y)
    end
end


--------------------------------------------------------------------------------
--- @return string
--- Convenience method that accepts a string value and returns the encoded version of that string.
function Base64Helper:encode64(raw)

    local sb = {} -- table to build string

    local function collection_predicate(v)
        sb[#sb + 1] = v
    end

    self:encode64_with_predicate(raw, collection_predicate)

    return table.concat(sb)
end


--[[**************************************************************************]]
--[[****************************** Decoding **********************************]]
--[[**************************************************************************]]

--------------------------------------------------------------------------------
---  Helper function to convert four six bit values into three full eight
---  bit values. Input values are the integer expression of the six bit value
---  encoded in the original base64 encoded string.
---
---     d64( _ _1 1 1 1 1 1,
---             |       _ _ 2 2 2 2 2 2,
---             |           |       _ _ 3 3 3 3 3 3,
---             |           |           |       _ _ 4 4 4 4 4 4)
---             |           |           |           |
---  return ', [1 1 1 1 1 1 2 2]        |           |
---         ',                 [2 2 2 2 3 3 3 3]    |
---         '                                  [3 3 4 4 4 4 4 4]
---
function Base64Helper:d64(b1, b2, b3, b4)
    -- We can get away with addition instead of anding the values together
    -- because there are no  overlapping bit patterns.
    --
    return
    self.b64d_a1[b1] + self.b64d_a2[b2],
    self.b64d_b1[b2] + self.b64d_b2[b3],
    self.b64d_c1[b3] + self.b64d[b4]
end


--------------------------------------------------------------------------------
--- Send the end of stream bytes that didn't get decoded via the main loop.
function Base64Helper:decode_tail64(out, e1, e2, e3, e4)

    if self.tail_padd64[2] == "" or e4 == self.tail_padd64[2]:byte() then
        local n3 = self.b64d_z

        if e3 ~= nil and e3 ~= self.tail_padd64[2]:byte() then
            n3 = e3
        end

        -- Unpack the six bit values into the 8 bit values
        local b1, b2 = self:d64(e1, e2, n3, self.b64d_z)

        -- And add them to the res table
        if e3 ~= nil and e3 ~= self.tail_padd64[2]:byte() then
            out(string.char(b1, b2))
        else
            out(string.char(b1))
        end
    end
end


--------------------------------------------------------------------------------
--- Decode an entire base64 encoded string in memory using the predicate for output.
function Base64Helper:decode64_with_predicate(raw, out)
    -- Sanitize the input to strip characters that are not in the alphabet.
    --
    -- Note: This is a deviation from strict implementations where "bad data"
    --       in the input stream is unsupported.
    --
    local san = raw:gsub(self.pattern_strip, "")
    local len = #san - #san % 4
    local rem = #san - len
    local sc = string.char
    local sb = string.byte

    if san:sub(-1, -1) == self.tail_padd64[2] then
        rem = rem + 4
        len = len - 4
    end

    for i = 1, len, 4 do
        out(sc(self:d64(sb(san, i, i + 4))))
    end

    if rem > 0 then
        self:decode_tail64(out, sb(san, 0 - rem, -1))
    end
end

--------------------------------------------------------------------------------
--- @return string
--- Takes a string that is encoded in base64 and returns the decoded value in a new string.
function Base64Helper:decode64(raw)

    local sb = {} -- table to build string

    local function collection_predicate(v)
        sb[#sb + 1] = v
    end

    self:decode64_with_predicate(raw, collection_predicate)

    return table.concat(sb)
end

local base64 = Base64Helper()
return base64


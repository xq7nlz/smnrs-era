-- GzipDepacker - gzip decompression in Lua

-- Copyright (c) 2016 Francois Galea <fgalea at free.fr>
-- This program is free software. It comes without any warranty, to
-- the extent permitted by applicable law. You can redistribute it
-- and/or modify it under the terms of the Do What The Fuck You Want
-- To Public License, Version 2, as published by Sam Hocevar. See
-- the COPYING file or http://www.wtfpl.net/ for more details.

require "lua.client.utils.gzip.BitStream"

GzipDepacker = {}

local bit = require("lua.client.utils.Bit32")

local function CreateHuffmanTable(depths)
    local nvalues = #depths
    local nbits = 1
    local bl_count = {}
    local next_code = {}
    for i = 1, nvalues do
        local d = depths[i]
        if d > nbits then
            nbits = d
        end
        bl_count[d] = (bl_count[d] or 0) + 1
    end
    local table = {}
    local code = 0
    bl_count[0] = 0
    for i = 1, nbits do
        code = (code + (bl_count[i - 1] or 0)) * 2
        next_code[i] = code
    end
    for i = 1, nvalues do
        local len = depths[i] or 0
        if len > 0 then
            local e = (i - 1) * 16 + len
            local code1 = next_code[len]
            local rcode = 0
            for j = 1, len do
                rcode = rcode + bit.lshift(bit.band(1, bit.rshift(code1, j - 1)), len - j)
            end
            for j = 0, 2 ^ nbits - 1, 2 ^ len do
                table[j + rcode] = e
            end
            next_code[len] = next_code[len] + 1
        end
    end
    return table, nbits
end

local function InflateBlockLoop(out, bs, nlit, ndist, littable, disttable)
    local lit
    repeat
        lit = bs:GetVariableSize(littable, nlit)
        if lit < 256 then
            table.insert(out, lit)
        elseif lit > 256 then
            local nbits = 0
            local size = 3
            local dist = 1
            if lit < 265 then
                size = size + lit - 257
            elseif lit < 285 then
                nbits = bit.rshift(lit - 261, 2)
                size = size + bit.lshift(bit.band(lit - 261, 3) + 4, nbits)
            else
                size = 258
            end
            if nbits > 0 then
                size = size + bs:GetBits(nbits)
            end
            local v = bs:GetVariableSize(disttable, ndist)
            if v < 4 then
                dist = dist + v
            else
                nbits = bit.rshift(v - 2, 1)
                dist = dist + bit.lshift(bit.band(v, 1) + 2, nbits)
                dist = dist + bs:GetBits(nbits)
            end
            local p = #out - dist + 1
            while size > 0 do
                table.insert(out, out[p])
                p = p + 1
                size = size - 1
            end
        end
    until lit == 256
end

local function InflateBlockDynamic(out, bs)
    local order = { 17, 18, 19, 1, 9, 8, 10, 7, 11, 6, 12, 5, 13, 4, 14, 3, 15, 2, 16 }
    local hlit = 257 + bs:GetBits(5)
    local hdist = 1 + bs:GetBits(5)
    local hclen = 4 + bs:GetBits(4)
    local depths = {}
    for i = 1, hclen do
        local v = bs:GetBits(3)
        depths[order[i]] = v
    end
    for i = hclen + 1, 19 do
        depths[order[i]] = 0
    end
    local lengthtable, nlen = CreateHuffmanTable(depths)
    local i = 1
    while i <= hlit + hdist do
        local v = bs:GetVariableSize(lengthtable, nlen)
        if v < 16 then
            depths[i] = v
            i = i + 1
        elseif v < 19 then
            local nbt = { 2, 3, 7 }
            local nb = nbt[v - 15]
            local c = 0
            local n = 3 + bs:GetBits(nb)
            if v == 16 then
                c = depths[i - 1]
            elseif v == 18 then
                n = n + 8
            end
            for j = 1, n do
                depths[i] = c
                i = i + 1
            end
        else
            error("wrong entry in depth table for literal/length alphabet: " .. v)
        end
    end
    local litdepths = {}
    for j = 1, hlit do
        table.insert(litdepths, depths[j])
    end
    local littable, nlit = CreateHuffmanTable(litdepths)
    local distdepths = {}
    for k = hlit + 1, #depths do
        table.insert(distdepths, depths[k])
    end
    local disttable, ndist = CreateHuffmanTable(distdepths)
    InflateBlockLoop(out, bs, nlit, ndist, littable, disttable)
end

local function InflateBlockStatic(out, bs)
    local cnt = { 144, 112, 24, 8 }
    local dpt = { 8, 9, 7, 8 }
    local depths = {}
    for i = 1, 4 do
        local d = dpt[i]
        for j = 1, cnt[i] do
            table.insert(depths, d)
        end
    end
    local littable, nlit = CreateHuffmanTable(depths)
    depths = {}
    for i = 1, 32 do
        depths[i] = 5
    end
    local disttable, ndist = CreateHuffmanTable(depths)
    InflateBlockLoop(out, bs, nlit, ndist, littable, disttable)
end

local function InflateBlockUncompressed(out, bs)
    bs:FlushBits(bit.band(bs.n, 7))
    local len = bs:GetBits(16)
    if bs.n > 0 then
        error("Unexpected.. should be zero remaining bits in buffer.")
    end
    local nlen = bs:GetBits(16)
    if bit.bxor(len, nlen) ~= 65535 then
        error("LEN and NLEN don't match")
    end
    for i = bs.pos, bs.pos + len - 1 do
        table.insert(out, bs.buf:byte(i, i))
    end
    bs.pos = bs.pos + len
end

local function ArrayToString(array)
    local tmp = {}
    local size = #array
    local pos = 1
    local imax = 1
    while size > 0 do
        local bsize = size >= 2048 and 2048 or size
        local s = string.char(table.unpack(array, pos, pos + bsize - 1))
        pos = pos + bsize
        size = size - bsize
        local i = 1
        while tmp[i] do
            s = tmp[i] .. s
            tmp[i] = nil
            i = i + 1
        end
        if i > imax then
            imax = i
        end
        tmp[i] = s
    end
    local str = ""
    for i = 1, imax do
        if tmp[i] then
            str = tmp[i] .. str
        end
    end
    return str
end

local function InflateMain(bs)
    local last, type
    local output = {}

    repeat
        last = bs:GetBits(1)
        type = bs:GetBits(2)
        if type == 0 then
            InflateBlockUncompressed(output, bs)
        elseif type == 1 then
            InflateBlockStatic(output, bs)
        elseif type == 2 then
            InflateBlockDynamic(output, bs)
        else
            error("unsupported block type")
        end
    until last == 1

    bs:FlushBits(bit.band(bs.n, 7))
    return ArrayToString(output)
end

--- @return string
--- @param raw string
function GzipDepacker.Gunzip(raw)
    local bs = BitStream(raw)

    local id1, id2, cm, flg = bs.buf:byte(1, 4)
    if id1 ~= 31 or id2 ~= 139 then
        error("invalid gzip header")
    end
    if cm ~= 8 then
        error("only deflate format is supported")
    end

    bs.pos = 11
    if bit.band(flg, 4) ~= 0 then
        local xl1, xl2 = bs.buf.byte(bs.pos, bs.pos + 1)
        local xlen = xl2 * 256 + xl1
        bs.pos = bs.pos + xlen + 2
    end
    if bit.band(flg, 8) ~= 0 then
        local pos = bs.buf:find("\0", bs.pos)
        bs.pos = pos + 1
    end
    if bit.band(flg, 16) ~= 0 then
        local pos = bs.buf:find("\0", bs.pos)
        bs.pos = pos + 1
    end
    if bit.band(flg, 2) ~= 0 then
        bs.pos = bs.pos + 2
    end

    return InflateMain(bs)
end
local bit32 = require("lua.client.utils.Bit32")

BitStream = Class(BitStream)

--- @return void
--- @param raw string
function BitStream:Ctor(raw)
    self.buf = raw -- character buffer
    self.len = raw:len() -- length of character buffer
    self.pos = 1 -- position in char buffer
    self.b = 0 -- bit buffer
    self.n = 0 -- number of bits in buffer
end

-- get rid of n first bits
function BitStream:FlushBits(n)
    self.n = self.n - n
    self.b = bit32.rshift(self.b, n)
end

-- peek a number of n bits from stream
function BitStream:PeekBits(n)
    while self.n < n do
        self.b = self.b + bit32.lshift(self.buf:byte(self.pos), self.n)
        self.pos = self.pos + 1
        self.n = self.n + 8
    end
    return bit32.band(self.b, bit32.lshift(1, n) - 1)
end

-- get a number of n bits from stream
function BitStream:GetBits(n)
    local ret = self:PeekBits(n)
    self.n = self.n - n
    self.b = bit32.rshift(self.b, n)
    return ret
end

-- get next variable-size of maximum size=n element from stream, according to Huffman table
function BitStream:GetVariableSize(hufftable, n)
    local e = hufftable[self:PeekBits(n)]
    local len = bit32.band(e, 15)
    local ret = bit32.rshift(e, 4)
    self.n = self.n - len
    self.b = bit32.rshift(self.b, len)
    return ret
end
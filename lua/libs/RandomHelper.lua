require "lua.libs.Class"
require "lua.libs.MathUtils"

--- @class RandomHelper
RandomHelper = Class(RandomHelper)

--- @return void
function RandomHelper:Ctor()
    self._numberRandom = 0

    self._seed = 0

    self.a, self.c, self.m = 1664525, 1013904223, 0x10000
    self.ic = self.c
end

--- @return void
function RandomHelper:Init()
    self._numberRandom = 0

    self.a, self.c, self.m = 1664525, 1013904223, 0x10000
    self.ic = self.c
end

--- @return void
--- @param seed number
function RandomHelper:SetSeed(seed)
    self:Init()
    self._seed = seed

    self.c = self.ic
    self.x = self:_Normalize(seed)
end

---------------------------------------- Sample ----------------------------------------
--- @return void
function RandomHelper:_InternalSample(a, b)
    self._numberRandom = self._numberRandom + 1

    local m = self.m
    local t = self.a * self.x + self.c
    local y = t % m
    self.x = y
    self.c = math.floor(t / m)
    if not a then return y / 0x10000
    elseif not b then
        if a == 0 then return y
        else return 1 + (y % a) end
    else
        return a + (y % (b - a + 1))
    end
end

--- @return number
function RandomHelper:_Normalize(n)
    --keep numbers at (positive) 32 bits
    return n % 0x80000000
end

---------------------------------------- Public methods ----------------------------------------
--- @return number
function RandomHelper:GetSeed()
    return self._seed
end

--- @return number
function RandomHelper:GetNumberRandom()
    return self._numberRandom
end

--- @return number
--- @param maxExclusive number Random between 1 and maxExclusive
function RandomHelper:RandomMax(maxExclusive)
    return self:_InternalSample(1, maxExclusive - 1)
end

--- @return number
--- @param minInclusive number
--- @param maxExclusive number
function RandomHelper:RandomMinMax(minInclusive, maxExclusive)
    --assert(MathUtils.IsNumber(minInclusive))
    --assert(MathUtils.IsNumber(maxExclusive))
    return self:_InternalSample(minInclusive, maxExclusive - 1)
end

--- @return number
function RandomHelper:RandomFloat01()
    return self:_InternalSample()
end

--- @return boolean is pass rate
--- @param rate number
function RandomHelper:RandomRate(rate)
    --assert(MathUtils.IsNumber(rate))
    local value = self:_InternalSample()
    if value < rate then
        return true
    else
        return false
    end
end
--- @class HeroStateInBound
HeroStateInBound = Class(HeroStateInBound)

--- @return void
function HeroStateInBound:Ctor()
    --- @type number
    self.hp = nil
    --- @type number
    self.power = nil
    --- @type boolean
    self.isFrontLine = nil
    --- @type number
    self.position = nil
end

--- @return void
function HeroStateInBound:ToString()
    return string.format("[isFront = %s, position = %d, hp = %s, power = %d]", self.isFrontLine, self.position, self.hp, self.power)
end

--- @return HeroStateInBound
--- @param buffer UnifiedNetwork_ByteBuf
function HeroStateInBound.CreateByBuffer(buffer)
    local data = HeroStateInBound()

    data.hp = buffer:GetLong() / MathUtils.BILLION
    data.power = buffer:GetByte()
    data.isFrontLine = buffer:GetBool()
    data.position = buffer:GetByte()
    return data
end

--- @return HeroStateInBound
--- @param json UnifiedNetwork_ByteBuf
function HeroStateInBound.CreateByJson(id, json)
    local data = HeroStateInBound()
    data.hp = json['0']
    data.power = json['1']
    data.isFrontLine = id % 1000  > 0 and true or false
    data.position = math.floor(id / 10000)
    return data
end
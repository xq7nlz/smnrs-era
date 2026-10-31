--- @class HeroFormationInBound
HeroFormationInBound = Class(HeroFormationInBound)

--- @return void
function HeroFormationInBound:Ctor()
    --- @type number
    self.positionId = nil
    --- @type number
    self.heroInventoryId = nil
end

--- @return string
function HeroFormationInBound:ToString()
    return LogUtils.ToDetail(self)
end

--- @return HeroFormationInBound
--- @param positionId number
--- @param heroInventoryId number
function HeroFormationInBound.CreateInstance(positionId, heroInventoryId)
    local data = HeroFormationInBound()

    data.positionId = positionId
    data.heroInventoryId = heroInventoryId

    return data
end

--- @return HeroFormationInBound
--- @param heroFormationInBound HeroFormationInBound
function HeroFormationInBound.Clone(heroFormationInBound)
    local data = HeroFormationInBound()

    data.positionId = heroFormationInBound.positionId
    data.heroInventoryId = heroFormationInBound.heroInventoryId

    return data
end

--- @return HeroFormationInBound
--- @param buffer UnifiedNetwork_ByteBuf
function HeroFormationInBound.CreateByBuffer(buffer)
    return HeroFormationInBound.CreateInstance(buffer:GetByte(), buffer:GetLong())
end
--- @class SupportHeroData
SupportHeroData = Class(SupportHeroData)

function SupportHeroData:Ctor()
end

--- @param buffer UnifiedNetwork_ByteBuf
function SupportHeroData:ReadBuffer(buffer)
    --- @type number
    self.inventoryId = buffer:GetLong()
    --- @type number
    self.heroId = buffer:GetInt()
    --- @type number
    self.star = buffer:GetByte()
    --- @type number
    self.registerTime = buffer:GetLong()

end

--- @return SupportHeroData
--- @param buffer UnifiedNetwork_ByteBuf
function SupportHeroData.CreateByBuffer(buffer)
    local data = SupportHeroData()
    data:ReadBuffer(buffer)
    return data
end

function SupportHeroData:GetTimeLocalize(intervalTime)
    local timeInterval = self.registerTime + intervalTime - zg.timeMgr:GetServerTime()
    local time = string.format("%s %s", LanguageUtils.LocalizeCommon("time_to_move_x"), TimeUtils.GetDeltaTime(timeInterval))
    return time
end

function SupportHeroData:IsCanRemove(intervalTime)
    local timeInterval = self.registerTime + intervalTime - zg.timeMgr:GetServerTime()
    return timeInterval <= 0
end
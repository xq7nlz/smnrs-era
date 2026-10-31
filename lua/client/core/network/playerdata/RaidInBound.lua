--- @class RaidInBound
RaidInBound = Class(RaidInBound)

--- @return void
function RaidInBound:Ctor()
    --- @type BattleRaidInBound
    self.raidBattleResultInbound = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function RaidInBound:ReadBuffer(buffer)
    local size = buffer:GetByte()
    ---@type Dictionary
    self.turnBuyInDay = Dictionary()
    for _ = 1, size do
        self.turnBuyInDay:Add(buffer:GetByte(), buffer:GetByte())
    end
    --print(LogUtils.ToDetail(self.turnBuyInDay:GetItems()))

    local size = buffer:GetByte()
    ---@type Dictionary
    self.turnAdsInDay = Dictionary()
    for _ = 1, size do
        self.turnAdsInDay:Add(buffer:GetByte(), buffer:GetByte())
    end
    --print(LogUtils.ToDetail(self.turnAdsInDay:GetItems()))

    local size = buffer:GetByte()
    ---@type Dictionary
    self.playableStage = Dictionary()
    for _ = 1, size do
        self.playableStage:Add(buffer:GetByte(), buffer:GetByte())
    end
    --print(LogUtils.ToDetail(self.playableStage:Get(0)))
end

--- @return void
function RaidInBound:ToString()
    return LogUtils.ToDetail(self.turnBuyInDay:GetItems())
end
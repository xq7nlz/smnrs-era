require "lua.client.core.network.playerData.common.BattleResultInBound"

--- @class BirthdayChallengeBossInBound
BirthdayChallengeBossInBound = Class(BirthdayChallengeBossInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function BirthdayChallengeBossInBound:Ctor(buffer)
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function BirthdayChallengeBossInBound:ReadBuffer(buffer)
    self.battleResultInfo = BattleResultInBound.CreateByBuffer(buffer, true)
    self.battleDamage = buffer:GetLong()
    self.listReward = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer, buffer:GetByte())
    local size = buffer:GetByte()
    self.rewardNumberList = List()
    for i = 1, size do
        self.rewardNumberList:Add(buffer:GetByte())
    end
end

function BirthdayChallengeBossInBound:GetTotalChest()
    local total = 0
    for i = 1, self.rewardNumberList:Count() do
        total = total + self.rewardNumberList:Get(i)
    end
    return total
end
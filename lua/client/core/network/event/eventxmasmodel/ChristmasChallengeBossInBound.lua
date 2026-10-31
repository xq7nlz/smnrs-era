require "lua.client.core.network.playerData.common.BattleResultInBound"

--- @class ChristmasChallengeBossInBound
ChristmasChallengeBossInBound = Class(ChristmasChallengeBossInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function ChristmasChallengeBossInBound:Ctor(buffer)
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function ChristmasChallengeBossInBound:ReadBuffer(buffer)
    self.battleResultInfo = BattleResultInBound.CreateByBuffer(buffer, true)
    self.battleDamage = buffer:GetInt()
    self.listReward = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer, buffer:GetByte())
    local size = buffer:GetByte()
    self.rewardNumberList = List()
    for i = 1, size do
        self.rewardNumberList:Add(buffer:GetByte())
    end
end

function ChristmasChallengeBossInBound:GetListReward()
    if self.listReward and self.listReward:Count() then
        return self.listReward
    end
    return List()
end

function ChristmasChallengeBossInBound:GetTotalChest()
    local total = 0
    for i = 1, self.rewardNumberList:Count() do
        total = total + self.rewardNumberList:Get(i)
    end
    return total
end
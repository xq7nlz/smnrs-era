require "lua.client.core.network.playerData.common.RankingDataInBound"

--- @class DungeonRewardInBound
DungeonRewardInBound = Class(DungeonRewardInBound)

function DungeonRewardInBound:Ctor()
    --- @type DungeonRewardType
    self.type = nil
    --- @type DungeonShopType
    self.shopType = nil
    --- @type MarketItemInBound
    self.marketItem = nil
    --- @type List <RewardInBound>
    self.rewardList = nil
    --- @type number
    self.stage = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function DungeonRewardInBound:ReadBuffer(buffer)
    self.type = buffer:GetByte()
    if self.type == DungeonRewardType.SHOP then
        self.shopType = buffer:GetByte()
        self.marketItem = MarketItemInBound.CreateByBuffer(buffer)
    else
        self.stage = buffer:GetShort()
        local size = buffer:GetByte()
        self.rewardList = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer, size)
    end
end

function DungeonRewardInBound:FakeData()
    local reward1 = RewardInBound.CreateBySingleParam(ResourceType.DungeonItemActiveBuff, 1002, 1, nil)
    local reward2 = RewardInBound.CreateBySingleParam(ResourceType.DungeonItemActiveBuff, 1003, 1, nil)
    local reward3 = RewardInBound.CreateBySingleParam(ResourceType.DungeonItemActiveBuff, 1004, 1, nil)
    self.rewardList = List()
    self.rewardList:Add(reward1)
    self.rewardList:Add(reward2)
    self.rewardList:Add(reward3)
end
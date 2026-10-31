--- @class DungeonBindingSmashInBound : OutBound
DungeonBindingSmashInBound = Class(DungeonBindingSmashInBound, OutBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function DungeonBindingSmashInBound:Ctor(buffer)
    --- @type DungeonInBound
    self.server = zg.playerData:GetMethod(PlayerDataMethod.DUNGEON)
    self.server:Reset()
    -- get reward
    --- @type List | RewardInBound
    self.rewardList = NetworkUtils.GetRewardInBoundList(buffer)
    -- get shop
    local sizeShop = buffer:GetByte()
    for _ = 1, sizeShop do
        self.server.shopDict:Add(buffer:GetByte(), NetworkUtils.GetListDataInBound(buffer, MarketItemInBound.CreateByBuffer))
    end
    -- get buff stage list
    local sizeBuffSelectionStage = buffer:GetByte()
    self.server.buffSelectionStageList = List()
    for _ = 1, sizeBuffSelectionStage do
        self.server.buffSelectionStageList:Add(buffer:GetInt())
    end

    -- get others
    self.server.currentShop = nil
    self.server.isWin = true
    self.server.predefineTeam = PredefineTeamData.CreateByBuffer(buffer)
    self.server.currentStage = buffer:GetShort()
    self.server.masteryLevel = zg.playerData:GetMethod(PlayerDataMethod.MASTERY):Clone()
    --zg.playerData:CheckDataLinking(function ()
        -----@type HeroLinkingInBound
        --local heroLinkingInBound = zg.playerData:GetMethod(PlayerDataMethod.HERO_LINKING)
        self.server.activeLinking = zg.playerData.battleResultLinking
    --end, true)

    self:AddRewardToInventory()
    self:AddRewardToRewardChallengeList()
end

function DungeonBindingSmashInBound:AddRewardToInventory()
    --- @param reward RewardInBound
    for _, reward in ipairs(self.rewardList:GetItems()) do
        reward:AddToInventory()
    end
end

function DungeonBindingSmashInBound:AddRewardToRewardChallengeList()
    self.server:ClearRewardChallenge()
    self.server.rewardChallengeList:AddAll(self.rewardList)
end
---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.FriendRankingRewardItemConfig"

--- @class FriendRankingRewardItemView : IconView
FriendRankingRewardItemView = Class(FriendRankingRewardItemView, IconView)

FriendRankingRewardItemView.prefabName = 'friend_ranking_reward_item_view'

--- @return void
function FriendRankingRewardItemView:Ctor()
    IconView.Ctor(self)
    self.listItem = List()
end

--- @return void
function FriendRankingRewardItemView:SetPrefabName()
    self.prefabName = 'friend_ranking_reward_item_view'
    self.uiPoolType = UIPoolType.FriendRankingRewardItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function FriendRankingRewardItemView:SetConfig(transform)
    assert(transform)
    ---@type FriendRankingRewardItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param friendRankingRewardConfig FriendRankingRewardConfig
--- @param index number
function FriendRankingRewardItemView:SetData(friendRankingRewardConfig, index)
    if index <= 3 then
        self.config.iconLeaderBoardTop1.sprite = ResourceLoadUtils.LoadTopRankingIcon(index)
        self.config.iconLeaderBoardTop1.enabled = true
        self.config.iconLeaderBoardTop1:SetNativeSize()
    else
        self.config.iconLeaderBoardTop1.enabled = false
    end
    if friendRankingRewardConfig.minRanking ~= friendRankingRewardConfig.maxRanking then
        if friendRankingRewardConfig.maxRanking == -1 then
            self.config.textLeaderBoardTop.text = string.format("%s+", friendRankingRewardConfig.minRanking)
        else
            self.config.textLeaderBoardTop.text = string.format("%s-%s",
                    friendRankingRewardConfig.minRanking, friendRankingRewardConfig.maxRanking)
        end
    else
        self.config.textLeaderBoardTop.text = tostring(friendRankingRewardConfig.minRanking)
    end
    ---@param v ItemIconData
    for _, v in ipairs(friendRankingRewardConfig.listRewardItem:GetItems()) do
        ---@type RootIconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.reward)
        iconView:RegisterShowInfo()
        iconView:SetIconData(ItemIconData.Clone(v))
        self.listItem:Add(iconView)
    end
end

--- @return void
function FriendRankingRewardItemView:ReturnPool()
    IconView.ReturnPool(self)
    ---@param v IconView
    for _, v in pairs(self.listItem:GetItems()) do
        v:ReturnPool()
    end
    self.listItem:Clear()
end

return FriendRankingRewardItemView
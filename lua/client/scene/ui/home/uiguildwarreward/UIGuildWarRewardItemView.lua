--- @class UIGuildWarRewardItemView : IconView
UIGuildWarRewardItemView = Class(UIGuildWarRewardItemView, IconView)

--- @return void
function UIGuildWarRewardItemView:SetPrefabName()
    self.prefabName = 'guild_war_reward_item_view'
    self.uiPoolType = UIPoolType.UIGuildWarRewardItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIGuildWarRewardItemView:SetConfig(transform)
    ---@type UIGuildWarRewardItemConfig
    self.config = UIBaseConfig(transform)
    --- @type Dictionary
    self.dicGuildRoleRewardsView = Dictionary()
    self.dicGuildRoleRewardsView:Add(1, ItemsTableView(self.config.roleReward1))
    self.dicGuildRoleRewardsView:Add(2, ItemsTableView(self.config.roleReward2))
    self.dicGuildRoleRewardsView:Add(3, ItemsTableView(self.config.roleReward3))
end


--- @param rankingRewardByRangeConfig RankingRewardByRangeConfig
function UIGuildWarRewardItemView:SetData(rankingRewardByRangeConfig,index)
    ---@type boolean
    local displayRankIcon = index <= LeaderBoardItemView.MaxTopRankHasIcon
    self.config.icon.gameObject:SetActive(displayRankIcon)
    if (displayRankIcon) then
        local rankIcon = ResourceLoadUtils.LoadTopRankingIcon(rankingRewardByRangeConfig.minRank)
        self.config.icon.sprite = rankIcon
        self.config.icon:SetNativeSize()
    end


    --XDebug.Log("COUNT " .. rankingRewardByRangeConfig.dicGuildRoleRewards:Count() .. " RANK " .. rankingRewardByRangeConfig.minRank .. "MAX RANK " .. rankingRewardByRangeConfig.maxRank )
    --print(LogUtils.ToDetail(rankingRewardByRangeConfig.dicGuildRoleRewards))
    local text = tostring(rankingRewardByRangeConfig.minRank)
    if (rankingRewardByRangeConfig.minRank == rankingRewardByRangeConfig.maxRank) then

    else
        local maxRank = tonumber(rankingRewardByRangeConfig.maxRank)
        if (maxRank > 0) then
            text = tostring(rankingRewardByRangeConfig.minRank) .. " - " .. tostring(rankingRewardByRangeConfig.maxRank)
        else
            text = tostring(rankingRewardByRangeConfig.minRank) .. "+"
        end
    end
    self.config.text_Ranking.text = text
    self.config.textRankingOutLine.enabled = not displayRankIcon

    for i = 1, 3 do
        ---@type ItemsTableView
        local view = self.dicGuildRoleRewardsView:Get(i)
        if (view == nil) then
            XDebug.Log("VIEW NIL " .. i)
        end
        local listRewards = rankingRewardByRangeConfig:GetListRewardItemIconByGuildRole(i - 1) -- .dicGuildRoleRewards:Get(i-1)
        if (listRewards == nil) then
            XDebug.Log("listRewards nil " .. i)
        end
        -- XDebug.Log("count icon " .. listRewards:Count())
        view:SetData(listRewards)
    end
end

function UIGuildWarRewardItemView:ReturnPool()
    IconView.ReturnPool(self)

    --- @param v ItemsTableView
    for k, v in pairs(self.dicGuildRoleRewardsView:GetItems()) do
        v:Hide()
    end
end

return UIGuildWarRewardItemView
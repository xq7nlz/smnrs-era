require "lua.client.scene.ui.home.uiIapShop.iapShopItem.IapShopTabItem"

--- @class UIGuildWarSeasonRewardLayout : UIGuildWarRewardLayout
UIGuildWarSeasonRewardLayout = Class(UIGuildWarSeasonRewardLayout, UIGuildWarRewardLayout)

local UISeasonLayoutWinLoseTab = {
    LOSE = 1,
    WIN = 2
}

local UISeasonLayoutInOutTab = {
    IN = 1,
    OUT = 2
}

--- @param view UIGuildWarRewardView
function UIGuildWarSeasonRewardLayout:Ctor(view, anchor)
    --- @type Dictionary
    self.tabWinLoseDict = Dictionary()
    --- @type Dictionary
    self.tabInOutDict = Dictionary()
    self.currentInOutTab = 1
    self.currentWinLoseTab = 1

    --- @type UnityEngine_Vector2
    self.scrollSize = U_Vector2(1334, 668.5)

    UIGuildWarRewardLayout.Ctor(self, view, anchor)
end

--- @return GuildWarListRankingRewardConfig
function UIGuildWarSeasonRewardLayout:GetGuildWarListRankingRewardConfig()
    local isParticipant = true
    if (self.currentInOutTab == 2) then
        isParticipant = false
    end
    local isWin = false
    if (self.currentWinLoseTab == 2) then
        isWin = true
    end
    return ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarBattleRewardConfig(isParticipant, isWin)
end

function UIGuildWarSeasonRewardLayout:_InitConfig()
    --- @type UIAchievementLayoutConfig
    self.layoutConfig = UIBaseConfig(self.config.seasonLayout)
    self:_InitTabs()
end

function UIGuildWarSeasonRewardLayout:_InitTabs()
    self.selectTabWinLose = function(currentTab)
        self:OnSelectWinLoseGroup(currentTab)
        --- @param v UITabItem
        for k, v in pairs(self.tabWinLoseDict:GetItems()) do
            v:SetTabState(k == currentTab)
        end
    end
    local addTabWinLose = function(uiTab)
        local tab = IapShopTabItem(self.config.tabWinLose:GetChild(uiTab - 1), nil, function ()
            return self:GetLocalizeWinLoseTab(uiTab)
        end)
        tab:SetListener(function ()
            self.selectTabWinLose(uiTab)
        end)
        self.tabWinLoseDict:Add(uiTab, tab)
    end

    self.selectTabInOut = function(currentTab)
        self:OnSelectInOutGroup(currentTab)
        --- @param v UITabItem
        for k, v in pairs(self.tabInOutDict:GetItems()) do
            v:SetTabState(k == currentTab)
        end
    end
    local addTabInOut = function(uiTab)
        self.tabInOutDict:Add(uiTab, UITabItem(self.config.tabInOut:GetChild(uiTab - 1),
                self.selectTabInOut, function()
                    return self:GetLocalizeInOutTab(uiTab)
                end, uiTab))
    end

    addTabWinLose(UISeasonLayoutWinLoseTab.LOSE)
    addTabWinLose(UISeasonLayoutWinLoseTab.WIN)

    addTabInOut(UISeasonLayoutInOutTab.IN)
    addTabInOut(UISeasonLayoutInOutTab.OUT)
end


function UIGuildWarSeasonRewardLayout:GetLocalizeInOutTab(index)
    if (index == 1) then
        return LanguageUtils.LocalizeCommon("guild_season_in_tab")
    else
        return LanguageUtils.LocalizeCommon("guild_season_out_tab")
    end
end

function UIGuildWarSeasonRewardLayout:GetLocalizeWinLoseTab(index)
    if (index == 1) then
        return LanguageUtils.LocalizeCommon("defeat")
    else
        return LanguageUtils.LocalizeCommon("victory")
    end
end

function UIGuildWarSeasonRewardLayout:OnShow()
    UIGuildWarRewardLayout.OnShow(self)
    self.selectTabWinLose(UISeasonLayoutWinLoseTab.LOSE)
    self.selectTabInOut(UISeasonLayoutInOutTab.IN)
end

function UIGuildWarSeasonRewardLayout:SetUpLayout()
    UIGuildWarRewardLayout.SetUpLayout(self)

    self.config.rewardView.anchoredPosition3D = U_Vector3(0, -85.7, 0)

    self.config.rectScroll.sizeDelta = self.scrollSize
end

--- @param currentTab number
function UIGuildWarSeasonRewardLayout:OnSelectWinLoseGroup(currentTab)
    self.currentWinLoseTab = currentTab
    self:OnSelectInOutGroup(self.currentInOutTab)
end

--- @param currentTab number
function UIGuildWarSeasonRewardLayout:OnSelectInOutGroup(currentTab)
    self.currentInOutTab = currentTab
    self:ShowData()
end

function UIGuildWarSeasonRewardLayout:SetData()
    ---@type GuildWarListRankingRewardConfig
    local guildWarListRankingRewardConfig = self:GetGuildWarListRankingRewardConfig()
    local listGuildReward = guildWarListRankingRewardConfig.listRangeRankingReward
    if listGuildReward == nil then
        XDebug.Error("No reward by group " .. self.currentWinLoseTab .. self.currentInOutTab)
        return
    end
    self.view:OnUpDateListRewards(listGuildReward)
end

function UIGuildWarSeasonRewardLayout:ShowData()
    self:SetData()
    self.uiScroll:Resize(self.view.listGuildReward:Count())
end

function UIGuildWarSeasonRewardLayout:RefreshView()
    self:SetData()
    self.uiScroll:RefreshCells()
end

function UIGuildWarSeasonRewardLayout:InitLocalization()
    UIGuildWarRewardLayout.InitLocalization(self)
    if self.tabWinLoseDict ~= nil then
        for k, v in pairs(self.tabWinLoseDict:GetItems()) do
            v:InitLocalization()
        end
    end
    if self.tabInOutDict ~= nil then
        --- @param v UITabItem
        for _, v in pairs(self.tabInOutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

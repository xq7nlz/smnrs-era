require "lua.client.scene.ui.home.uiGuildWarReward.guildWarLayout.UIGuildWarRewardLayout"

--- @class UIGuildWarRewardView : UIBaseView
UIGuildWarRewardView = Class(UIGuildWarRewardView, UIBaseView)

--- @param model UIGuildWarRewardModel
function UIGuildWarRewardView:Ctor(model)
    --- @type UIGuildWarRewardConfig
    self.config = nil
    --- @type Dictionary
    self.tabDict = Dictionary()
    ---@type UIGuildWarRewardTab
    self.guildTab = nil

    --- @type List
    self.listGuildReward = List()

    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIGuildWarRewardLayout
    self.currentLayout = nil

    UIBaseView.Ctor(self, model)
    --- @type UIGuildWarRewardModel
    self.model = model
end

function UIGuildWarRewardView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    ---@type UnityEngine_RectTransform
    local rect = self.config.transform:GetComponent(ComponentName.UnityEngine_RectTransform)
    rect.anchorMin = Vector2(0, 0)
    rect.anchorMax = Vector2(1, 1)
    rect.pivot = Vector2(0.5, 0.5)

    self:InitTabs()

    self:InitScroll()

    self:InitButtons()
end

function UIGuildWarRewardView:InitTabs()
    self.selectTab = function(currentTab)
        self:ShowGuildLayout(currentTab)
        --- @param v UITabItem
        for k, v in pairs(self.tabDict:GetItems()) do
            v:SetTabState(k == currentTab)
        end
    end
    local addTab = function(uiGuildTab, localizeFunction)
        self.tabDict:Add(uiGuildTab, UITabItem(self.config.tab:GetChild(uiGuildTab - 1),
                self.selectTab, localizeFunction, uiGuildTab))
    end
    addTab(UIGuildWarRewardTab.Season, function()
        return LanguageUtils.LocalizeCommon("guild_season")
    end)
    addTab(UIGuildWarRewardTab.GrandSeason, function()
        return LanguageUtils.LocalizeCommon("guild_grand_season")
    end)
end

function UIGuildWarRewardView:InitLocalization()
    self.config.textLeader.text = LanguageUtils.LocalizeCommon("guild_leader")
    self.config.textViceLeader.text = LanguageUtils.LocalizeCommon("guild_vice_leader")
    self.config.textMember.text = LanguageUtils.LocalizeCommon("member")

    if self.layoutDict ~= nil then
        for k, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
    if self.tabDict ~= nil then
        for _, v in pairs(self.tabDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIGuildWarRewardView:InitScroll()
    --- @param obj UIGuildWarRewardItemView
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type RankingRewardByRangeConfig
        local data = self.listGuildReward:Get(dataIndex)
        obj:SetData(data, dataIndex)
    end
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.UIGuildWarRewardItemView, onCreateItem)
    --self.uiScroll:SetUpMotion(MotionConfig(nil, nil, 0.1, 0.05))
end

function UIGuildWarRewardView:InitButtons()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgNone.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIGuildWarRewardView:ShowGuildLayout(uiGuildTab)
    self:HideLayout()
    self:GetTabLayout(uiGuildTab)
    self.currentLayout:OnShow()
end

--- @param uiGuildTab UIGuildWarRewardTab
function UIGuildWarRewardView:GetTabLayout(uiGuildTab)
    self.currentLayout = self.layoutDict:Get(uiGuildTab)
    if self.currentLayout == nil then
        if uiGuildTab == UIGuildWarRewardTab.Season then
            require "lua.client.scene.ui.home.uiGuildWarReward.guildWarLayout.UIGuildWarSeasonRewardLayout"
            self.currentLayout = UIGuildWarSeasonRewardLayout(self, self.config.seasonRewardLayout)
        elseif uiGuildTab == UIGuildWarRewardTab.GrandSeason then
            require "lua.client.scene.ui.home.uiGuildWarReward.guildWarLayout.UIGuildWarGrandSeasonLayout"
            self.currentLayout = UIGuildWarGrandSeasonLayout(self, self.config.grandSeasonRewardLayout)
        end
        self.layoutDict:Add(uiGuildTab, self.currentLayout)
    end
end

function UIGuildWarRewardView:OnUpDateListRewards(_listGuildReward)
    self.listGuildReward = _listGuildReward
    self.uiScroll:Resize(self.listGuildReward:Count())
end

function UIGuildWarRewardView:OnReadyShow()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.selectTab(1)
end

function UIGuildWarRewardView:HideLayout()
    if self.currentLayout then
        self.currentLayout:OnHide()
    end
end

function UIGuildWarRewardView:Hide()
    UIBaseView.Hide(self)
    self:HideLayout()
    self.uiScroll:Hide()
end

--- @class UIGuildWarRewardTab
UIGuildWarRewardTab = {
    Season = 1,
    GrandSeason = 2
}
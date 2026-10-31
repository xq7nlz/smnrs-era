require "lua.client.scene.ui.home.uiLeaderBoard.uiLeaderBoardLayout.UILeaderBoardLayout"
require "lua.client.scene.ui.common.LeaderBoardItemView"

--- @class UILeaderBoardView : UIBaseView
UILeaderBoardView = Class(UILeaderBoardView, UIBaseView)

--- @return void
--- @param model UILeaderBoardModel
function UILeaderBoardView:Ctor(model)
    --- @type UILeaderBoardConfig
    self.config = nil
    --- @type UILoopScroll
    self.uiScroll = nil

    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UILeaderBoardLayout
    self.currentLayout = nil

    UIBaseView.Ctor(self, model)
    --- @type UILeaderBoardModel
    self.model = model
end

--- @return void
function UILeaderBoardView:OnReadyCreate()
    ---@type UILeaderBoardConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:_InitButtonListener()
end

--- @return void
function UILeaderBoardView:InitLocalization()
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("no_data")
    --- @param v UILeaderBoardLayout
    for k, v in pairs(self.layoutDict:GetItems()) do
        v:InitLocalization()
    end
end

function UILeaderBoardView:_InitButtonListener()
    self.config.bgNone.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonNext.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickNextPage()
    end)
    self.config.buttonPrev.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickPrevPage()
    end)
end

--- @param uiPoolType UIPoolType
--- @param onCreateItem function
function UILeaderBoardView:InitScroll(uiPoolType, onCreateItem)
    self.uiScroll = UILoopScroll(self.config.loopScrollRect, uiPoolType, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig())
end

--- @param size number
--- @param isPlayMotion boolean
function UILeaderBoardView:ResizeScroll(size, isPlayMotion)
    self.uiScroll:Resize(size)
    if size > 0 and isPlayMotion == true then
        self.uiScroll:PlayMotion()
    end
end

--- @param leaderBoardType LeaderBoardType
function UILeaderBoardView:OnReadyShow(leaderBoardType)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self:GetLayout(leaderBoardType)
    self.currentLayout:OnShow()
end

function UILeaderBoardView:Hide()
    UIBaseView.Hide(self)
    self.model:OnHide()
    self:DespawnScroll()
end

function UILeaderBoardView:DespawnScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
        self.uiScroll = nil
    end
end

function UILeaderBoardView:DisableCommon()
    self.config.empty:SetActive(false)
    self.config.loading:SetActive(false)
    self.config.buttonNext.gameObject:SetActive(false)
    self.config.buttonPrev.gameObject:SetActive(false)
    self.config.page.gameObject:SetActive(false)
    self.config.textTimer.text = ""
    if self.currentLayout ~= nil then
        self.currentLayout:OnHide()
    end
    self:DespawnScroll()
end

--- @param leaderBoardType LeaderBoardType
function UILeaderBoardView:GetLayout(leaderBoardType)
    self:DisableCommon()
    self.currentLayout = self.layoutDict:Get(leaderBoardType)
    if self.currentLayout == nil then
        if leaderBoardType == LeaderBoardType.CAMPAIGN
                or leaderBoardType == LeaderBoardType.TOWER
                or leaderBoardType == LeaderBoardType.DUNGEON
                or leaderBoardType == LeaderBoardType.FRIEND_RANKING then
            require "lua.client.scene.ui.home.uiLeaderBoard.uiLeaderBoardLayout.UILeaderBoardPlayerDataGetLayout"
            self.currentLayout = UILeaderBoardPlayerDataGetLayout(self, leaderBoardType)
        elseif leaderBoardType == LeaderBoardType.GUILD_DUNGEON_RANKING then
            require "lua.client.scene.ui.home.uiLeaderBoard.uiLeaderBoardLayout.UILeaderBoardPlayerDataGetLayout"
            require "lua.client.scene.ui.home.uiLeaderBoard.uiLeaderBoardLayout.UILeaderBoardGuildDungeonRankingLayout"
            self.currentLayout = UILeaderBoardGuildDungeonRankingLayout(self, leaderBoardType)
        elseif leaderBoardType == LeaderBoardType.GUILD_BOSS_RANKING then
            require "lua.client.scene.ui.home.uiLeaderBoard.uiLeaderBoardLayout.UILeaderBoardGuildBossLayout"
            self.currentLayout = UILeaderBoardGuildBossLayout(self)
        elseif leaderBoardType == LeaderBoardType.GUILD_DUNGEON_SEASON_RANKING then
            require "lua.client.scene.ui.home.uiLeaderBoard.uiLeaderBoardLayout.UILeaderBoardGuildDungeonSeasonLayout"
            self.currentLayout = UILeaderBoardGuildDungeonSeasonLayout(self)
        elseif leaderBoardType == LeaderBoardType.GUILD_WAR_SEASON_RANKING then
            require "lua.client.scene.ui.home.uiLeaderBoard.uiLeaderBoardLayout.UILeaderBoardGuildWarRankingLayout"
            self.currentLayout = UILeaderBoardGuildWarRankingLayout(self)
        elseif leaderBoardType == LeaderBoardType.IGNATIUS_SEASON_RANKING then
            require "lua.client.scene.ui.home.uiLeaderBoard.uiLeaderBoardLayout.UILeaderBoardIgnatiusLayout"
            self.currentLayout = UILeaderBoardIgnatiusLayout(self)
        elseif leaderBoardType == LeaderBoardType.LUNAR_BOSS_RANKING then
            require "lua.client.scene.ui.home.uiLeaderBoard.uiLeaderBoardLayout.UILeaderBoardLunarBossLayout"
            self.currentLayout = UILeaderBoardLunarBossLayout(self)
        elseif leaderBoardType == LeaderBoardType.NEW_HERO_BOSS_RANKING then
            require "lua.client.scene.ui.home.uiLeaderBoard.uiLeaderBoardLayout.UILeaderBoardNewHeroBossLayout"
            self.currentLayout = UILeaderBoardNewHeroBossLayout(self)
        end
        self.currentLayout:InitLocalization()
        self.layoutDict:Add(leaderBoardType, self.currentLayout)
    end
end

function UILeaderBoardView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self.currentLayout:OnFinishAnimation()
end

function UILeaderBoardView:OnClickNextPage()
    self.currentLayout:OnClickNextPage()
end

function UILeaderBoardView:OnClickPrevPage()
    self.currentLayout:OnClickPrevPage()
end

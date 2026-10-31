require "lua.client.scene.ui.home.uiGuildWarSetup.uiGuildWarSetUpLayout.UIGuildWarSetupLayout"

--- @class UIGuildWarSetupView : UIBaseView
UIGuildWarSetupView = Class(UIGuildWarSetupView, UIBaseView)

--- @param model UIGuildWarSetupModel
function UIGuildWarSetupView:Ctor(model)
    --- @type GuildWarArea
    self.guildWarArea = nil
    --- @type UIGuildWarSetupConfig
    self.config = nil
    --- @type UISelect
    self.uiSelectPage = nil
    --- @type UILoopScroll
    self.uiScroll = nil

    --- @type GuildBasicInfoInBound
    self.guildBasicInfo = nil
    --- @type GuildWarTimeInBound
    self.guildWarTimeInBound = nil
    --- @type GuildWarInBound
    self.guildWarInBound = nil
    --- @type GuildWarConfig
    self.guildWarConfig = nil

    --- @type UIGuildWarSetupLayout
    self.currentLayout = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    UIBaseView.Ctor(self, model)
    --- @type UIGuildWarSetupModel
    self.model = model
end

function UIGuildWarSetupView:OnReadyCreate()
    ---@type UIGuildWarSetupConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.guildWarConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarConfig()

    self:InitButtonListener()
end

function UIGuildWarSetupView:InitLocalization()
    self.config.textSort.text = LanguageUtils.LocalizeCommon("sort")
    self.config.textCp.text = LanguageUtils.LocalizeCommon("power")
    self.config.textLevel.text = LanguageUtils.LocalizeCommon("level")
end

function UIGuildWarSetupView:InitButtonListener()
    self.config.backButton.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonNext.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self.currentLayout:OnClickSwitchPage(true)
    end)
    self.config.buttonPrev.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self.currentLayout:OnClickSwitchPage(false)
    end)
    self.config.buttonInfo.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickInfo()
    end)
    self.config.buttonSave.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self.currentLayout:OnClickSaveChange()
    end)
    self.config.buttonSort.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self.config.sortPannel.gameObject:SetActive(true)
    end)
    self.config.sortPannel.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self.config.sortPannel.gameObject:SetActive(false)
    end)
    self.config.buttonPower.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self.config.sortPannel.gameObject:SetActive(false)
        self:SortByPower()
    end)
    self.config.buttonLevel.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self.config.sortPannel.gameObject:SetActive(false)
        self:SortByLevel()
    end)
    self.config.buttonLeaderboard.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLeaderBoard()
    end)
end

function UIGuildWarSetupView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self.currentLayout:OnClickBack()
end

function UIGuildWarSetupView:OnClickInfo()
    local info = LanguageUtils.LocalizeHelpInfo("setup_defender_phase_info")
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

--- @return void
function UIGuildWarSetupView:OnReadyHide()
    UIBaseView.OnReadyHide(self)
    PopupMgr.ShowPopup(UIPopupName.UIGuildArea)
end

function UIGuildWarSetupView:OnReadyShow()
    self.guildBasicInfo = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
    self.guildWarTimeInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR_TIME)
    self.guildWarInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR)

    self:InitWorldArea()
    self:GetLayout()
    self.currentLayout:Show()

    self.listener = RxMgr.guildWarRegistered:Subscribe(RxMgr.CreateFunction(self, self.OnGuildUpdated))
end

function UIGuildWarSetupView:Hide()
    UIBaseView.Hide(self)
    self:HideWorldArea()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
    self.currentLayout:Hide()
    if self.listener ~= nil then
        self.listener:Unsubscribe()
        self.listener = nil
    end
end

function UIGuildWarSetupView:InitWorldArea()
    self:HideWorldArea()
    self.guildWarArea = SmartPool.Instance:SpawnLuaGameObject(AssetType.UIPool, UIPoolType.GuildWarAreaWorld)
end

function UIGuildWarSetupView:HideWorldArea()
    if self.guildWarArea ~= nil then
        self.guildWarArea:Hide()
        self.guildWarArea = nil
    end
end

function UIGuildWarSetupView:OnShowPage()
    self.model:SetListParticipants(self.guildWarInBound.listParticipants)
    self.uiScroll:Resize(self.model.listParticipants:Count())

    self.config.buttonPrev.gameObject:SetActive(self.model.currentPage > 1)
    self.config.buttonNext.gameObject:SetActive(self.model.currentPage < self.model.pageCount)

    self.uiSelectPage:SetPagesCount(self.model.pageCount)
    self.uiSelectPage:Select(self.model.currentPage)
end

function UIGuildWarSetupView:GetLayout()
    local layoutType = GuildWarSetupLayoutType.CHECK_OUT
    local selfRole = self.guildBasicInfo.guildInfo.selfRole
    local selectedForGuildWar = self.guildWarInBound:CountSelectedForGuildWar()
    if selfRole == GuildRole.LEADER or selfRole == GuildRole.SUB_LEADER then
        if selectedForGuildWar == 0 then
            layoutType = GuildWarSetupLayoutType.SET_UP
        else
            layoutType = GuildWarSetupLayoutType.MODIFY
        end
    end
    self.currentLayout = self.layoutDict:Get(layoutType)
    if self.currentLayout == nil then
        if layoutType == GuildWarSetupLayoutType.SET_UP then
            require "lua.client.scene.ui.home.uiGuildWarSetup.uiGuildWarSetUpLayout.UIGuildWarSetupBattleLayout"
            self.currentLayout = UIGuildWarSetupBattleLayout(self)
        elseif layoutType == GuildWarSetupLayoutType.MODIFY then
            require "lua.client.scene.ui.home.uiGuildWarSetup.uiGuildWarSetUpLayout.UIGuildWarUpdateDefenderLayout"
            self.currentLayout = UIGuildWarUpdateDefenderLayout(self)
        elseif layoutType == GuildWarSetupLayoutType.CHECK_OUT then
            require "lua.client.scene.ui.home.uiGuildWarSetup.uiGuildWarSetUpLayout.UIGuildWarCheckOutDefenderLayout"
            self.currentLayout = UIGuildWarCheckOutDefenderLayout(self)
        end
        self.layoutDict:Add(layoutType, self.currentLayout)
    end
end

--- @return void
function UIGuildWarSetupView:SortByPower()
    self.currentLayout:SortByPower()
end

--- @return void
function UIGuildWarSetupView:SortByLevel()
    self.currentLayout:SortByLevel()
end

function UIGuildWarSetupView:OnGuildUpdated()
    self.currentLayout:OnDefenderUpdated()
end

function UIGuildWarSetupView:OnClickLeaderBoard()
    PopupMgr.ShowPopup(UIPopupName.UILeaderBoard, LeaderBoardType.GUILD_WAR_SEASON_RANKING)
end
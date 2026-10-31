require "lua.client.core.network.event.eventKazetsu.EventKazetsuRollDraftInBound"
require "lua.client.scene.ui.home.uiRollDraftTeam.UIRollDraftTeamData"
require "lua.client.data.Player.PlayerSetting"
--- @class UIRollDraftTeamView : UIBaseView
UIRollDraftTeamView = Class(UIRollDraftTeamView, UIBaseView)

--- @return void
--- @param model UIFormationModel
function UIRollDraftTeamView:Ctor(model)
    --- @type UIRollDraftTeamConfig
    self.config = nil
    --- @type UISelect
    self.tab = nil
    ---@type HeroResource
    self.heroResourcePreview = nil
    ---@type HeroListView
    self.heroListSelectedView = nil
    ---@type HeroListView
    self.heroListRollView = nil
    --- @type PreviewHeroMenu
    self.previewHeroMenu = nil
    --- @type WorldFormation
    self.worldFormation = nil
    ---@type number
    self.powerAttacker = nil

    self.cacheResult = nil

    ---@type List
    self.listLinking1 = List()
    ---@type List
    self.listLinking2 = List()
    --- @type List
    self.listIconAllowedClass = List()

    self.coroutine = nil
    --- @type boolean
    self.isShowing = false

    self.cacheWorldFormation = false

    --- @type ItemsTableView
    self.itemsTableView = nil

    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_KAZETSU
    --- @type EventKazetsuModel
    self.eventModel = nil
    --- @type EventKazetsuConfig
    self.eventConfig = nil

    UIBaseView.Ctor(self, model)
    --- @type UIRollDraftTeamModel
    self.model = model
end

--- @return void
function UIRollDraftTeamView:OnReadyCreate()
    ---@type UIRollDraftTeamConfig
    self.config = UIBaseConfig(self.uiTransform)

    self.heroListRollView = HeroListView(self.config.heroListRoll)

    self.heroListSelectedView = HeroListView(self.config.heroListSelected)

    self:InitListHeroRollView()
    self:InitListHeroSelectedView()
    self:InitButtonListener()
end

--- @return void
--- Create view for preview hero
function UIRollDraftTeamView:InitPreviewHero()
    self.heroResourcePreview = self.eventConfig:GetHeroResourceBySelectionId(-1)
    self:ValidatePreviewHeroMenu();
end


--- @return void
function UIRollDraftTeamView:InitButtonListener()
    self.config.buttonHero.onClick:AddListener(function()
        self:OnClickHero()
    end)
    self.config.buttonHelp.onClick:AddListener(function()
        self:OnClickHelp()
    end)
    self.config.buttonInformationPreviewHero.onClick:AddListener(function()
        self:OnClickButtonInformationPreviewHero()
    end)
    self.config.buttonBack.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        self:OnClickBackOrClose()
    end)
    self.config.buttonStartTrial.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonStartTrial()
    end)
    self.config.buttonReroll.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.eventModel.listHeroResourceSelected:Count() > 0 then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("noti_has_hero_selected"))
            else
            local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GEM, self.eventConfig:GetTrialConfig().gemRefresh))
            if canExchange then
                PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_reroll"), nil, function()
                    EventKazetsuRollDraftInBound.RequestRollHeroes(function(selectionIdRandomPoolList)
                        zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
                        InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, self.eventConfig:GetTrialConfig().gemRefresh)
                        self.eventModel.heroRandomPoolList = selectionIdRandomPoolList
                        self:ClearAllListHeroData()
                        self:UpdateListHeroRollView()
                        self:UpdateListHeroSelectedView()
                    end)
                end)
            else
                zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            end
        end
    end)
    self.config.buttonRemoveAll.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRemoveAll()
    end)
end

--- @return void
--- Send list selected hero to server and go to main kazetsu trial
function UIRollDraftTeamView:OnClickButtonStartTrial()
    if self.eventModel.listHeroResourceSelected:Count() < 6 then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("noti_full_hero_selected_for_trial"))
        else
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        local callBackYes = function()
            self.eventModel.heroSelectedList:Clear()
            for i = 1, self.eventModel.listHeroResourceSelected:Count() do
                self.eventModel.heroSelectedList:Add(self.eventModel.listHeroResourceSelected:Get(i).selectionId)
            end
            EventKazetsuRollDraftInBound.SendSelectedHeroes(self.eventModel.heroSelectedList, function(selectedHeroWithStateList)
                zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
                self.eventModel.selectedHeroWithStateList = selectedHeroWithStateList
                PopupMgr.ShowAndHidePopup(UIPopupName.UIEventKazetsu, {["tab"] = EventKazetsuTab.TRIAL} , UIPopupName.UIRollDraftTeam)
            end)
        end
        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_start_trial"), nil, callBackYes)
    end
end

function UIRollDraftTeamView:OnClickBackOrClose()
    UIBaseView.OnClickBackOrClose(self)
end

--- @return void
--- Add localize text
function UIRollDraftTeamView:InitLocalization()
    self.config.localizeReroll.text = LanguageUtils.LocalizeCommon("reroll")
    self.config.localizeStartTrial.text = LanguageUtils.LocalizeCommon("start_trial")
    self.config.localizeLineupSelect.text = LanguageUtils.LocalizeCommon("lineup_select")
end

--- @return void
function UIRollDraftTeamView:OnReadyShow()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end

    self.isShowing = true

    self.canPlayMotion = true

    self.cacheResult = result

    self:InitPreviewHero()
    self:ShowPreviewHero()

    self:ShowRerollButton()
    self:ShowGemBar()

    self:ClearAllListHeroData()
    self:UpdateListHeroRollView()
    self:UpdateListHeroSelectedView()

    self.previewHeroMenu:Show()
end

--- @return void
--- Display gem bar and set it by value gem of player
function UIRollDraftTeamView:ShowGemBar()
    self.gemBar = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.gemBar)
    self.gemBar:SetIconData(MoneyType.GEM)
end

--- @return void
--- Get gem value for reroll & Display it
function UIRollDraftTeamView:ShowRerollButton()
    self.config.textCurrency.text = self.eventConfig:GetTrialConfig().gemRefresh
end

--- @return void
function UIRollDraftTeamView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
end


--- @return void
--- Create view for list hero random pool
function UIRollDraftTeamView:InitListHeroRollView()
    --- @return void
    --- @param heroIndex number
    --- @param buttonHero HeroIconView
    --- @param heroResource HeroResource
    self.onUpdateIconHero = function(heroIndex, buttonHero, heroResource)
        if self:CheckHeroAlreadySelected(heroResource.selectionId) then
            buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
            buttonHero:EnableButton(true)
        else
            buttonHero:ActiveMaskSelect(false)
            buttonHero:EnableButton(true)
        end
    end

    --- @return void
    --- @param heroIndex number
    --- @param buttonHero HeroIconView
    --- @param heroResource HeroResource
    --- Callback if hero selected then remove it otherwise add that hero to the selected list hero
    self.buttonListener = function(heroIndex, buttonHero, heroResource)
        if self:CheckHeroAlreadySelected(heroResource.selectionId) then
            --- Case remove hero
            self:RemoveHeroSelectedId(heroResource.selectionId)
            buttonHero:ActiveMaskSelect(false)
            buttonHero:EnableButton(true)
            self:UpdateListHeroSelectedView()
        else
            --- Case add hero
            if self.eventModel.listHeroResourceSelected:Count() < 6 then
                self:AddHeroResourceSelected(heroResource)
                buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
                buttonHero:EnableButton(true)
                self:UpdateListHeroSelectedView()
            else
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("noti_full_hero"))
                zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            end
        end
    end

    self.heroListRollView:Init(self.buttonListener, nil, nil, nil, nil, self.onUpdateIconHero, self.onUpdateIconHero)
end

--- @return boolean
--- Check if the hero already on the selected list hero
function UIRollDraftTeamView:CheckHeroAlreadySelected(id)
    for i, v in ipairs(self.eventModel.listHeroResourceSelected:GetItems()) do
        if v.selectionId == id then
            return true
        end
    end
    return false
end

--- @return boolean, number
--- Check if the hero already on the selected list hero so remove it
function UIRollDraftTeamView:RemoveHeroSelectedId(id)
    for i, v in ipairs(self.eventModel.listHeroResourceSelected:GetItems()) do
        if v.selectionId == id then
            self.eventModel.listHeroResourceSelected:RemoveByIndex(i)
            return true, v.id
        end
    end
    print("Hero need to remove not on the list: ", v.id)
    return false, v.id
end

--- @return void
--- Add hero to the selected list hero
function UIRollDraftTeamView:AddHeroSelectedId(selectionId)
    self.eventModel.heroSelectedList:Add(selectionId)
end

--- @return void
--- Add hero to the selected list hero
function UIRollDraftTeamView:AddHeroResourceSelected(heroResource)
    self.eventModel.listHeroResourceSelected:Add(heroResource)
end

--- @return void
--- Create view for list hero selected
function UIRollDraftTeamView:InitListHeroSelectedView()

    --- @return void
    --- @param heroIndex number
    --- @param buttonHero HeroIconView
    --- @param heroResource HeroResource
    local onUpdateIconHero = function(heroIndex, buttonHero, heroResource)
    end

    --- @return void
    --- @param heroIndex number
    --- @param buttonHero HeroIconView
    --- @param heroResource HeroResource
    --- Callback help show up popup hero info with power and skill
    local buttonListener = function(heroIndex, buttonHero, heroResource)
        local statDict = ClientConfigUtils.GetStatHero(heroResource, zg.playerData:GetMethod(PlayerDataMethod.MASTERY).classDict)
        if heroResource ~= nil then
            local data = {}
            data.heroResource = heroResource
            data.power = tostring(math.floor(statDict:Get(StatType.POWER)))
            data.statDict = statDict
            PopupMgr.ShowPopup(UIPopupName.UIHeroSummonInfo, data)
        end
    end

    self.heroListSelectedView:Init(buttonListener, nil, nil, nil, nil, onUpdateIconHero, onUpdateIconHero)
end

--- @return void
--- Add hero and background to view preview hero
function UIRollDraftTeamView:ShowPreviewHero()
    if self.heroResourcePreview ~= nil then
        self.previewHeroMenu:PreviewHero(self.heroResourcePreview, HeroModelType.Basic)
        self.previewHeroMenu:SetBgHeroMenuByName("bg_kazetsu_roll_draft", PreviewHeroBgAnchorType.RightCorner)
        self.previewHeroMenu:FlipHero()
        self.previewHeroMenu:SetPreviewHeroScale(1.5)

        local factionId = ClientConfigUtils.GetFactionIdByHeroId(self.heroResourcePreview.heroId)
        self.config.iconFaction.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconFactions, factionId)
        self.config.bgTextGlow.color = ClientConfigUtils.GetColorGlowByFaction(factionId)
        self.config.textHeroName.text = LanguageUtils.LocalizeNameHero(self.heroResourcePreview.heroId)
    end
end

--- @return void
--- Hero play attack animation on click
function UIRollDraftTeamView:OnClickHero()
    self.previewHeroMenu:PlayAttackAnimation()
end


--- @return void
function UIRollDraftTeamView:OnClickHelp()
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    local info = LanguageUtils.LocalizeHelpInfo("roll_trial_info")
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

--- @return void
--- Show popup display hero stats information
function UIRollDraftTeamView:OnClickButtonInformationPreviewHero()
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    local statDict = ClientConfigUtils.GetStatHero(self.heroResourcePreview, zg.playerData:GetMethod(PlayerDataMethod.MASTERY).classDict)
    if self.heroResourcePreview ~= nil then
        local data = {}
        data.heroResource = self.heroResourcePreview
        data.power = tostring(math.floor(statDict:Get(StatType.POWER)))
        data.statDict = statDict
        PopupMgr.ShowPopup(UIPopupName.UIHeroSummonInfo, data)
    end
end

--- @return void
--- Clear list hero resource from eventmodel
function UIRollDraftTeamView:ClearAllListHeroData()
    self.eventModel.listHeroResourceRoll:Clear()
    self.eventModel.listHeroResourceSelected:Clear()
end

--- @return void
--- Update pool list hero roll random
function UIRollDraftTeamView:UpdateListHeroRollView()
    --- Create list HeroResource by list selectionId corresponding with csv
    for i = 1, self.eventModel.heroRandomPoolList:Count() do
        local selectionId = self.eventModel.heroRandomPoolList:Get(i)
        local heroResource = self.eventConfig:GetHeroResourceBySelectionId(selectionId)
        --- Additional information to HeroResource for marking unique instead of inventoryId
        if heroResource ~= nil then
            heroResource.selectionId = selectionId
            self.eventModel.listHeroResourceRoll:Add(heroResource)
        end
    end
    self.heroListRollView:SetData(self.eventModel.listHeroResourceRoll, self.canPlayMotion)
end

--- @return void
--- Update pool list hero was selected
function UIRollDraftTeamView:UpdateListHeroSelectedView()
    self.heroListSelectedView:SetData(self.eventModel.listHeroResourceSelected)
end

--- @return void
--- Return all view was used to pool
function UIRollDraftTeamView:Hide()
    UIBaseView.Hide(self)
    if self.previewHeroMenu ~= nil then
        self.previewHeroMenu:ResetHeroToDefault()
        self.previewHeroMenu:Hide()
        self.previewHeroMenu = nil
    end
    if self.gemBar ~= nil then
        self.gemBar:ReturnPool()
        self.gemBar = nil
    end
    self.heroListRollView:ReturnPool()
    self.heroListSelectedView:ReturnPool()
    self.cacheResult = nil
    self.isShowing = false
end

function UIRollDraftTeamView:OnReadyHide()
    UIBaseView.OnReadyHide(self)
end

function UIRollDraftTeamView:ValidatePreviewHeroMenu()
    if self.previewHeroMenu == nil then
        self.previewHeroMenu = PrefabLoadUtils.Get(PreviewHeroMenu, zgUnity.transform)
    end
    self.previewHeroMenu:OnShow()
end

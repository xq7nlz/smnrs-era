--- @class UILobbyDomainView : UIBaseView
UILobbyDomainView = Class(UILobbyDomainView, UIBaseView)

--- @param model UILobbyDomainModel
function UILobbyDomainView:Ctor(model)
    --- @type UILobbyDomainConfig
    self.config = nil
    --- @type List
    self.listHero = List()
    --- @type List
    self.listClass = List()
    --- @type UISelect
    self.tab = nil

    --- @type List
    self.listCrew = List()

    --- @type function
    self.updateTime = nil
    --- @type DomainInBound
    self.domainInBound = nil

    --- @type ItemsTableView
    self.itemsTableView = nil

    --- @type DomainConfig
    self.domainConfig = nil

    ---@type List
    self.listExtendItem = List()

    UIBaseView.Ctor(self, model)
    --- @type UILobbyDomainModel
    self.model = model
end

function UILobbyDomainView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    uiCanvas:SetBackgroundSize(self.config.bg)

    ---@type UILobbyApplyConfig
    self.lobbyConfig = UIBaseConfig(self.config.lobby)

    self:InitTableChest()

    self:InitButtons()

    self:InitUpdateTime()

    -- Tab
    --- @param obj UITabPopupConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect)
        obj.button.interactable = not isSelect
        obj.imageOn.gameObject:SetActive(isSelect)
    end
    local onChangeSelect = function(indexTab)
        if indexTab == 1 then
            self:ShowLobby()
        elseif indexTab == 2 then
            self:ShowShowInvitation()
        end
    end
    self.tab = UISelect(self.config.tab, UIBaseConfig, onSelect, onChangeSelect)

    --- @param obj UIDomainInvitationItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        local callbackAccept = nil
        local callbackApply = nil
        --- @type CrewInvitation
        local crewInvitation = self.listCrew:Get(index + 1)
        local crewId = crewInvitation.crewId
        if self.tab.indexTab == 2 then
            callbackAccept = function(id)
                self:AcceptById(crewId)
            end
        elseif self.tab.indexTab == 1 then
            callbackApply = function(id)
                self:ApplyById(crewId)
            end
        end
        obj:SetData(crewInvitation, callbackAccept, callbackApply, function()
            self:FailedBy(crewId, self.tab.indexTab)
        end, index + 1)
    end
    self.uiScroll = UILoopScroll(self.lobbyConfig.listGuildScroll, UIPoolType.UIDomainInvitationItemView, onCreateItem, onCreateItem)

    self.domainConfig = ResourceMgr.GetDomainConfig()
end

function UILobbyDomainView:InitTableChest()
    --- @param rootIconView RootIconView
    local onInitItem = function(rootIconView)
        rootIconView:AddListener(function()

        end)
    end
    self.itemsTableView = ItemsTableView(self.config.chestAnchor, nil, UIPoolType.SimpleButtonView)
end

function UILobbyDomainView:ShowLobby(forceUpdate)
    self.lobbyConfig.searchInput.text = ""
    self.lobbyConfig.searchInput.transform.parent.gameObject:SetActive(true)
    self.domainInBound:ValidateListRecommendation(function()
        self.listCrew = zg.playerData.domainData.listRecommendation
        self:UpdateList()
    end, nil, forceUpdate)
end

function UILobbyDomainView:ShowShowInvitation(forceUpdate)
    self.lobbyConfig.searchInput.transform.parent.gameObject:SetActive(false)
    self.config.notifyInvitation:SetActive(false)
    self.domainInBound:ValidateListInvitation(function()
        self.listCrew = zg.playerData.domainData.listInvitation
        self:UpdateList()
    end, nil, forceUpdate)
end

function UILobbyDomainView:AcceptById(id)
    self.domainInBound:RemoveInvitationById(id)
    DomainInBound.Validate(function()
        PopupMgr.ShowPopup(UIPopupName.UIDomainTeam, nil, UIPopupHideType.HIDE_ALL)
    end, true)
end

function UILobbyDomainView:ApplyById(id)
    self.domainInBound:RemoveRecommendationById(id)
    DomainInBound.Validate(function()
        PopupMgr.ShowPopup(UIPopupName.UIDomainTeam, nil, UIPopupHideType.HIDE_ALL)
    end, true)
end

function UILobbyDomainView:FailedBy(id, tabIndex)
    if tabIndex == 1 then
        self:ShowLobby(true)
    else
        self:ShowShowInvitation(true)
    end
end

function UILobbyDomainView:InitUpdateTime()
    self:InitUpdateTimeNextDay(function(timeNextDay, isSetTime)
        self.config.textTimer.text = string.format(self.localizeRefresh, UIUtils.SetColorString(UIUtils.green_dark, timeNextDay))
        if isSetTime == true then
            UIUtils.AlignText(self.config.textTimer)
        end
    end)
end

function UILobbyDomainView:InitButtons()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonChange.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChange()
    end)
    self.config.buttonCreate.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCreate()
    end)
    self.config.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("domains_info"))
    end)
    self.lobbyConfig.buttonSearch.onClick:AddListener(function()
        self:OnApplySearch()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)

    self.config.fastCreateButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCreate(true)
    end)
    self.lobbyConfig.buttonRefresh.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRefresh()
    end)
    self.lobbyConfig.toggleSearch.onClick:AddListener(function()
        self.lobbyConfig.searchOption:SetActive(true)
    end)
    self.lobbyConfig.optName.onClick:AddListener(function()
        self:SetToggleState(true)
    end)
    self.lobbyConfig.optId.onClick:AddListener(function()
        self:SetToggleState(false)
    end)
end

function UILobbyDomainView:InitLocalization()
    self.config.textAllowedClasses.text = LanguageUtils.LocalizeCommon("allowed_class")
    self.config.textReward.text = LanguageUtils.LocalizeCommon("reward")
    self.config.textYourTeam.text = LanguageUtils.LocalizeCommon("your_team")

    self.config.localizeCreate.text = LanguageUtils.LocalizeCommon("create")

    self.config.textTitle.text = LanguageUtils.LocalizeFeature(FeatureType.DOMAINS)

    self.config.textLobbyTab.text = LanguageUtils.LocalizeCommon("lobby")
    self.config.textInvitationTab.text = LanguageUtils.LocalizeCommon("invitation")

    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("no_data")

    self.localizeRefresh = LanguageUtils.LocalizeCommon("refresh_in")

    self.lobbyConfig.localizeSearch.text = LanguageUtils.LocalizeCommon("search")
    self.lobbyConfig.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
    self.lobbyConfig.localizeEnterGuildName.text = LanguageUtils.LocalizeCommon("enter_team_name_id")
    self.lobbyConfig.localizeName.text = LanguageUtils.LocalizeCommon("name")
    self.lobbyConfig.localizeId.text = LanguageUtils.LocalizeCommon("id")

    self.config.textFastCreate.text = LanguageUtils.LocalizeCommon("fast_create")
end

function UILobbyDomainView:OnReadyShow()
    ---@type DomainInBound
    self.domainInBound = zg.playerData:GetDomainInBound()
    if self.domainInBound.isInCrew == true then
        PopupMgr.HidePopup(self.model.uiName)
        PopupMgr.ShowPopup(UIPopupName.UIDomainTeam, nil, UIPopupHideType.HIDE_ALL)
        return
    end
    ---@type DailyTeamDomainConfig
    self.dailyTeamConfig = ResourceMgr.GetDomainConfig():GetDomainConfigByDay(self.domainInBound.challengeDay)

    self:UpdateTeam()

    for _, v in ipairs(self.dailyTeamConfig.classRequire:GetItems()) do
        local requirementClass = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RequirementHeroIconView, self.config.class)
        requirementClass.config.icon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconClassHeroes, v)
        self.listClass:Add(requirementClass)
    end

    self.tab:Select(1)

    self:ShowListRewardChest()
    self:ShowListExtendReward()
    self:SetToggleState(true)

    self:ShowTicket()

    if self.listenerDomain == nil then
        self.listenerDomain = RxMgr.domainUpdated:Subscribe(RxMgr.CreateFunction(self, self.DomainUpdated))
    end

    self:CheckNotificationInvitation()
end

--- @param isSearchByName boolean
function UILobbyDomainView:SetToggleState(isSearchByName)
    self.isSearchByName = isSearchByName
    if isSearchByName == true then
        self.lobbyConfig.toggleLabel.text = LanguageUtils.LocalizeCommon("name")
    else
        self.lobbyConfig.toggleLabel.text = LanguageUtils.LocalizeCommon("id")
    end
    self.lobbyConfig.searchOption:SetActive(false)
end

function UILobbyDomainView:OnClickChange()
    local data = {}
    data.callbackClose = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UILobbyDomain, nil, UIPopupName.UIFormationDomain)
    end
    data.callbackSave = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UILobbyDomain, nil, UIPopupName.UIFormationDomain)
    end
    PopupMgr.ShowAndHidePopup(UIPopupName.UIFormationDomain, data, UIPopupName.UILobbyDomain)
end

function UILobbyDomainView:OnClickCreate(isFastCreate)
    local data = {}
    data.callbackCreateSuccess = function(id)
        PopupMgr.ShowPopup(UIPopupName.UIDomainTeam, nil, UIPopupHideType.HIDE_ALL)
    end
    if isFastCreate == true then
        DomainInBound.RequestCreateTeam(string.format(LanguageUtils.LocalizeCommon("default_team_x"), PlayerSettingData.playerId % 1000),
                LanguageUtils.LocalizeCommon("default_team_desc"), true, data.callbackCreateSuccess)
    else
        PopupMgr.ShowPopup(UIPopupName.UIDomainCreateTeam, data)
    end
end

function UILobbyDomainView:UpdateList()
    if self.listCrew:Count() > 0 then
        self.lobbyConfig.empty:SetActive(false)
    else
        self.lobbyConfig.empty:SetActive(true)
    end
    self.uiScroll:Resize(self.listCrew:Count())
end

function UILobbyDomainView:UpdateTeam()
    self:ReturnPoolListHero()
    for _, v in ipairs(self.domainInBound.domainContributeHeroListInBound.listHeroContribute:GetItems()) do
        ---@type HeroIconView
        local heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.yourTeam)
        ---@type HeroResource
        local heroResource = InventoryUtils.GetHeroResourceByInventoryId(v)
        local heroIconData = HeroIconData.CreateByHeroResource(heroResource)
        heroIconView:SetIconData(heroIconData)
        heroIconView:SetSize(150, 150)
        heroIconView:AddListener(function()
            local overrideStatDict = ClientConfigUtils.GetStatHero(heroResource)
            PopupUtils.ShowPreviewHeroInfo(heroResource, overrideStatDict)
        end)
        self.listHero:Add(heroIconView)
    end
end

function UILobbyDomainView:ReturnPoolListHero()
    if self.listHero ~= nil then
        ---@param v HeroIconView
        for i, v in ipairs(self.listHero:GetItems()) do
            v:ReturnPool()
        end
        self.listHero:Clear()
    end
end

function UILobbyDomainView:ReturnPoolListClass()
    if self.listClass ~= nil then
        ---@param v HeroIconView
        for i, v in ipairs(self.listClass:GetItems()) do
            v:ReturnPool()
        end
        self.listClass:Clear()
    end
end

--- @return void
function UILobbyDomainView:OnClickBackOrClose()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UILobbyDomain)
end

function UILobbyDomainView:Hide()
    UIBaseView.Hide(self)

    self:ReturnPoolListHero()
    self:ReturnPoolListClass()
    self:ReturnPoolListExtendRewardItem()

    self.itemsTableView:Hide()

    if self.listenerDomain then
        self.listenerDomain:Unsubscribe()
        self.listenerDomain = nil
    end
end

function UILobbyDomainView:OnClickRefresh()
    if self.tab.indexTab ~= 1 then
        self.tab:Select(1)
    end
    self.domainInBound:ValidateListRecommendation(function()
        self.listCrew = zg.playerData.domainData.listRecommendation
        self:UpdateList()
    end, nil, nil, true)
end

function UILobbyDomainView:OnApplySearch()
    if self.tab.indexTab ~= 1 then
        self.tab:Select(1)
    end
    self.lobbyConfig.searchOption:SetActive(false)
    local inputSearch = self.lobbyConfig.searchInput.text
    if inputSearch == "" then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_input"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        return
    end

    if self.isSearchByName == false then
        if MathUtils.IsNumber(tonumber(inputSearch)) == false then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("use_id_format"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            return
        end
    end

    local onReceived = function(result)
        local list = nil
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            list = NetworkUtils.GetListDataInBound(buffer, CrewInvitation)
        end
        local onSuccess = function()
            self.listCrew = list
            self:UpdateList()
            --self.uiScroll:Resize(self.listCrew:Count())
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.DOMAINS_CREW_SEARCH, UnknownOutBound.CreateInstance(PutMethod.String, inputSearch, PutMethod.Bool, self.isSearchByName), onReceived)
end

---@return void
function UILobbyDomainView:GetNumberSet(type, idItem)
    local numberSet
    ---@type table
    local itemData = ResourceMgr.GetServiceConfig():GetItemData(type, idItem)
    if itemData.setId ~= nil then
        for i = 1, 4 do
            if self.heroResource.heroItem:IsContainKey(i) and self.heroResource.heroItem:Get(i) > 0 then
                local tempIdItem = self.heroResource.heroItem:Get(i)
                ---@type EquipmentDataEntry
                local equipmentData = ResourceMgr.GetServiceConfig():GetItemData(ResourceType.ItemEquip, tempIdItem)
                if itemData.setId == equipmentData.setId then
                    if numberSet == nil then
                        numberSet = 1
                    else
                        numberSet = numberSet + 1
                    end
                end
            end
        end
    end
    return numberSet
end

function UILobbyDomainView:ShowListRewardChest()
    local listChestData = List()
    local chestPoolDict = self.domainConfig:GetDomainRewardConfig():GetChestRewardPoolDict()
    local stageCount = chestPoolDict:Count()
    local stage = 1

    --- @param k MoneyType
    --- @param v List
    for k, v in pairs(chestPoolDict:GetItems()) do
        local chestData = {}
        local chestTierVisual = stage + 9 - stageCount
        chestData.icon = ResourceLoadUtils.LoadMoneyIcon(k)
        chestData.scale = 0.3
        chestData.stage = stage
        chestData.callback = function()
            self:OnSelectChest(chestData.stage, chestTierVisual, v)
        end
        listChestData:Add(chestData)

        stage = stage + 1
    end

    self.itemsTableView:SetData(listChestData)
    self.itemsTableView:SetSize(90, 90)
end

function UILobbyDomainView:ShowListExtendReward()
    local listReward = self.domainConfig:GetDomainRewardConfig():GetExtendReward()
    if listReward then
        ---@param v RewardInBound
        for _, v in pairs(listReward:GetItems()) do
            ---@type RootIconView
            local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.chestAnchor)
            ---@type ItemIconData
            local itemIconData = v:GetIconData()
            itemIconData.quantity = nil
            item:SetIconData(itemIconData)
            item:RegisterShowInfo()
            item:SetSize(90, 90)
            item.config.transform.localScale = U_Vector3(0.6, 0.6, 0.6)
            self.listExtendItem:Add(item)
        end
    end
end

function UILobbyDomainView:ReturnPoolListExtendRewardItem()
    if self.listExtendItem:Count() > 0 then
        ---@param v RootIconView
        for _, v in pairs(self.listExtendItem:GetItems()) do
            v:ReturnPool()
        end
        self.listExtendItem:Clear()
    end
end

--- @param listReward List
function UILobbyDomainView:OnSelectChest(stage, chestTierVisual, listReward)
    --- @type {listItemData, iconChest, chestName, chestInfo}
    local data = {}
    data.listItemData = RewardInBound.GetItemIconDataList(listReward)
    for i = 1, data.listItemData:Count() do
        --- @type ItemIconData
        local itemIconData = data.listItemData:Get(i)
        itemIconData.quantity = nil
    end
    data.iconChest = ResourceLoadUtils.LoadChestIcon(chestTierVisual)
    data.chestName = string.format(LanguageUtils.LocalizeCommon("domain_chest_stage_x_name"), stage)
    data.chestInfo = string.format(LanguageUtils.LocalizeCommon("domain_chest_stage_x_desc"), stage)

    PopupMgr.ShowPopup(UIPopupName.UIPopupPackOfItems, data)
end

function UILobbyDomainView:CheckNotificationInvitation()
    self.domainInBound:ValidateListInvitation(function()
        local listInvitation = zg.playerData.domainData.listInvitation
        self.config.notifyInvitation:SetActive(listInvitation ~= nil and listInvitation:Count() > 0)
    end)
end

function UILobbyDomainView:ShowTicket()
    local maxStamina = self.domainConfig:GetStamina()
    local currentStamina = InventoryUtils.GetMoney(MoneyType.DOMAIN_CHALLENGE_STAMINA)
    if currentStamina < maxStamina then
        local current = zg.timeMgr:GetServerTime()
        local startTimeOfDay = TimeUtils.GetTimeStartDayFromSec(current)
        if startTimeOfDay > self.domainInBound.lastTimeRefreshTicket then
            InventoryUtils.Add(ResourceType.Money, MoneyType.DOMAIN_CHALLENGE_STAMINA, maxStamina - currentStamina)
            currentStamina = maxStamina
            self.domainInBound.lastTimeRefreshTicket = current
        end
    end

    self.config.textCurrenry.text = string.format("%s/%s", currentStamina, maxStamina)
    self.config.iconCurrency.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.DOMAIN_CHALLENGE_STAMINA)
    self.config.iconCurrency:SetNativeSize()
end

--- @param data {}
function UILobbyDomainView:DomainUpdated(data)
    local serverNotificationType = data.serverNotificationType
    if serverNotificationType == ServerNotificationType.DOMAINS_CREW_MEMBER_ADDED then
        PopupMgr.ShowPopup(UIPopupName.UIDomainTeam, nil, UIPopupHideType.HIDE_ALL)
    elseif serverNotificationType == ServerNotificationType.DOMAINS_CREW_INVITATION_UPDATED then
        self.config.notifyInvitation:SetActive(true)
    else
        self.domainInBound = zg.playerData:GetDomainInBound()
        if self.domainInBound.isInCrew == true then
            PopupMgr.ShowPopup(UIPopupName.UIDomainTeam, nil, UIPopupHideType.HIDE_ALL)
        end
    end
end
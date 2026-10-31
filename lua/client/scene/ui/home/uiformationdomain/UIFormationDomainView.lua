require "lua.client.scene.ui.home.uiFormation2.worldFormation.WorldFormation"
require "lua.client.scene.ui.home.uiFormationDomain.DomainWorldTeamFormation"

--- @class UIFormationDomainView : UIBaseView
UIFormationDomainView = Class(UIFormationDomainView, UIBaseView)

--- @param model UIFormationDomainModel
function UIFormationDomainView:Ctor(model)
    --- @type UIFormationDomainConfig
    self.config = nil
    ---@type HeroListView
    self.heroList = nil
    ---@type Dictionary
    self.dictInventoryId = Dictionary()
    ---@type List
    self.listClass = List()
    self.maxHero = 4
    --- @type List
    self.listIconAllowedClass = List()

    --- @type WorldFormation
    self.worldFormation = nil
    --- @type number
    self.formationId = 4

    --- @type ItemsTableView
    self.itemsTableView = nil

    --- @type Dictionary
    self.positionAnchorDict = Dictionary()

    UIBaseView.Ctor(self, model)
    --- @type UIFormationDomainModel
    self.model = model
end

function UIFormationDomainView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    --HERO LIST
    self.heroList = HeroListView(self.config.heroList)

    --- @return void
    --- @param heroIndex number
    --- @param buttonHero HeroIconView
    --- @param heroResource HeroResource
    self.onUpdateIconHero = function(heroIndex, buttonHero, heroResource)
        if self.dictInventoryId:IsContainValue(heroResource.inventoryId) then
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
    self.buttonListener = function(heroIndex, buttonHero, heroResource)
        if self.dictInventoryId:IsContainValue(heroResource.inventoryId) then
            self:RemoveHeroFromTeam(heroResource.inventoryId)
            buttonHero:ActiveMaskSelect(false)
            buttonHero:EnableButton(true)
            self:UpdateHeroSelectedText()
        else
            if self.dictInventoryId:Count() < self.dailyTeamConfig.maxHero then
                self:AddHeroToTeam(heroResource.inventoryId)
                buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
                buttonHero:EnableButton(true)
                self:UpdateHeroSelectedText()
            else
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("noti_full_hero"))
                zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            end
        end
    end

    --- @return void
    --- @param heroIndex number
    --- @param heroResource HeroResource
    local filterAnd = function(heroIndex, heroResource)
        return self.dailyTeamConfig.classRequire:IsContainValue(ResourceMgr.GetHeroClassConfig():GetClass(heroResource.heroId))
    end

    self.heroList:Init(self.buttonListener, nil, filterAnd, nil, nil, self.onUpdateIconHero, self.onUpdateIconHero)
    self:InitButtons()

    self.itemsTableView = ItemsTableView(self.config.allowedClasses, nil, UIPoolType.SimpleButtonView)
end

function UIFormationDomainView:UpdateHeroSelectedText()
    local current = self.dictInventoryId:Count()
    local max = self.dailyTeamConfig.maxHero
    local color = UIUtils.red_dark
    if current >= max then
        color = UIUtils.green_dark
    end
    self.config.textHeroSelectedCount.text = string.format("%s <color=#%s>%s/%s</color>",
            LanguageUtils.LocalizeCommon("selected_hero"), color, current, max)
end

function UIFormationDomainView:InitButtons()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelp()
    end)
    self.config.battleButtonNotSkip.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSave()
    end)
    self.config.buttonRemoveAll.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:RemoveAll()
        self.heroList.uiScroll:RefreshCells()
    end)
end

function UIFormationDomainView:InitLocalization()
    self.config.localizeSelectHero.text = LanguageUtils.LocalizeCommon("select_hero_battle")

    local localizeBattle = LanguageUtils.LocalizeCommon("save")
    self.config.localizeBattle.text = localizeBattle
    self.config.localizeRemoveAll.text = LanguageUtils.LocalizeCommon("remove_all")
    self.config.textAllowedClasses.text = LanguageUtils.LocalizeCommon("allowed_class")
end

--- @param data {callbackClose : function}
function UIFormationDomainView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)
    if data ~= nil then
        self.callbackSave = data.callbackSave
    end
    ---@type DomainInBound
    self.domainInBound = zg.playerData:GetDomainInBound()
    ---@type DailyTeamDomainConfig
    self.dailyTeamConfig = ResourceMgr.GetDomainConfig():GetDomainConfigByDay(self.domainInBound.challengeDay)

    self:InitWorldFormation()

    self.dictInventoryId:Clear()
    for i, v in ipairs(self.domainInBound.domainContributeHeroListInBound.listHeroContribute:GetItems()) do
        self:AddHeroToTeam(v)
    end

    self.heroList:SetData(InventoryUtils.Get(ResourceType.Hero))
    self:UpdateHeroSelectedText()

    local day = zg.playerData:GetDomainInBound().challengeDay
    local listClassRequire = ResourceMgr.GetDomainConfig():GetDomainConfigByDay(day).classRequire

    self.listIconAllowedClass:Clear()

    for i = 1, listClassRequire:Count() do
        local classData = {}
        local classId = listClassRequire:Get(i)
        classData.icon = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconClassFormation, classId)
        classData.callback = function()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeClass(classId))
        end
        self.listIconAllowedClass:Add(classData)
    end

    self.itemsTableView:SetData(self.listIconAllowedClass)
    self.itemsTableView:SetSize(105, 105)
end

function UIFormationDomainView:InitWorldFormation()
    if self.worldFormation == nil then
        local transform = SmartPool.Instance:SpawnTransform(AssetType.UI, "world_formation")
        self.worldFormation = WorldFormation(transform)
    end

    self.worldFormation:OnShow(false)

    local bgAnchorTop = "formation_domain_anchor_top"
    self.worldFormation:ShowBgAnchor(bgAnchorTop)

    self.domainWorldTeamFormation = DomainWorldTeamFormation(self.worldFormation)
end

function UIFormationDomainView:Hide()
    ClientConfigUtils.KillCoroutine(self.coroutine)

    self.heroList:ReturnPool()

    self:RemoveAll()

    self:HideWorldFormation()

    self.itemsTableView:Hide()
    UIBaseView.Hide(self)
end

function UIFormationDomainView:HideWorldFormation()
    if self.worldFormation ~= nil then
        self.worldFormation:OnHide()
        self.worldFormation = nil
    end
    if self.domainWorldTeamFormation then
        self.domainWorldTeamFormation:OnHide()
    end
end

function UIFormationDomainView:OnClickSave()
    if self.dictInventoryId:Count() >= self.dailyTeamConfig.minHero then
        local listId = List()
        for i, v in pairs(self.dictInventoryId:GetItems()) do
            listId:Add(v)
        end
        self.domainInBound:SetListHeroDomain(listId, self.callbackSave)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("you_need_select_hero"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

function UIFormationDomainView:RemoveAll()
    local slotIndex = 0
    for k, v in pairs(self.dictInventoryId:GetItems()) do
        slotIndex = slotIndex + 1
        self:RemoveHeroFromTeam(v)
    end
    self.dictInventoryId:Clear()

    for i = 1, self.config.hero.childCount do
        self.config.hero:GetChild(i - 1).gameObject:SetActive(false)
    end
end

function UIFormationDomainView:RemoveHeroFromTeam(inventoryId)
    for i, v in pairs(self.dictInventoryId:GetItems()) do
        if v == inventoryId then
            self.dictInventoryId:RemoveByKey(i)
            self.config.hero:GetChild(i - 1).gameObject:SetActive(false)

            self:ShowPreviewHero(i, nil)
            break
        end
    end
end

function UIFormationDomainView:AddHeroToTeam(inventoryId)
    for i = 1, self.dailyTeamConfig.maxHero do
        if (self.dictInventoryId:Get(i) == nil) then
            self.dictInventoryId:Add(i, inventoryId)

            local heroResource = InventoryUtils.GetHeroResourceByInventoryId(inventoryId)
            self:ShowPreviewHero(i, heroResource)
            break
        end
    end
end

--- @param hero {isFrontLine, positionId}
function UIFormationDomainView:CallbackRemove(hero)
    --- @type FormationData
    local formationData = ResourceMgr.GetServiceConfig():GetHeroes():GetFormationData(self.formationId)
    local slotIndex = 0
    if hero.isFrontLine == true then
        slotIndex = hero.positionId
    else
        slotIndex = formationData.frontLine + hero.positionId
    end
    local heroInventoryId = self.dictInventoryId:Get(slotIndex)
    if heroInventoryId ~= nil then
        self:RemoveHeroFromTeam(heroInventoryId)
        self.heroList.uiScroll:RefreshCells()
    end
end

function UIFormationDomainView:OnClickHelp()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("domains_formation_info"))
end

function UIFormationDomainView:ShowPreviewHero(slot, heroResource)
    self.domainWorldTeamFormation:PreviewHero(slot, heroResource)
end
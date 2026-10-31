--- @type number
local TIME_MOVE_TABLE = 0.8
--- @class UIHeroSummonTableViewRemake
UIHeroSummonTableViewRemake = Class(UIHeroSummonTableViewRemake)

--- @return void
--- @param uiTransform UnityEngine_RectTransform
--- @param view UIHeroSummonViewRemake
function UIHeroSummonTableViewRemake:Ctor(uiTransform, view)
    --- @type UnityEngine_RectTransform
    self.uiTransform = uiTransform
    --- @type HeroSummonData
    self.csv = ResourceMgr.GetHeroSummonConfig()
    --- @type EventRateUp
    self.eventRateUp = nil
    --- @type EventKazetsuConfig
    self.eventKazetsuConfig = nil
    --- @type EventNewHeroSummonConfig
    self.eventNewHeroSummonConfig = nil
    --- @type EventNewHeroSummonConfig
    self.eventNewHeroSummonConfig2 = nil
    --- @type EventNewHeroSummonConfig
    self.eventHeroReleaseSummonConfig = nil

    --- @type UIHeroSummonViewRemake
    self.view = view

    self:OnReadyCreate()
end

function UIHeroSummonTableViewRemake:OnReadyCreate()
    --- @type UIHeroSummonTableRemakeConfig
    self.config = UIBaseConfig(self.uiTransform)
    ---@type UINewHeroSummonTableConfig
    self.newHeroConfig1 = UIBaseConfig(self.config.newHeroSummoner)
    ---@type UINewHeroSummonTableConfig
    self.newHeroConfig2 = UIBaseConfig(self.config.newHeroSummoner2)
    ---@type UINewHeroSummonTableConfig
    self.heroReleaseConfig = UIBaseConfig(self.config.heroReleaseSummon)
    ---@type UINewHeroSummonTableConfig
    self.heroKazetsuConfig = UIBaseConfig(self.config.heroKazetsuSummon)

    self:InitButtonListener()
    self:InitSummonPrice()
end

--- @return void
function UIHeroSummonTableViewRemake:InitButtonListener()
    self.config.buttonBasicSummon1.onClick:AddListener(function()
        self:OnClickSummon(SummonType.Basic, 1)
    end)

    self.config.buttonBasicSummon10.onClick:AddListener(function()
        self:OnClickSummon(SummonType.Basic, 10)
    end)

    self.config.buttonBasicSummonAds.onClick:AddListener(function()
        self:OnClickSummonAds(SummonType.Basic, 1)
    end)

    self.config.buttonFriendshipSummon1.onClick:AddListener(function()
        self:OnClickSummon(SummonType.Friendship, 1)
    end)

    self.config.buttonFriendshipSummon10.onClick:AddListener(function()
        self:OnClickSummon(SummonType.Friendship, 10)
    end)

    self.config.buttonHeroicSummon1.onClick:AddListener(function()
        local priceData = self.csv:GetSummonPrice(SummonType.Heroic, 1)
        local isValid = InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_HEROIC_SCROLL, priceData.summonPrice)
        self:OnClickSummon(SummonType.Heroic, 1, not isValid)
    end)
    self.config.buttonHeroicSummon10.onClick:AddListener(function()
        local priceData = self.csv:GetSummonPrice(SummonType.Heroic, 10)
        local isValid = InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_HEROIC_SCROLL, priceData.summonPrice)
        self:OnClickSummon(SummonType.Heroic, 10, not isValid)
    end)

    self.config.buttonHeroicSummonAds.onClick:AddListener(function()
        self:OnClickSummonAds(SummonType.Heroic, 1)
    end)

    self.config.rateupButtonGreen.onClick:AddListener(function()
        local priceData = self.eventRateUp:GetSummonRateUpPrice(SummonType.RateUp, 1)
        local isValid = InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_HEROIC_SCROLL, priceData.summonPrice)
        self:OnClickSummon(SummonType.RateUp, 1, not isValid)
    end)
    self.config.rateupButtonRed.onClick:AddListener(function()
        local priceData = self.eventRateUp:GetSummonRateUpPrice(SummonType.RateUp, 10)
        local isValid = InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_HEROIC_SCROLL, priceData.summonPrice)
        self:OnClickSummon(SummonType.RateUp, 10, not isValid)
    end)

    self.newHeroConfig1.newHeroButtonGreen.onClick:AddListener(function()
        local priceData = self.eventNewHeroSummonConfig:GetSummonRateUpPrice(SummonType.NewHero, 1)
        local isValid = InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_ELITE_SCROLL, priceData.summonPrice)
        self:OnClickSummon(SummonType.NewHero, 1, not isValid)
    end)
    self.newHeroConfig1.newHeroButtonRed.onClick:AddListener(function()
        local priceData = self.eventNewHeroSummonConfig:GetSummonRateUpPrice(SummonType.NewHero, 10)
        local isValid = InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_ELITE_SCROLL, priceData.summonPrice)
        self:OnClickSummon(SummonType.NewHero, 10, not isValid)
    end)

    self.newHeroConfig2.newHeroButtonGreen.onClick:AddListener(function()
        local priceData = self.eventNewHeroSummonConfig2:GetSummonRateUpPrice(SummonType.NewHero2, 1)
        local isValid = InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_ELITE_SCROLL, priceData.summonPrice)
        self:OnClickSummon(SummonType.NewHero2, 1, not isValid)
    end)
    self.newHeroConfig2.newHeroButtonRed.onClick:AddListener(function()
        local priceData = self.eventNewHeroSummonConfig2:GetSummonRateUpPrice(SummonType.NewHero2, 10)
        local isValid = InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_ELITE_SCROLL, priceData.summonPrice)
        self:OnClickSummon(SummonType.NewHero2, 10, not isValid)
    end)

    self.heroKazetsuConfig.newHeroButtonGreen.onClick:AddListener(function()
        local priceData = self.eventKazetsuConfig:GetSummonRateUpPrice(SummonType.Kazetsu, 1)
        local isValid = InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_ELITE_SCROLL, priceData.summonPrice)
        self:OnClickSummon(SummonType.Kazetsu, 1, not isValid)
    end)
    self.heroKazetsuConfig.newHeroButtonRed.onClick:AddListener(function()
        local priceData = self.eventKazetsuConfig:GetSummonRateUpPrice(SummonType.Kazetsu, 10)
        local isValid = InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_ELITE_SCROLL, priceData.summonPrice)
        self:OnClickSummon(SummonType.Kazetsu, 10, not isValid)
    end)

    self.heroReleaseConfig.newHeroButtonGreen.onClick:AddListener(function()
        local priceData = self.eventHeroReleaseSummonConfig:GetSummonRateUpPrice(SummonType.HeroRelease, 1)
        local isValid = InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_ELITE_SCROLL, priceData.summonPrice)
        self:OnClickSummon(SummonType.HeroRelease, 1, not isValid)
    end)
    self.heroReleaseConfig.newHeroButtonRed.onClick:AddListener(function()
        local priceData = self.eventHeroReleaseSummonConfig:GetSummonRateUpPrice(SummonType.HeroRelease, 10)
        local isValid = InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_ELITE_SCROLL, priceData.summonPrice)
        self:OnClickSummon(SummonType.HeroRelease, 10, not isValid)
    end)
end

function UIHeroSummonTableViewRemake:OnClickSummon(summonType, quantity, isUseGem)
    self.view:Summon(summonType, quantity, isUseGem, self)
end

function UIHeroSummonTableViewRemake:OnClickSummonAds(summonType)
    self.view:SummonByWatchAds(summonType, self)
end

--- @return void
function UIHeroSummonTableViewRemake:InitSummonPrice()
    UIHeroSummonViewRemake.SetScrollInfo(self.config.iconBasicScroll1, self.config.textPriceBasicSummon1, SummonType.Basic, 1)
    UIHeroSummonViewRemake.SetScrollInfo(self.config.iconBasicScroll10, self.config.textPriceBasicSummon10, SummonType.Basic, 10)

    UIHeroSummonViewRemake.SetScrollInfo(self.config.iconFriendshipScroll1, self.config.textPriceFriendSummon1, SummonType.Friendship, 1)
    UIHeroSummonViewRemake.SetScrollInfo(self.config.iconFriendshipScroll10, self.config.textPriceFriendSummon10, SummonType.Friendship, 10)
end

--- @return void
function UIHeroSummonTableViewRemake:InitLocalize()
    self.config.textBasicSummonAds.text = LanguageUtils.LocalizeCommon("watch")
end

--- @return void
function UIHeroSummonTableViewRemake:Show()
    self:SetEventRateUp()
    self:SetEventNewHero()
    self:SetMoneyInfo()
    self:SetActive(true)
    self:InitLocalize()
    self.view.uiPreviewHeroSummon:PlayBeforeSummon()
end
function UIHeroSummonTableViewRemake:SetEventRateUp()
    if self.view:IsRateUpOpening() then
        self.eventRateUp = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_RATE_UP):GetConfig()
    end
end

function UIHeroSummonTableViewRemake:SetEventNewHero()
    if self.view:IsNewHeroOpening() then
        self.eventNewHeroSummonConfig = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_SUMMON):GetConfig()
    end
    if self.view:IsNewHero2Opening() then
        self.eventNewHeroSummonConfig2 = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_RATE_UP):GetConfig()
    end
    if self.view:IsEventKazetsuOpening() then
        self.eventKazetsuConfig = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU):GetConfig()
    end
    if self.view:IsHeroReleaseOpening() then
        --- @type EventHeroReleaseConfig
        local eventHeroReleaseConfig = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HERO_RELEASE):GetConfig()
        self.eventHeroReleaseSummonConfig = eventHeroReleaseConfig:GetSummonConfig()
    end
end
function UIHeroSummonTableViewRemake:SetActive(enable)
    self.config.gameObject:SetActive(enable)
end

function UIHeroSummonTableViewRemake:SetMoneyInfo()
    self:SetNumberScroll(MoneyType.SUMMON_BASIC_SCROLL)
    self:SetNumberScroll(MoneyType.SUMMON_HEROIC_SCROLL)
    self:SetNumberScroll(MoneyType.FRIEND_POINT)
    self:SetNumberScroll(MoneyType.SUMMON_ELITE_SCROLL)
end

----- @param moneyType MoneyType
function UIHeroSummonTableViewRemake:SetNumberScroll(moneyType)
    local summonType = self.view.currentSummonType
    if moneyType == MoneyType.SUMMON_ELITE_SCROLL then
        if summonType == SummonType.NewHero then
            UIHeroSummonViewRemake.SetScrollInfo(self.newHeroConfig1.iconScrollNewHero1, self.newHeroConfig1.textNewHeroPrice, summonType, 1)
            UIHeroSummonViewRemake.SetScrollInfo(self.newHeroConfig1.iconScrollNewHero10, self.newHeroConfig1.textNewHeroPrice10, summonType, 10)
        elseif summonType == SummonType.NewHero2 then
            UIHeroSummonViewRemake.SetScrollInfo(self.newHeroConfig2.iconScrollNewHero1, self.newHeroConfig2.textNewHeroPrice, summonType, 1)
            UIHeroSummonViewRemake.SetScrollInfo(self.newHeroConfig2.iconScrollNewHero10, self.newHeroConfig2.textNewHeroPrice10, summonType, 10)
        elseif summonType == SummonType.HeroRelease then
            UIHeroSummonViewRemake.SetScrollInfo(self.heroReleaseConfig.iconScrollNewHero1, self.heroReleaseConfig.textNewHeroPrice, summonType, 1)
            UIHeroSummonViewRemake.SetScrollInfo(self.heroReleaseConfig.iconScrollNewHero10, self.heroReleaseConfig.textNewHeroPrice10, summonType, 10)
        elseif summonType == SummonType.Kazetsu then
            UIHeroSummonViewRemake.SetScrollInfo(self.heroKazetsuConfig.iconScrollNewHero1, self.heroKazetsuConfig.textNewHeroPrice, summonType, 1)
            UIHeroSummonViewRemake.SetScrollInfo(self.heroKazetsuConfig.iconScrollNewHero10, self.heroKazetsuConfig.textNewHeroPrice10, summonType, 10)
        end

    end
    if moneyType == MoneyType.SUMMON_HEROIC_SCROLL then
        if self.view:IsRateUpOpening() then
            UIHeroSummonViewRemake.SetScrollInfo(self.config.iconRateUpScroll, self.config.textRateUpPrice, SummonType.RateUp, 1)
            UIHeroSummonViewRemake.SetScrollInfo(self.config.iconRateUpScroll10, self.config.textRateUpPrice10, SummonType.RateUp, 10)
        end
        UIHeroSummonViewRemake.SetScrollInfo(self.config.iconHeroicScroll1, self.config.textPriceHeroicSummon1, SummonType.Heroic, 1)
        UIHeroSummonViewRemake.SetScrollInfo(self.config.iconHeroicScroll10, self.config.textPriceHeroicSummon10, SummonType.Heroic, 10)
    end
end

function UIHeroSummonTableViewRemake:SetFreeStatusBasic(time, textNotification, isAvailableFree)
    self:SetTextFreeButtonBasic(isAvailableFree)
    self:SetTextFreeCountDown(time, self.config.textBasicTime, textNotification, isAvailableFree)
end

function UIHeroSummonTableViewRemake:SetAdsStatusBasic(enable)
    self:SetAdsButtonBasic(enable)
    self.config.buttonBasicSummon1.gameObject:SetActive(not enable)
end

function UIHeroSummonTableViewRemake:SetFreeStatusHeroic(time, textNotification, isAvailableFree)
    self:SetTextFreeButtonHeroic(isAvailableFree)
    self:SetTextFreeCountDown(time, self.config.textHeroicTime, textNotification, isAvailableFree)
end

function UIHeroSummonTableViewRemake:SetAdsStatusHeroic(enable)
    self:SetAdsButtonHeroic(enable)
    self.config.buttonHeroicSummon1.gameObject:SetActive(not enable)
end

function UIHeroSummonTableViewRemake:UpdateAdsStatusHeroic(stock, numberOfWatch)
    self.config.textHeroicSummonAds.text = string.format("%s %s",
            UIUtils.SetColorString(UIUtils.white, LanguageUtils.LocalizeCommon("free")),
            UIUtils.SetColorString(UIUtils.green_light, string.format("%s/%s", stock - numberOfWatch, stock)))
    UIUtils.SetActiveColorByMaterial(self.config.buttonHeroicSummonAds.gameObject, (stock - numberOfWatch) > 0, "ui_gray_mat")
end

function UIHeroSummonTableViewRemake:SetFreeStatusNewHero(time, textNotification, isAvailableFree)
    self:SetTextFreeButtonNewHero(isAvailableFree)
    self:SetTextFreeCountDown(time, self.newHeroConfig1.textNewHeroTime, textNotification, isAvailableFree)
end

function UIHeroSummonTableViewRemake:SetFreeStatusNewHero2(time, textNotification, isAvailableFree)
    self:SetTextFreeButtonNewHero2(isAvailableFree)
    self:SetTextFreeCountDown(time, self.newHeroConfig2.textNewHeroTime, textNotification, isAvailableFree)
end

function UIHeroSummonTableViewRemake:SetFreeStatusHeroRelease(time, textNotification, summonType, isAvailableFree)
    self:SetTextFreeButtonHeroRelease(isAvailableFree)
    self:SetTextFreeCountDown(time, self.heroReleaseConfig.textNewHeroTime, textNotification, isAvailableFree)
end

function UIHeroSummonTableViewRemake:SetFreeStatusHeroKazetsu(time, textNotification, isAvailableFree)
    self:SetTextFreeButtonHeroKazetsu(isAvailableFree)
    self:SetTextFreeCountDown(time, self.heroKazetsuConfig.textNewHeroTime, textNotification, isAvailableFree)
end

--- @return void
--- @param textTime UnityEngine_UI_Text
function UIHeroSummonTableViewRemake:SetTextFreeCountDown(time, textTime, textNotification, isAvailableFree)
    if isAvailableFree then
        textTime.transform.parent.gameObject:SetActive(false)
        textTime.enabled = false
        textNotification.gameObject:SetActive(true)
    else
        textTime.enabled = true
        textTime.transform.parent.gameObject:SetActive(true)
        textNotification.gameObject:SetActive(false)
        UIUtils.AlignText(textTime)
        textTime.text = string.format(LanguageUtils.LocalizeCommon("free_x"), TimeUtils.SecondsToClock(time))
    end
end

function UIHeroSummonTableViewRemake:SetTextFreeButtonBasic(enable)
    self.config.textBasicSummonFree.gameObject:SetActive(enable)
    self.config.basicScroll:SetActive(not enable)
end

function UIHeroSummonTableViewRemake:SetAdsButtonBasic(enable)
    self.config.buttonBasicSummonAds.gameObject:SetActive(enable)
end

function UIHeroSummonTableViewRemake:SetTextFreeButtonHeroic(enable)
    self.config.textHeroicSummonFree.gameObject:SetActive(enable)
    self.config.heroicScroll:SetActive(not enable)
end

function UIHeroSummonTableViewRemake:SetAdsButtonHeroic(enable)
    self.config.buttonHeroicSummonAds.gameObject:SetActive(enable)
end

function UIHeroSummonTableViewRemake:SetTextFreeButtonNewHero(enable)
    self.newHeroConfig1.textNewHeroFree.gameObject:SetActive(enable)
    self.newHeroConfig1.newHeroScroll:SetActive(not enable)
end

function UIHeroSummonTableViewRemake:SetTextFreeButtonNewHero2(enable)
    self.newHeroConfig2.textNewHeroFree.gameObject:SetActive(enable)
    self.newHeroConfig2.newHeroScroll:SetActive(not enable)
end

function UIHeroSummonTableViewRemake:SetTextFreeButtonHeroRelease(enable)
    self.heroReleaseConfig.textNewHeroFree.gameObject:SetActive(enable)
    self.heroReleaseConfig.newHeroScroll:SetActive(not enable)
end

function UIHeroSummonTableViewRemake:SetTextFreeButtonHeroKazetsu(enable)
    self.heroKazetsuConfig.textNewHeroFree.gameObject:SetActive(enable)
    self.heroKazetsuConfig.newHeroScroll:SetActive(not enable)
end

--- @return void
function UIHeroSummonTableViewRemake:Hide()
    Coroutine.start(function()
        coroutine.waitforseconds(TIME_MOVE_TABLE)
        self.config.gameObject:SetActive(false)
    end)
end
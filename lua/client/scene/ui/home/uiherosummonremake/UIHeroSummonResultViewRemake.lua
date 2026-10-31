--- @class UIHeroSummonResultViewRemake
UIHeroSummonResultViewRemake = Class(UIHeroSummonResultViewRemake)

--- @return void
--- @param uiTransform UnityEngine_RectTransform
function UIHeroSummonResultViewRemake:Ctor(uiTransform, view)
    --- @type UnityEngine_RectTransform
    self.uiTransform = uiTransform
    --- @type Coroutine
    self.showCoroutine = nil
    --- @type UIHeroSummonResultConfig
    self.config = UIBaseConfig(uiTransform)
    --- @type HeroSummonData
    self.csv = ResourceMgr.GetHeroSummonConfig()
    --- @type HeroSummonInBound
    self.server = nil
    --- @type EventRateUp
    self.eventRateUp = nil
    --- @type EventNewHeroSummonConfig
    self.eventNewHeroSummonConfig = nil
    --- @type EventNewHeroSummonConfig
    self.eventNewHeroSummonConfig2 = nil
    --- @type EventNewHeroSummonConfig
    self.eventHeroReleaseSummonConfig = nil
    --- @type EventKazetsuConfig
    self.eventHeroKazetsuSummonConfig = nil

    --- @type UIHeroSummonModelRemake
    self.model = view.model
    --- @type UIHeroSummonViewRemake
    self.view = view
    --- @type HeroResource
    self.pickedHero = nil
    --- @type number
    self.pickedIndex = 0
    --- @type number
    self.previousPickedIndex = 0
    --- @type ItemsTableView
    self.summonTableView = nil
    ---@type boolean
    self.skipAnimation = false

    self:_OnCreate()
end
--- @return void
function UIHeroSummonResultViewRemake:Show()
    local togglePos = self.config.toggle:GetComponent(ComponentName.UnityEngine_RectTransform).localPosition
    self.config.containHeroInfo.localPosition = U_Vector3(0, -229)
    self.config.bgSummonIcon.rectTransform.localPosition = U_Vector3(0, -229)
    self.config.toggle:GetComponent(ComponentName.UnityEngine_RectTransform).localPosition = U_Vector3(-112, -370)
    self.model.enabledSummonResult = true
    self.server = zg.playerData:GetMethod(PlayerDataMethod.SUMMON)
    self:SetEventRateUp()
    self:SetEventNewHeroSummon()
    self:ShowUIProcess()
    self:ShowResult()
    self:HideHeroInfo()
    self:UpdateBtnFreeState()
    self:InitLocalize()
    self:UpdateAdsStatusHeroic(self.csv:GetAdsLimit(SummonType.Heroic), self.server.summonWatchedAdsDict:GetOrDefault(SummonType.Heroic, 0))
    self:InitTickEnableAnimation()
    self.config.gameObject:SetActive(true)
end

function UIHeroSummonResultViewRemake:UpdateAdsStatusHeroic(stock, numberOfWatch)
    self.config.textSummonAds.text = string.format("%s %s",
            UIUtils.SetColorString(UIUtils.white, LanguageUtils.LocalizeCommon("free")),
            UIUtils.SetColorString(UIUtils.green_light, string.format("%s/%s", stock - numberOfWatch, stock)))
    UIUtils.SetActiveColorByMaterial(self.config.buttonSummonAds.gameObject, (stock - numberOfWatch) > 0, "ui_gray_mat")
end

function UIHeroSummonResultViewRemake:OnClickCheckbox()
    self.skipAnimation = not self.skipAnimation
    self:InitTickEnableAnimation()
end

function UIHeroSummonResultViewRemake:InitTickEnableAnimation()
    self.config.iconTick.gameObject:SetActive(self.skipAnimation)
end

function UIHeroSummonResultViewRemake:UpdateBtnFreeState()
    local timeFree = 1
    if self.view:IsFreeSummon(self.view.currentSummonType, 1) then
        timeFree = -1
    end
    self:SetFreeStatusNewHero(timeFree)
end

function UIHeroSummonResultViewRemake:SetFreeStatusNewHero(time)
    self.config.freeSummon.gameObject:SetActive(time < 0)
    self.config.paidSummon.gameObject:SetActive(time >= 0)
end

--- @return void
function UIHeroSummonResultViewRemake:Clear()
    self:HideHeroInfo()
    self.summonTableView:Hide()
    self.view.uiPreviewHeroSummon:ClearObjects()
    self.model.enabledSummonResult = false
end

--- @return void
function UIHeroSummonResultViewRemake:Hide()
    self:Clear()
    self.config.gameObject:SetActive(false)
end

function UIHeroSummonResultViewRemake:SetEventRateUp()
    if self.view:IsRateUpOpening() then
        self.eventRateUp = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_RATE_UP):GetConfig()
    end
end

function UIHeroSummonResultViewRemake:SetEventNewHeroSummon()
    if self.view:IsNewHeroOpening() then
        self.eventNewHeroSummonConfig = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_SUMMON):GetConfig()
    end
    if self.view:IsNewHero2Opening() then
        self.eventNewHeroSummonConfig2 = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_RATE_UP):GetConfig()
    end
    if self.view:IsEventKazetsuOpening() then
        self.eventHeroKazetsuSummonConfig = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU):GetConfig()
    end
    if self.view:IsHeroReleaseOpening() then
        --- @type EventHeroReleaseConfig
        local eventHeroReleaseConfig = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HERO_RELEASE):GetConfig()
        self.eventHeroReleaseSummonConfig = eventHeroReleaseConfig:GetSummonConfig()
    end
end

--- @return void
function UIHeroSummonResultViewRemake:ShowUIProcess()
    --- button
    self:_UpdateButtonInfo()
    self:_ShowButton()
    self:_ShowBgSummonIcon()
end

--- @return void
function UIHeroSummonResultViewRemake:_UpdateButtonInfo()
    --- @type SummonType
    local type = self.view.currentSummonType
    --- @type number
    local quantity = self.view.summonQuantity
    self:_SetButtonState(type)
    self:_UpdatePriceIcon(type)
    self:_UpdatePriceSummonText(type, quantity)
end

--- @return void
--- @param type SummonType
function UIHeroSummonResultViewRemake:_UpdatePriceIcon(type)
    if type == SummonType.Cumulative then

    elseif type == SummonType.Basic then
        UIHeroSummonViewRemake.SetPriceIcon(self.config.iconScroll1, MoneyType.SUMMON_BASIC_SCROLL)
        UIHeroSummonViewRemake.SetPriceIcon(self.config.iconScroll10, MoneyType.SUMMON_BASIC_SCROLL)
    elseif type == SummonType.Heroic then
        UIHeroSummonViewRemake.SetPriceIcon(self.config.iconScroll1, MoneyType.SUMMON_HEROIC_SCROLL)
        UIHeroSummonViewRemake.SetPriceIcon(self.config.iconScroll10, MoneyType.GEM)
    elseif type == SummonType.Friendship then
        UIHeroSummonViewRemake.SetPriceIcon(self.config.iconScroll1, MoneyType.FRIEND_POINT)
        UIHeroSummonViewRemake.SetPriceIcon(self.config.iconScroll10, MoneyType.FRIEND_POINT)
    elseif type == SummonType.RateUp then
        UIHeroSummonViewRemake.SetPriceIcon(self.config.iconScroll1, MoneyType.SUMMON_HEROIC_SCROLL)
        UIHeroSummonViewRemake.SetPriceIcon(self.config.iconScroll10, MoneyType.GEM)
    elseif type == SummonType.NewHero
            or type == SummonType.NewHero2
            or type == SummonType.HeroRelease
            or type == SummonType.Kazetsu then
        UIHeroSummonViewRemake.SetPriceIcon(self.config.iconScroll1, MoneyType.SUMMON_ELITE_SCROLL)
        UIHeroSummonViewRemake.SetPriceIcon(self.config.iconScroll10, MoneyType.GEM)
    end
end

--- @return void
--- @param type SummonType
--- @param quantity number
function UIHeroSummonResultViewRemake:_UpdateQuantitySummonText(type, quantity)
    self.config.freeSummon.text = LanguageUtils.LocalizeCommon("free")
    local textSummon = LanguageUtils.LocalizeCommon("summon")
    local textSummon10 = string.format(LanguageUtils.LocalizeCommon("summon_x"), 10)
    if type == SummonType.Heroic then
        self.config.textSummon1.text = quantity == 10 and textSummon10 or textSummon
        self.config.textSummon10.text = quantity == 10 and textSummon10 or textSummon
    else
        self.config.textSummon1.text = textSummon
        self.config.textSummon10.text = textSummon10
    end
end

--- @return void
--- @param type SummonType
function UIHeroSummonResultViewRemake:_UpdatePriceSummonText(type)
    local price1 = nil
    local price10 = nil
    if type == SummonType.RateUp then
        price1 = self.eventRateUp:GetSummonRateUpPrice(type, 1)
        price10 = self.eventRateUp:GetSummonRateUpPrice(type, 10)
    elseif type == SummonType.NewHero then
        price1 = self.eventNewHeroSummonConfig:GetSummonRateUpPrice(type, 1)
        price10 = self.eventNewHeroSummonConfig:GetSummonRateUpPrice(type, 10)
    elseif type == SummonType.NewHero2 then
        price1 = self.eventNewHeroSummonConfig2:GetSummonRateUpPrice(type, 1)
        price10 = self.eventNewHeroSummonConfig2:GetSummonRateUpPrice(type, 10)
    elseif type == SummonType.HeroRelease then
        price1 = self.eventHeroReleaseSummonConfig:GetSummonRateUpPrice(type, 1)
        price10 = self.eventHeroReleaseSummonConfig:GetSummonRateUpPrice(type, 10)
    elseif type == SummonType.Kazetsu then
        price1 = self.eventHeroKazetsuSummonConfig:GetSummonRateUpPrice(type, 1)
        price10 = self.eventHeroKazetsuSummonConfig:GetSummonRateUpPrice(type, 10)
    else
        price1 = self.csv:GetSummonPrice(type, 1)
        price10 = self.csv:GetSummonPrice(type, 10)
    end
    if type == SummonType.Cumulative then

    elseif type == SummonType.Basic then
        self.config.textPriceSummon1.text = ClientConfigUtils.FormatNumber(price1.summonPrice)
        self.config.textPriceSummon10.text = ClientConfigUtils.FormatNumber(price10.summonPrice)
    elseif type == SummonType.Heroic then
        UIHeroSummonViewRemake.SetScrollInfo(self.config.iconScroll1, self.config.textPriceSummon1, SummonType.Heroic, 1)
        UIHeroSummonViewRemake.SetScrollInfo(self.config.iconScroll10, self.config.textPriceSummon10, SummonType.Heroic, 10)
    elseif type == SummonType.Friendship then
        self.config.textPriceSummon1.text = ClientConfigUtils.FormatNumber(price1.summonPrice)
        self.config.textPriceSummon10.text = ClientConfigUtils.FormatNumber(price10.summonPrice)
    elseif type == SummonType.NewHero or type == SummonType.NewHero2
            or type == SummonType.HeroRelease or type == SummonType.RateUp or type == SummonType.Kazetsu then
        UIHeroSummonViewRemake.SetScrollInfo(self.config.iconScroll1, self.config.textPriceSummon1, type, 1)
        UIHeroSummonViewRemake.SetScrollInfo(self.config.iconScroll10, self.config.textPriceSummon10, type, 10)
    end
end

--- @return void
--- @param type MoneyType
function UIHeroSummonResultViewRemake:_SetButtonState(type)
    self.config.buttonSummon1.gameObject:SetActive(type ~= MoneyType.SUMMON_POINT)
    self.config.buttonSummon10.gameObject:SetActive(type ~= MoneyType.SUMMON_POINT)
end

--- @return void
function UIHeroSummonResultViewRemake:InitButtonListener()
    self.config.buttonOk.onClick:AddListener(function()
        self:OnClickOk()
    end)
    self.config.buttonSummonAds.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self.view:SummonByWatchAds(self.view.currentSummonType, self, self.skipAnimation)
    end)

    local summon = function(number)
        local useGem = false
        local summonType = self.view.currentSummonType
        if summonType == SummonType.Heroic then
            local priceData = self.csv:GetSummonPrice(SummonType.Heroic, number)
            useGem = not InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_HEROIC_SCROLL, priceData.summonPrice)
        elseif summonType == SummonType.RateUp then
            local priceData = self.eventRateUp:GetSummonRateUpPrice(SummonType.RateUp, number)
            useGem = not InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_HEROIC_SCROLL, priceData.summonPrice)
        elseif summonType == SummonType.NewHero then
            local priceData = self.eventNewHeroSummonConfig:GetSummonRateUpPrice(summonType, number)
            useGem = not InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_ELITE_SCROLL, priceData.summonPrice)
        elseif summonType == SummonType.NewHero2 then
            local priceData = self.eventNewHeroSummonConfig2:GetSummonRateUpPrice(summonType, number)
            useGem = not InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_ELITE_SCROLL, priceData.summonPrice)
        elseif summonType == SummonType.HeroRelease then
            local priceData = self.eventHeroReleaseSummonConfig:GetSummonRateUpPrice(summonType, number)
            useGem = not InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_ELITE_SCROLL, priceData.summonPrice)
        elseif summonType == SummonType.Kazetsu then
            local priceData = self.eventHeroKazetsuSummonConfig:GetSummonRateUpPrice(summonType, number)
            useGem = not InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_ELITE_SCROLL, priceData.summonPrice)
        end

        self.view:Summon(self.view.currentSummonType, number, useGem, self, self.skipAnimation)
    end

    self.config.buttonSummon1.onClick:AddListener(function()
        summon(1)
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)

    self.config.buttonSummon10.onClick:AddListener(function()
        summon(10)
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)

    self.config.buttonInfo.onClick:AddListener(function()
        PopupMgr.ShowPopup(UIPopupName.UIHeroSummonInfo, { ["heroResource"] = self.pickedHero })
        zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    end)

    self.config.toggle.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCheckbox()
    end)
end

--- @return void
---@param summonType SummonType
function UIHeroSummonResultViewRemake:_GetMoneyTypeBySummonType(summonType)
    if summonType == SummonType.Basic then
        return MoneyType.SUMMON_BASIC_SCROLL
    elseif summonType == SummonType.Heroic then
        return MoneyType.SUMMON_HEROIC_SCROLL
    elseif summonType == SummonType.Friendship then
        return MoneyType.FRIEND_POINT
    end
end

--- @return void
function UIHeroSummonResultViewRemake:_ShowButton()
    local isNotCumulative = (self.view.currentSummonType ~= SummonType.Cumulative)
    --local currency = InventoryUtils.GetMoney(self:_GetMoneyTypeBySummonType(self.model.summonType))

    self.config.buttonSummonAds.gameObject:SetActive(false)
    self.config.buttonSummon1.gameObject:SetActive(isNotCumulative)
    self.config.buttonSummon10.gameObject:SetActive(isNotCumulative)
    self.config.toggle.gameObject:SetActive(false)

    self.config.buttonOk.transform.localScale = U_Vector3.zero
    if isNotCumulative then
        if self.view.currentSummonType == SummonType.Heroic then
            self.config.buttonSummonAds.gameObject:SetActive(true)
            self.config.toggle.gameObject:SetActive(true)
        else
            self.skipAnimation = false
            self.config.buttonSummonAds.gameObject:SetActive(false)
            self.config.buttonSummon1.gameObject:SetActive(true)
            self.config.toggle.gameObject:SetActive(false)
        end

        self.config.buttonSummon1.transform.localScale = U_Vector3.zero
        self.config.buttonSummon10.transform.localScale = U_Vector3.zero
    end

    Coroutine.start(function()
        coroutine.yield(U_WaitForSeconds(self.model.timeShowButton))
        self.config.buttonOk.transform:DOScale(1, 0.5)
        if self.config.buttonSummon1.gameObject.activeInHierarchy then
            self.config.buttonSummon1.transform:DOScale(1, 0.5)
        end
        if self.config.buttonSummon10.gameObject.activeInHierarchy then
            self.config.buttonSummon10.transform:DOScale(1, 0.5)
        end
    end)
end

--- @return void
function UIHeroSummonResultViewRemake:_ShowHeroInfo()
    self.config.top.transform:DOScale(1, 0.3)
end

--- @return void
function UIHeroSummonResultViewRemake:HideHeroInfo()
    self.config.top.localScale = U_Vector3.zero
end

--- @return void
function UIHeroSummonResultViewRemake:_ShowBgSummonIcon()
    self.config.bgSummonIcon.color = U_Color(1, 1, 1, 0)
    Coroutine.start(function()
        coroutine.waitforseconds(self.model.timeSummon10)
        if self.view.summonQuantity == 10 then
            DOTweenUtils.DOFade(self.config.bgSummonIcon, 1, 1, nil)
        end
    end)
end

--- @return void
function UIHeroSummonResultViewRemake:InitSummonTableView()
    --- @param obj HeroSummonBaseIconView
    local onInitItem = function(obj)
        -- set icon info
        obj:AddListener(function()
            obj:EnableButton(false)

            self.previousPickedIndex = self.pickedIndex
            self.pickedIndex = obj.iconData.index

            self.pickedHero:SetData(nil, obj.heroIconView.iconData.heroId, obj.heroIconView.iconData.star, 0)
            self.view.uiPreviewHeroSummon:PlayChangeHeroEffect()

            self:ShowHero()
            self:SetArrowPosition(obj.config.transform.position.x)

            if self.previousPickedIndex > 0 then
                ---@type HeroIconView
                local iconView = self.summonTableView:Get(self.previousPickedIndex)
                iconView:EnableButton(true)
            end
        end)
    end

    self.summonTableView = ItemsTableView(self.config.containHeroInfo, onInitItem, UIPoolType.HeroSummonBaseIconView)
end

function UIHeroSummonResultViewRemake:InitLocalize()
    self.config.textSummonAds.text = LanguageUtils.LocalizeCommon("watch")
end

--- @return void
--- @param positionX number
function UIHeroSummonResultViewRemake:SetArrowPosition(positionX)
    self.config.arrow:SetActive(false)
    local position = self.config.arrow.transform.position
    self.config.arrow.transform.position = U_Vector3(positionX, position.y, position.z)
end

--- @return void
function UIHeroSummonResultViewRemake:_OnCreate()
    self:InitButtonListener()
    self:InitSummonTableView()
end

--- @return void
function UIHeroSummonResultViewRemake:ShowResult()
    self.config.arrow:SetActive(false)

    --- @type number
    local quantity = self.view.summonQuantity
    if self.model.enabledSummonResult then
        self:Clear()
    end
    self.view.uiPreviewHeroSummon:DespawnEffects()

    Coroutine.start(function()
        while self.view.summonResult == nil do
            coroutine.waitforendofframe()
        end
        coroutine.waitforendofframe()
        local touchObject = TouchUtils.Spawn("UIHeroSummonResultView:ShowResult")
        local delaySummon = 0
        if self.skipAnimation then
            delaySummon = 0
        else
            delaySummon = 0.7
        end
        if quantity == 1 then
            self:Summon1()
            if self.pickedHero.heroStar == 5 then
                zg.audioMgr:PlaySfxUi(SfxUiType.HERO_SUMMON_1_STAR)
            else
                zg.audioMgr:PlaySfxUi(SfxUiType.HERO_SUMMON_1)
            end
            self.view.uiPreviewHeroSummon:PlaySummon("summon_1")
            self.view.uiPreviewHeroSummon:PlaySummonSpawnHero()
            self.view.uiPreviewHeroSummon:PlayFxSummonOne(self.pickedHero)
            coroutine.waitforseconds(delaySummon)
        else
            local delayPlus = 0
            local heroList, pickedHero, pickedIndex = self.view.summonResult:GetSum10()
            self.pickedHero = pickedHero
            self:PreloadPickedHero()
            self.pickedIndex = pickedIndex
            local animBook = "summon_1"
            if self.pickedHero.heroStar == 5 then
                delayPlus = 2.8
                animBook = "summon_10_5stars"
                if not self.skipAnimation then
                    self.view.uiPreviewHeroSummon:PlayFxSummon10(self.pickedHero)
                else
                    self.view.uiPreviewHeroSummon:PlayFxSummonOne(self.pickedHero)
                end
            else
                if not self.skipAnimation then
                    self.view.uiPreviewHeroSummon:PlayFxSummonOne(self.pickedHero)
                else
                    self.view.uiPreviewHeroSummon:PlayFxSummonOne(self.pickedHero)
                end
            end
            if not self.skipAnimation then
                self.view.uiPreviewHeroSummon:PlaySummon(animBook)
            else
                delayPlus = 0
                self.view.uiPreviewHeroSummon:PlaySummon("summon_1")
            end

            if self.pickedHero.heroStar == 5 then
                zg.audioMgr:PlaySfxUi(SfxUiType.HERO_SUMMON_10_STAR)
            else
                zg.audioMgr:PlaySfxUi(SfxUiType.HERO_SUMMON_10)
            end

            coroutine.waitforseconds(delaySummon + delayPlus)
            self:Summon10(heroList)
        end
        self:_ShowHeroInfo()
        self:ShowHero()
        coroutine.waitforseconds(0.5)
        touchObject:Enable()
        self.view:DoTweenBottom(false)
        if self.view.summonResult:HasHero5StarRedBorder() then
            self.view.hasHero5Star = true
        end
    end)
end

--- @return void
function UIHeroSummonResultViewRemake:Summon1()
    self.pickedHero = self.view.summonResult:GetSum1()
    self:PreloadPickedHero()
end

function UIHeroSummonResultViewRemake:PreloadPickedHero()
    local heroPrefabName = string.format("hero_%d_%s", self.pickedHero.heroId, ClientConfigUtils.GetSkinNameByHeroResource(self.pickedHero))
    if SmartPool.Instance:_CheckHasPrefab(AssetType.Hero, heroPrefabName) == false then
        --- @type UnityEngine_GameObject
        local heroObject = SmartPool.Instance:SpawnGameObject(AssetType.Hero, heroPrefabName)
        SmartPool.Instance:DespawnGameObject(AssetType.Hero, heroPrefabName, heroObject.transform)
    end
end

--- @return void
function UIHeroSummonResultViewRemake:Summon10(dataList)
    --- SetData
    self.summonTableView:SetData(dataList)
    local iconView = self.summonTableView:Get(self.pickedIndex)
    if iconView ~= nil then
        iconView:EnableButton(false)
        Coroutine.start(function()
            coroutine.waitforseconds(0.2)
            self:SetArrowPosition(iconView.config.transform.position.x)

        end)
    end
    -- end)
end

function UIHeroSummonResultViewRemake:ShowHero()
    self.view.uiPreviewHeroSummon:ShowHero(self.pickedHero)
    self:SetFactionHeroInfo()
    self:SetStarHeroInfo()
    self:SetNameHeroInfo()
end

--- @return void
function UIHeroSummonResultViewRemake:SetFactionHeroInfo()
    local faction = ClientConfigUtils.GetFactionIdByHeroId(self.pickedHero.heroId)
    self.config.imageHeroFaction.sprite = ResourceLoadUtils.LoadFactionIcon(faction)
end

--- @return void
function UIHeroSummonResultViewRemake:SetStarHeroInfo()
    local sprite = self.config.imageHeroStar.sprite
    local sizeStar1 = sprite.border.x + sprite.border.z
    local sizeStarDelta = sprite.bounds.size.x * 100 - sizeStar1
    self.config.imageHeroStar.rectTransform.sizeDelta = U_Vector2(sizeStar1 + sizeStarDelta * (self.pickedHero.heroStar - 1), sprite.bounds.size.y * 100)
end

--- @return void
function UIHeroSummonResultViewRemake:SetNameHeroInfo()
    self.config.textHeroName.text = LanguageUtils.LocalizeNameHero(self.pickedHero.heroId)
end

function UIHeroSummonResultViewRemake:OnClickOk()
    zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
    self.skipAnimation = false
    self:InitTickEnableAnimation()
    self.view:SetSummonerState(true)
    self.view:DoTweenTabBar(false, self.view.currentSummonType)
    self.view:DoTweenSummonTable(false)
end
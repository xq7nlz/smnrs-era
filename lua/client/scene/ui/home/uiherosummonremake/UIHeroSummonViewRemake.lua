require "lua.client.scene.ui.home.uiHeroSummonRemake.UIHeroSummonTableViewRemake"
require "lua.client.scene.ui.home.uiHeroSummonRemake.UIHeroSummonResultViewRemake"
require "lua.client.scene.ui.home.uiHeroSummonRemake.UIPreviewHeroSummonRemake"
require "lua.client.scene.ui.home.uiHeroSummonRemake.UIHeroMythicalRemake"
require "lua.client.scene.ui.home.uiHeroSummonRemake.UIHeroSummonTabItem"
require "lua.client.core.network.summon.SummonRequest"
require "lua.client.scene.ui.home.uiHeroSummonRemake.UIHeroEventRateUpHelper"

local SceneSummonType = {
    SummonTable = 1,
    ResultTable = 2,
}
--- @class UIHeroSummonViewRemake : UIBaseView
UIHeroSummonViewRemake = Class(UIHeroSummonViewRemake, UIBaseView)

--- @return void
--- @param model UIHeroSummonModelRemake
function UIHeroSummonViewRemake:Ctor(model)
    --- @type UIHeroSummonMainRemakeConfig
    self.config = nil
    --- @type UIHeroSummonTableViewRemake
    self.tableView = nil
    --- @type UIHeroSummonResultViewRemake
    self.resultView = nil
    --- @type UIHeroMythicalRemake
    self.mythicalReward = nil
    --- @type UIPreviewHeroSummonRemake
    self.uiPreviewHeroSummon = nil
    --- @type PreviewHeroMenu
    self.previewHeroMenu = nil
    --- @type ItemsTableView
    self.moneyBarListView = nil
    --- @type HeroSummonData
    self.csv = nil
    ---@type UIHeroEventRateUpHelper
    self.eventRateUpHelper = nil
    --- @type HeroSummonInBound
    self.server = nil
    --- @type SummonResultInBound
    self.summonResult = nil
    --- @type UnityEngine_Vector2
    self.positionDefaultTabBar = nil
    --- @type UnityEngine_Vector2
    self.positionDefaultSummonTable = nil
    --- @type UnityEngine_Vector2
    self.positionDefaultHeroMythical = nil

    self.moneyList = List()

    self.buttonDic = Dictionary()
    self.summonerTableDic = Dictionary()
    ---@type EventRateUpModel
    self.eventRateUpInBound = nil
    ---@type EventKazetsuModel
    self.eventKazetsuModel = nil
    ---@type EventNewHeroSummonModel
    self.eventNewHeroSummonModel = nil
    ---@type EventNewHeroRateUpModel
    self.eventNewHeroSummonModel2 = nil
    ---@type EventHeroReleaseModel
    self.eventHeroReleaseModel = nil
    --- @type Dictionary
    self.imgBookDict = Dictionary()

    --- @type List
    self.listItemPointNewHero = nil
    --- @type List
    self.listItemPointNewHero2 = nil
    --- @type List
    self.listItemPointHeroRelease = nil

    UIBaseView.Ctor(self, model)
    --- @type UIHeroSummonModelRemake
    self.model = model

    self.sceneSummon = nil
    --- @type SummonType
    self.currentSummonType = nil

    --- @type number
    self.summonQuantity = nil
    self.newRateUpSeason = false
    self.newHeroSummonSeason = false
    self.newHeroSummonSeason2 = false
    self.heroReleaseSummonSeason = false
end

--- @return void
function UIHeroSummonViewRemake:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    ---@type UINewHeroSummonMaineConfig
    self.newHeroConfig1 = UIBaseConfig(self.config.newHero)
    ---@type UINewHeroSummonMaineConfig
    self.newHeroConfig2 = UIBaseConfig(self.config.newHero2)
    ---@type UINewHeroSummonMaineConfig
    self.heroReleaseConfig = UIBaseConfig(self.config.heroRelease)
    ---@type UINewHeroSummonMaineConfig
    self.heroKazetsuConfig = UIBaseConfig(self.config.heroKazetsu)

    self.tableView = UIHeroSummonTableViewRemake(self.config.summonerTable, self)
    self.resultView = UIHeroSummonResultViewRemake(self.config.summonerResult, self)
    self.uiPreviewHeroSummon = UIPreviewHeroSummonRemake(self.config.previewHeroSummon)
    self.moneyBarListView = ItemsTableView(self.config.gemRoot)
    self.mythicalReward = UIHeroMythicalRemake(self.config.heroMythicalReward)
    self.eventRateUpHelper = UIHeroEventRateUpHelper(self.config.eventRateUpHelper)

    self:InitButtonListener()
    self:InitUpdateTime()
    self:InitButtonDictionary()
    self:InitSummonerTableDictionary()
    self:InitImageBook()

    self.sceneSummon = SceneSummonType.SummonTable
    self.positionDefaultHeroMythical = self.config.heroMythicalReward.localPosition
    self.positionDefaultTabBar = self.config.tabAnchor.localPosition
    self.positionDefaultSummonTable = self.config.summonerTable.localPosition

    uiCanvas:SetBackgroundSize(self.config.backGround)
end

function UIHeroSummonViewRemake:InitImageBook()
    --- @param summonType SummonType
    local addBook = function(summonType)
        self.imgBookDict:Add(summonType, self.config.bookAnchor:Find(tostring(summonType)))
    end
    addBook(SummonType.Basic)
    addBook(SummonType.Heroic)
    addBook(SummonType.Friendship)
    addBook(SummonType.Cumulative)
    addBook(SummonType.RateUp)
end

function UIHeroSummonViewRemake:InitSummonerTableDictionary()
    self.summonerTableDic:Add(SummonType.Heroic, self.tableView.config.heroicSummoner)
    self.summonerTableDic:Add(SummonType.Basic, self.tableView.config.basicSummoner)
    self.summonerTableDic:Add(SummonType.Friendship, self.tableView.config.friendlySummoner)
    self.summonerTableDic:Add(SummonType.RateUp, self.tableView.config.rateUpSummoner)
    self.summonerTableDic:Add(SummonType.NewHero, self.tableView.config.newHeroSummoner)
    self.summonerTableDic:Add(SummonType.NewHero2, self.tableView.config.newHeroSummoner2)
    self.summonerTableDic:Add(SummonType.HeroRelease, self.tableView.config.heroReleaseSummon)
    self.summonerTableDic:Add(SummonType.Kazetsu, self.tableView.config.heroKazetsuSummon)

end

function UIHeroSummonViewRemake:InitButtonDictionary()
    local callback = function(index)
        self:ShowTableWithIndex(index)
    end
    self.buttonDic:Add(SummonType.Heroic, UIHeroSummonTabItem(self.config.premiumSummonBtn.transform, SummonType.Heroic, callback))
    self.buttonDic:Add(SummonType.Basic, UIHeroSummonTabItem(self.config.basicSummonBtn.transform, SummonType.Basic, callback))
    self.buttonDic:Add(SummonType.Friendship, UIHeroSummonTabItem(self.config.friendShipSummonBtn.transform, SummonType.Friendship, callback))
    self.buttonDic:Add(SummonType.RateUp, UIHeroSummonTabItem(self.config.rateUpBtn.transform, SummonType.RateUp, callback))
    self.buttonDic:Add(SummonType.NewHero, UIHeroSummonTabItem(self.config.newHeroBtn.transform, SummonType.NewHero, callback))
    self.buttonDic:Add(SummonType.NewHero2, UIHeroSummonTabItem(self.config.newHeroBtn2.transform, SummonType.NewHero2, callback))
    self.buttonDic:Add(SummonType.Kazetsu, UIHeroSummonTabItem(self.config.rateUpBtn.transform, SummonType.Kazetsu, callback))
    self.buttonDic:Add(SummonType.HeroRelease, UIHeroSummonTabItem(self.config.heroReleaseBtn.transform, SummonType.HeroRelease, callback))
end

--- @return void
function UIHeroSummonViewRemake:InitButtonListener()
    self.config.buttonTutorial.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)

    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self:InitRateUp()
end

function UIHeroSummonViewRemake:InitRateUp()
    self.config.rateUpHelperButton.onClick:AddListener(function()
        self.eventRateUpHelper:OnClickShow()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end
--- @return nil
--- @param eventConfig EventKazetsuConfig EventKazetsuConfig is an example of event config
function UIHeroSummonViewRemake:SetBanner(eventConfig)
    local event;
    if eventConfig ~= nil then
        event = eventConfig:GetPityConfig()
    else
        ---@type EventRateUp
        event = self.eventRateUpConfig:GetRateUpCumulative()
    end
    local sprite = ResourceLoadUtils.LoadEventRateUpBanner(event.heroId)
    local faction = ClientConfigUtils.GetFactionIdByHeroId(event.heroId)
    if event ~= nil and sprite ~= nil then
        self.config.rateUpBanner.sprite = sprite
        self.config.rateUpGlow.color = UIUtils.glow_color_with_type[faction]
    end
end

--- @return boolean
function UIHeroSummonViewRemake:IsRateUpOpening()
    return self.eventRateUpInBound ~= nil and self.eventRateUpInBound:IsOpening() and UIBaseView.IsActiveTutorial() == false
end

--- @return boolean
function UIHeroSummonViewRemake:IsEventKazetsuOpening()
    return self.eventKazetsuModel ~= nil and self.eventKazetsuModel:IsOpening() and UIBaseView.IsActiveTutorial() == false
end

--- @return boolean
function UIHeroSummonViewRemake:IsNewHeroOpening()
    return self.eventNewHeroSummonModel ~= nil and self.eventNewHeroSummonModel:IsOpening() and UIBaseView.IsActiveTutorial() == false
end

--- @return boolean
function UIHeroSummonViewRemake:IsNewHero2Opening()

    return self.eventNewHeroSummonModel2 ~= nil and self.eventNewHeroSummonModel2:IsOpening() and UIBaseView.IsActiveTutorial() == false
end

--- @return boolean
function UIHeroSummonViewRemake:IsHeroReleaseOpening()
    return self.eventHeroReleaseModel ~= nil and self.eventHeroReleaseModel:IsOpening() and UIBaseView.IsActiveTutorial() == false
end

--- @param data {summonType : SummonType}
function UIHeroSummonViewRemake:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)

    self.eventRateUpInBound = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_RATE_UP)
    self.eventKazetsuModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
    self.eventNewHeroSummonModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_SUMMON)
    self.eventNewHeroSummonModel2 = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_RATE_UP)
    self.eventHeroReleaseModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HERO_RELEASE)

    self.csv = ResourceMgr.GetHeroSummonConfig()
    self.server = zg.playerData:GetMethod(PlayerDataMethod.SUMMON)
    self:ShowDefault()
    self.eventRateUpHelper:OnClickHide()
    self:InitListener()
    self:StartUpdateTime()
    self:SetSummonerState(true)

    if self:IsRateUpOpening() then
        --- @type EventRateUp
        if self.eventRateUpInBound.numberSummon == 0 or self.newRateUpSeason == true then
            self.newRateUpSeason = false
            self.summonEventRateUpResult = nil
            InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_RATE_UP_SUMMON_POINT, InventoryUtils.GetMoney(MoneyType.EVENT_RATE_UP_SUMMON_POINT))
        end
        self.eventRateUpConfig = self.eventRateUpInBound:GetConfig()
        self:SetBanner()
    end
    if self:IsEventKazetsuOpening() then
        --- @type EventKazetsuModel
        if self.eventKazetsuModel.numberSummon == 0 or self.newRateUpSeason == true then
            self.newKazetsuRateUpSeason = false
            self.summonEventKazetsuRateUpResult = nil
            InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_RATE_UP_SUMMON_POINT, InventoryUtils.GetMoney(MoneyType.EVENT_RATE_UP_SUMMON_POINT))
        end
        --- @type EventKazetsuConfig
        self.eventKazetsuConfig = self.eventKazetsuModel:GetConfig()
        self:SetBanner(self.eventKazetsuConfig)
    end
    if self:IsNewHeroOpening() then
        --- @type EventRateUp
        if self.eventNewHeroSummonModel.numberSummon == 0 or self.newHeroSummonSeason == true then
            self.newHeroSummonSeason = false
        end
        ---@type EventNewHeroSummonConfig
        self.eventNewHeroSummonConfig = self.eventNewHeroSummonModel:GetConfig()
    end
    if self:IsNewHero2Opening() then
        --- @type EventRateUp
        if self.eventNewHeroSummonModel2.numberSummon == 0 or self.newHeroSummonSeason2 == true then
            self.newHeroSummonSeason2 = false
        end
        ---@type EventNewHeroSummonConfig
        self.eventNewHeroSummonConfig2 = self.eventNewHeroSummonModel2:GetConfig()
    end
    if self:IsHeroReleaseOpening() then
        --- @type EventRateUp
        if self.eventHeroReleaseModel.numberSummon == 0 or self.heroReleaseSummonSeason == true then
            self.heroReleaseSummonSeason = false
        end
        ---@type EventNewHeroSummonConfig
        self.eventHeroReleaseSummonConfig = self.eventHeroReleaseModel:GetConfig():GetSummonConfig()
    end

    if data ~= nil and data.summonType ~= nil then
        self:OpenTabBySummonType(data.summonType)
    else
        if self:IsRateUpOpening() then
            self:ShowTableWithIndex(SummonType.RateUp)
        elseif self:IsEventKazetsuOpening() then
            self:ShowTableWithIndex(SummonType.Kazetsu)
        elseif self:IsNewHeroOpening() then
            self:ShowTableWithIndex(SummonType.NewHero)
        elseif self:IsNewHero2Opening() then
            self:ShowTableWithIndex(SummonType.NewHero2)
        elseif self:IsHeroReleaseOpening() then
            self:ShowTableWithIndex(SummonType.HeroRelease)
        else
            self:ShowTableWithIndex(SummonType.Heroic)
        end
    end

    self.config.rateUpBtn.gameObject:SetActive(self:IsRateUpOpening())
    self.config.rateUpBtn.gameObject:SetActive(self:IsEventKazetsuOpening())
    self.config.newHeroBtn.gameObject:SetActive(self:IsNewHeroOpening())
    self.config.newHeroBtn2.gameObject:SetActive(self:IsNewHero2Opening())
    self.config.heroReleaseBtn.gameObject:SetActive(self:IsHeroReleaseOpening())

    if self:IsNewHeroOpening() then
        self.config.iconNewHero.sprite = ResourceLoadUtils.LoadTexture("BannerEventNewHeroSummon",
                self.eventNewHeroSummonModel.timeData.dataId, ComponentName.UnityEngine_Sprite)
--[[        self.config.iconTextHeroName.sprite = ResourceLoadUtils.LoadTexture("BannerEventNewHeroSummon",
                "text_" .. self.eventNewHeroSummonModel.timeData.dataId, ComponentName.UnityEngine_Sprite)]]
        self.config.iconNewHero:SetNativeSize()
    end
    if self:IsNewHero2Opening() then
        self.config.iconNewHero2.sprite = ResourceLoadUtils.LoadTexture("BannerEventNewHeroSummon2",
                self.eventNewHeroSummonModel2.timeData.dataId, ComponentName.UnityEngine_Sprite)
        self.config.iconTextHeroName2.sprite = ResourceLoadUtils.LoadTexture("BannerEventNewHeroSummon2",
                "text_" .. self.eventNewHeroSummonModel2.timeData.dataId, ComponentName.UnityEngine_Sprite)
        self.config.iconNewHero2:SetNativeSize()
    end
    if self:IsHeroReleaseOpening() then
        self.config.iconHeroRelease.sprite = ResourceLoadUtils.LoadTexture("BannerEventHeroReleaseSummon",
                self.eventHeroReleaseModel.timeData.dataId, ComponentName.UnityEngine_Sprite)
        --self.config.iconHeroRelease:SetNativeSize()

--[[        self.config.iconTextHeroRelease.sprite = ResourceLoadUtils.LoadTexture("BannerEventHeroReleaseSummon",
                "text_" .. self.eventHeroReleaseModel.timeData.dataId, ComponentName.UnityEngine_Sprite)
        self.config.iconTextHeroRelease:SetNativeSize()]]
    end
end

--- @return void
function UIHeroSummonViewRemake:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self:CheckAndInitTutorial()
end

--- @return void
function UIHeroSummonViewRemake:InitLocalization()
    self.config.premiumTitle.text = LanguageUtils.LocalizeSummonType(SummonType.Heroic)
    self.config.friendshipTitle.text = LanguageUtils.LocalizeSummonType(SummonType.Friendship)
    self.config.basicTitle.text = LanguageUtils.LocalizeSummonType(SummonType.Basic)

    local localizeFree = LanguageUtils.LocalizeCommon("free")
    self.config.localizeFreeBasic.text = localizeFree
    self.config.localizeFreeHeroic.text = localizeFree
    self.config.textFreeSummonHeroRelease.text = localizeFree
    self.config.localizeFreeNewHero.text = localizeFree

    local localizeSummon = LanguageUtils.LocalizeCommon("summon")
    self.config.localizeSummonBasic.text = localizeSummon
    self.config.localizeSummonHeroic.text = localizeSummon
    self.config.localizeSummonFriend.text = localizeSummon
    self.config.localizeResultSummon.text = localizeSummon
    self.config.localizeSummonRateUp.text = localizeSummon
    self.config.textSummon1HeroRelease.text = localizeSummon
    self.config.localizeSummonNewHero.text = localizeSummon
    local localizeSummon10 = string.format(LanguageUtils.LocalizeCommon("summon_x"), 10)
    self.config.localizeSummon10Basic.text = localizeSummon10
    self.config.localizeSummon10Heroic.text = localizeSummon10
    self.config.localizeSummon10Friend.text = localizeSummon10
    self.config.localizeResultSummon10.text = localizeSummon10
    self.config.localizeSummonRateUp10.text = localizeSummon10
    self.config.localizeSummon10RateUp.text = localizeSummon10
    self.config.textSummon10HeroRelease.text = localizeSummon10
    self.config.localizeSummon10NewHero.text = localizeSummon10
    self.config.localizeOk.text = LanguageUtils.LocalizeCommon("ok")

    self.heroReleaseConfig.textSummonReward.text = LanguageUtils.LocalizeCommon("summon_hero_release_reward")
    self.newHeroConfig1.textSummonReward.text = LanguageUtils.LocalizeCommon("summon_hero_release_reward")
    self.heroKazetsuConfig.textSummonReward.text = LanguageUtils.LocalizeCommon("summon_hero_release_reward")

    self.config.rateUpText.text = LanguageUtils.LocalizeCommon("rate_up")
    self.config.textRateUpHeroRelease.text = LanguageUtils.LocalizeCommon("rate_up")
    self.config.rateUpNewHeroText.text = LanguageUtils.LocalizeCommon("rate_up")
    self.config.rateUpNewHeroText2.text = LanguageUtils.LocalizeCommon("rate_up")
end

--- @return void
--- @param isActive boolean
function UIHeroSummonViewRemake:SetSummonerState(isActive)
    if isActive then
        self.tableView:Show()
        self.resultView:Hide()
        self.uiPreviewHeroSummon:SetToDefaultState()
    else
        self.tableView:Hide()
        self.resultView:Show()
    end

    self.config.buttonBack.gameObject:SetActive(isActive)
end

--- @return void
--- @param summonType SummonType
--- @param quantity number
--- @param isUseGem boolean only use when click summon by gem button
--- @param invoker {}
function UIHeroSummonViewRemake:Summon(summonType, quantity, isUseGem, invoker, isSkipAnimation)
    if InventoryUtils.IsValid(ResourceType.Hero, quantity) then
        isUseGem = isUseGem or false
        local priceData = nil
        if summonType == SummonType.RateUp then
            priceData = self.eventRateUpConfig:GetSummonRateUpPrice(summonType, quantity)
        elseif summonType == SummonType.Kazetsu then
            priceData = self.eventKazetsuConfig:GetSummonRateUpPrice(summonType, quantity)
        elseif summonType == SummonType.NewHero then
            priceData = self.eventNewHeroSummonConfig:GetSummonRateUpPrice(summonType, quantity)
        elseif summonType == SummonType.NewHero2 then
            priceData = self.eventNewHeroSummonConfig2:GetSummonRateUpPrice(summonType, quantity)
        elseif summonType == SummonType.HeroRelease then
            priceData = self.eventHeroReleaseSummonConfig:GetSummonRateUpPrice(summonType, quantity)

        else
            priceData = self.csv:GetSummonPrice(summonType, quantity)
        end
        local moneyType = isUseGem and MoneyType.GEM or priceData.moneyType
        local summonPrice = isUseGem and priceData.gemPrice or priceData.summonPrice
        local isFree = self:IsFreeSummon(summonType, quantity)

        local summonFunction = function()
            local summonRequest = function()
                self.uiPreviewHeroSummon:DespawnHero()
                --- sub money for this summon
                --- @param summonResult SummonResultInBound
                local callback = function(summonResult)
                    self.uiPreviewHeroSummon:OnShow()
                    self:HidePreviewHeroMenu()
                    if invoker == self.tableView then
                        self:EnableBottom(false)
                    elseif invoker == self.resultView then
                        self:DoTweenBottom(true)
                    end
                    self.summonResult = summonResult
                    if summonType == SummonType.RateUp then
                        self.summonEventRateUpResult = summonResult
                    elseif summonType == SummonType.Kazetsu then
                        self.eventKazetsuModel.numberSummon = self.eventKazetsuModel.numberSummon + quantity
                        self:UpdateListItemPointHeroKazetsu()
                    elseif summonType == SummonType.NewHero then
                        self.eventNewHeroSummonModel.numberSummon = self.eventNewHeroSummonModel.numberSummon + quantity
                        self:UpdateListItemPointNewHero()
                    elseif summonType == SummonType.NewHero2 then
                        self.eventNewHeroSummonModel2.numberSummon = self.eventNewHeroSummonModel2.numberSummon + quantity
                        self:UpdateListItemPointNewHero2()
                    elseif summonType == SummonType.HeroRelease then
                        self.eventHeroReleaseModel.numberSummon = self.eventHeroReleaseModel.numberSummon + quantity
                        self:UpdateListItemPointHeroRelease()
                    end
                    if isFree then
                        if summonType == SummonType.Basic then
                            self:SetTimeFreeSummon(summonType, zg.timeMgr:GetServerTime())
                        elseif summonType == SummonType.Heroic then
                            self:SetTimeFreeSummon(summonType, zg.timeMgr:GetServerTime())
                        elseif summonType == SummonType.NewHero then
                            self.eventNewHeroSummonModel.lastFreeSummon = zg.timeMgr:GetServerTime()
                        elseif summonType == SummonType.NewHero2 then
                            self.eventNewHeroSummonModel2.lastFreeSummon = zg.timeMgr:GetServerTime()
                        elseif summonType == SummonType.HeroRelease then
                            self.eventHeroReleaseModel.lastFreeSummon = zg.timeMgr:GetServerTime()
                        elseif summonType == SummonType.Kazetsu then
                            self.eventKazetsuModel.lastFreeSummon = zg.timeMgr:GetServerTime()
                        end
                    else
                        InventoryUtils.Sub(ResourceType.Money, moneyType, summonPrice)
                        --- update summon point
                        self:UpdatePointWhenSummon(priceData.point)
                    end
                    --XDebug.Log("Request success")
                    self.currentSummonType = summonType
                    self.summonQuantity = quantity
                    if self.sceneSummon == SceneSummonType.SummonTable then
                        self:DoTweenSummonTable(true)
                        self.sceneSummon = SceneSummonType.ResultTable
                        self:DoTweenTabBar(true, summonType)
                        self:DoTweenHeroMythical(true)
                    else
                        self:SetSummonerState(false)
                        self:CheckTutorialSummon()
                    end
                end
                SummonRequest.Summon(summonType, quantity == 1, isUseGem, callback)
            end

            if isFree or moneyType ~= MoneyType.GEM then
                self.tableView:Hide()
                summonRequest()
            else
                PopupUtils.ShowPopupNotificationUseResource(moneyType, summonPrice, function()
                    self.tableView:Hide()
                    summonRequest()
                end)
                zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            end
        end
        if isFree or InventoryUtils.IsValid(ResourceType.Money, moneyType, summonPrice) then
            summonFunction()
        else
            local canSummon = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, moneyType, summonPrice))
            if canSummon then
                summonFunction()
            end
        end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("noti_full_hero"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

--- @return void
--- @param summonType SummonType
function UIHeroSummonViewRemake:SummonByWatchAds(summonType, invoker)
    local callbackSuccess = function(summonResult)
        self.uiPreviewHeroSummon:OnShow()
        self:HidePreviewHeroMenu()
        if invoker == self.tableView then
            self:EnableBottom(false)
        elseif invoker == self.resultView then
            self:DoTweenBottom(true)
        end
        self.summonResult = summonResult
        --XDebug.Log("Request success")
        self.currentSummonType = summonType
        self.summonQuantity = 1
        local currentSummonAds = self.server.summonWatchedAdsDict:GetOrDefault(summonType, 0)
        self.server.summonWatchedAdsDict:Add(summonType, currentSummonAds + 1)
        if self.sceneSummon == SceneSummonType.SummonTable then
            self:DoTweenSummonTable(true)
            self.sceneSummon = SceneSummonType.ResultTable
            self:DoTweenTabBar(true, summonType)
            self:DoTweenHeroMythical(true)
        else
            self:SetSummonerState(false)
            self:CheckTutorialSummon()
        end
    end

    if self.server.summonWatchedAdsDict:GetOrDefault(summonType, 0) < self.csv:GetAdsLimit(summonType) then
        VideoRewardedUtils.SetType(1)
        VideoRewardedUtils.SetAction(function()
            SummonRequest.SummonByWatchAds(summonType, callbackSuccess)
        end)
        IapDataInBound.Validate(function()
            if VideoRewardedUtils.AllowSkipVideo() then
                TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.MAIN_FEATURES, "watch_video", 0)
                VideoRewardedUtils.RequestToServer()
            else
                VideoRewardedUtils.OpenRewarded(AdsPlacement.PREMIUM_SUMMON)
            end
        end)
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_ads_turn_daily"))
    end
end

--- @return void
--- @param rewardInBound RewardInBound
function UIHeroSummonViewRemake:UpdatePointWhenSummon(rewardInBound)
    if rewardInBound.number ~= nil and rewardInBound.number > 0 then
        --InventoryUtils.Add(ResourceType.Money, MoneyType.SUMMON_POINT, point.number)
        InventoryUtils.Add(rewardInBound.type, rewardInBound.id, rewardInBound.number)
    end
end

--- @return void
function UIHeroSummonViewRemake:InitListener()
    self.listenerChangeResource = RxMgr.changeResource:Subscribe(RxMgr.CreateFunction(self, self.OnSubResource))
end

--- @return void
function UIHeroSummonViewRemake:RemoveListener()
    if self.listenerChangeResource then
        self.listenerChangeResource:Unsubscribe()
        self.listenerChangeResource = nil
    end
end

--- @return void
--- @param data table
---{['resourceType'] = self.type, ['resourceId'] = resourceId, ['quantity'] = quantity, ['result'] = self._resourceDict:Get(resourceId)})
function UIHeroSummonViewRemake:OnSubResource(data)
    local result = data.result
    local type = data.resourceType
    local resourceId = data.resourceId
    if type == ResourceType.Money then
        if resourceId == MoneyType.SUMMON_POINT then
            self:SetSummonPoint(result)
        elseif resourceId == MoneyType.EVENT_RATE_UP_SUMMON_POINT and self.newRateUpSeason == false then
            self:SetEventRateUpPoint(true)
        else
            self.tableView:SetNumberScroll(resourceId)
        end
    end
end

--- @return void
function UIHeroSummonViewRemake:OnClickSummonPoint()
    local levelRequire, stageRequire = ClientConfigUtils.GetLevelStageRequire(MinorFeatureType.SUMMON_ACCUMULATE)
    local vip = ResourceMgr.GetVipConfig():GetCurrentBenefits()
    if vip.summonUnlockAccumulate == true or (levelRequire == nil and stageRequire == nil) then
        local invoker = self.resultView
        if self.model.enabledSummonResult then
            self.resultView:Hide()
            invoker = self.tableView
        end
        self:Summon(SummonType.Cumulative, 1, nil, nil, invoker)
    else
        local vipUnlock = ResourceMgr.GetVipConfig():RequireLevelUnlockSummonAccumulate()
        SmartPoolUtils.NotificationRequireVipOrLevelAndStage(vipUnlock, levelRequire, stageRequire)
    end
end

--- @return void
function UIHeroSummonViewRemake:SetSummonPoint(summonPoint)
    local summonPrice = self.csv:GetSummonPrice(SummonType.Cumulative, 1).summonPrice
    self.config.textSummonPoint.text = string.format("%s/%s", ClientConfigUtils.FormatNumber(summonPoint), summonPrice)
    self.config.imageSummonPoint.fillAmount = summonPoint / summonPrice
    local isFull = self.config.imageSummonPoint.fillAmount >= 1
    self.config.fxUiSummonFullNo:SetActive(isFull)
    self.config.highlight:SetActive(isFull)

    self.config.buttonSummonPoint.enabled = true  -- InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_POINT, summonPrice)

    if summonPoint == 0 then
        self.config.effect.gameObject:SetActive(false)
    else
        self.config.effect.gameObject:SetActive(true)
        self.config.effect.sizeDelta = U_Vector2(self.config.imageSummonPoint.rectTransform.sizeDelta.x * self.config.imageSummonPoint.fillAmount, self.config.effect.sizeDelta.y)
    end
end

--- @return void
function UIHeroSummonViewRemake:OnClickRateUpPoint()
    local summonPrice = self.eventRateUpConfig:GetPityConfig().summonPoint
    local require = summonPrice <= InventoryUtils.GetMoney(MoneyType.EVENT_RATE_UP_SUMMON_POINT)
    if require == true then
        local invoker = self.resultView
        if self.model.enabledSummonResult then
            self.resultView:Hide()
            invoker = self.tableView
        end
        self:Summon(SummonType.RateUp, 1, nil, nil, invoker)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("require_event_rate_up_point"))
    end
end

--- @return void
function UIHeroSummonViewRemake:SetEventRateUpPoint(isSummon)
    local summonPoint = nil
    if self.summonEventRateUpResult ~= nil and self.summonEventRateUpResult.lastEventRateUpPoint ~= nil then
        summonPoint = self.summonEventRateUpResult.lastEventRateUpPoint
    else
        summonPoint = InventoryUtils.GetMoney(MoneyType.EVENT_RATE_UP_SUMMON_POINT)
    end
    if self.eventRateUpConfig == nil then
        self.eventRateUpConfig = self.eventRateUpInBound:GetConfig()
    end
    local summonPrice = self.eventRateUpConfig:GetPityConfig().summonPoint
    self.config.fxUiSummonFullNo:SetActive(false)
    self.config.highlight:SetActive(false)
    if isSummon == true then
        Coroutine.start(function()
            coroutine.waitforseconds(1)
            local timeDelay = 0
            if self.resultView.pickedHero ~= nil and self.resultView.pickedHero.heroStar == 5 then
                timeDelay = 1.5
            end
            coroutine.waitforseconds(0.3 + timeDelay)
            self.config.textSummonPoint.text = string.format("%s/%s", ClientConfigUtils.FormatNumber(summonPoint), summonPrice)
            self.config.imageSummonPoint.fillAmount = summonPoint / summonPrice
            if summonPoint == 0 then
                self.config.effect.gameObject:SetActive(false)
            else
                self.config.effect.gameObject:SetActive(true)
                self.config.effect.sizeDelta = U_Vector2(self.config.imageSummonPoint.rectTransform.sizeDelta.x * self.config.imageSummonPoint.fillAmount, self.config.effect.sizeDelta.y)
            end
        end)
    else
        self.config.textSummonPoint.text = string.format("%s/%s", ClientConfigUtils.FormatNumber(summonPoint), summonPrice)
        self.config.imageSummonPoint.fillAmount = summonPoint / summonPrice
        if summonPoint == 0 then
            self.config.effect.gameObject:SetActive(false)
        else
            self.config.effect.gameObject:SetActive(true)
            self.config.effect.sizeDelta = U_Vector2(self.config.imageSummonPoint.rectTransform.sizeDelta.x * self.config.imageSummonPoint.fillAmount, self.config.effect.sizeDelta.y)
        end
    end
    self.config.buttonSummonPoint.enabled = false  -- InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_POINT, summonPrice)
end

--- @return void
function UIHeroSummonViewRemake:SetEventKazetsuRateUpPoint(isSummon)
    local summonPoint = nil
    if self.summonEventKazetsuRateUpResult ~= nil and self.summonEventKazetsuRateUpResult.lastEventRateUpPoint ~= nil then
        summonPoint = self.summonEventKazetsuRateUpResult.lastEventRateUpPoint
    else
        summonPoint = InventoryUtils.GetMoney(MoneyType.EVENT_RATE_UP_SUMMON_POINT)
    end
    if self.eventRateUpConfig == nil then
        self.eventRateUpConfig = self.eventKazetsuModel:GetConfig()
    end
    local summonPrice = self.eventRateUpConfig:GetPityConfig().summonPoint
    self.config.fxUiSummonFullNo:SetActive(false)
    self.config.highlight:SetActive(false)
    if isSummon == true then
        Coroutine.start(function()
            coroutine.waitforseconds(1)
            local timeDelay = 0
            if self.resultView.pickedHero ~= nil and self.resultView.pickedHero.heroStar == 5 then
                timeDelay = 1.5
            end
            coroutine.waitforseconds(0.3 + timeDelay)
            self.config.textSummonPoint.text = string.format("%s/%s", ClientConfigUtils.FormatNumber(summonPoint), summonPrice)
            self.config.imageSummonPoint.fillAmount = summonPoint / summonPrice
            if summonPoint == 0 then
                self.config.effect.gameObject:SetActive(false)
            else
                self.config.effect.gameObject:SetActive(true)
                self.config.effect.sizeDelta = U_Vector2(self.config.imageSummonPoint.rectTransform.sizeDelta.x * self.config.imageSummonPoint.fillAmount, self.config.effect.sizeDelta.y)
            end
        end)
    else
        self.config.textSummonPoint.text = string.format("%s/%s", ClientConfigUtils.FormatNumber(summonPoint), summonPrice)
        self.config.imageSummonPoint.fillAmount = summonPoint / summonPrice
        if summonPoint == 0 then
            self.config.effect.gameObject:SetActive(false)
        else
            self.config.effect.gameObject:SetActive(true)
            self.config.effect.sizeDelta = U_Vector2(self.config.imageSummonPoint.rectTransform.sizeDelta.x * self.config.imageSummonPoint.fillAmount, self.config.effect.sizeDelta.y)
        end
    end
    self.config.buttonSummonPoint.enabled = false  -- InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_POINT, summonPrice)
end

function UIHeroSummonViewRemake:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateEventRateUpTime = function(isSetTime)
        if self.eventRateUpInBound ~= nil then
            if isSetTime == true then
                local eventTime = self.eventRateUpInBound:GetTime()
                self.timeRateUp = eventTime.endTime - zg.timeMgr:GetServerTime()
            else
                self.timeRateUp = self.timeRateUp - 1
            end
            local isRateUpOpening = self.timeRateUp > 0
            self.config.eventRateupTime.gameObject:SetActive(isRateUpOpening)
            self.config.eventRateupTime.enabled = isRateUpOpening
            if isRateUpOpening then
                UIUtils.AlignText(self.config.eventRateupTime)
                self.config.eventRateupTime.text = string.format("%s %s",
                        LanguageUtils.LocalizeCommon("will_end_in"),
                        UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRateUp)))
            else
                self.config.rateUpBtn.gameObject:SetActive(false)
                self.newRateUpSeason = true
                self.summonEventRateUpResult = nil
                self:RemoveUpdateTime(self.updateEventRateUpTime)
                if self.currentSummonType == SummonType.RateUp then
                    if self.sceneSummon == SceneSummonType.SummonTable then
                        self:ShowDefault()
                    else
                        self:SetSummonerState(true)
                        self:DoTweenTabBar(false, SummonType.Heroic)
                        self:DoTweenSummonTable(false)
                    end
                    self.eventRateUpHelper:OnClickHide()
                    self:ShowTableWithIndex(SummonType.Heroic)
                end
            end
        end
    end

    --- @param isSetTime boolean
    self.updateEventKazetsuRateUpTime = function(isSetTime)
        if self.eventKazetsuModel ~= nil then
            if isSetTime == true then
                local eventTime = self.eventKazetsuModel:GetTime()
                self.timeKazetsuRateUp = eventTime.endTime - zg.timeMgr:GetServerTime()
            else
                self.timeKazetsuRateUp = self.timeKazetsuRateUp - 1
            end
            local isRateUpOpening = self.timeKazetsuRateUp > 0
            self.config.eventRateupTime.gameObject:SetActive(isRateUpOpening)
            self.config.eventRateupTime.enabled = isRateUpOpening
            if isRateUpOpening then
                UIUtils.AlignText(self.config.eventRateupTime)
                self.config.eventRateupTime.text = string.format("%s %s",
                        LanguageUtils.LocalizeCommon("will_end_in"),
                        UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeKazetsuRateUp)))
            else
                self.config.newHeroBtn.gameObject:SetActive(false)
                self.newKazetsuRateUpSeason = true
                self.summonEventKazetsuRateUpResult = nil
                self:RemoveUpdateTime(self.updateEventKazetsuRateUpTime)
                if self.currentSummonType == SummonType.Kazetsu then
                    if self.sceneSummon == SceneSummonType.SummonTable then
                        self:ShowDefault()
                    else
                        self:SetSummonerState(true)
                        self:DoTweenTabBar(false, SummonType.Heroic)
                        self:DoTweenSummonTable(false)
                    end
                    self.eventRateUpHelper:OnClickHide()
                    self:ShowTableWithIndex(SummonType.Heroic)
                end
            end
        end
    end

    --- @param isSetTime boolean
    self.updateEventNewHeroTime = function(isSetTime)
        if self.eventNewHeroSummonModel ~= nil then
            if isSetTime == true then
                local eventTime = self.eventNewHeroSummonModel:GetTime()
                self.timeNewHeroSummon = eventTime.endTime - zg.timeMgr:GetServerTime()
            else
                self.timeNewHeroSummon = self.timeNewHeroSummon - 1
            end
            local isEventOpening = self.timeNewHeroSummon > 0
            self.config.eventNewHeroTime.gameObject:SetActive(isEventOpening)
            self.config.eventNewHeroTime.enabled = isEventOpening
            if isEventOpening then
                UIUtils.AlignText(self.config.eventNewHeroTime)
                self.config.eventNewHeroTime.text = string.format("%s %s",
                        LanguageUtils.LocalizeCommon("will_end_in"),
                        UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeNewHeroSummon)))
            else
                self.config.newHeroBtn.gameObject:SetActive(false)
                self.newHeroSummonSeason = true
                self:RemoveUpdateTime(self.updateEventNewHeroTime)
                if self.currentSummonType == SummonType.NewHero then
                    if self.sceneSummon == SceneSummonType.SummonTable then
                        self:ShowDefault()
                    else
                        self:SetSummonerState(true)
                        self:DoTweenTabBar(false, SummonType.Heroic)
                        self:DoTweenSummonTable(false)
                    end
                    self:ShowTableWithIndex(SummonType.Heroic)
                end
            end
        end
    end

    --- @param isSetTime boolean
    self.updateEventNewHeroTime2 = function(isSetTime)
        if self.eventNewHeroSummonModel2 ~= nil then
            if isSetTime == true then
                local eventTime = self.eventNewHeroSummonModel2:GetTime()
                self.timeNewHeroSummon2 = eventTime.endTime - zg.timeMgr:GetServerTime()
            else
                self.timeNewHeroSummon2 = self.timeNewHeroSummon2 - 1
            end
            local isEventOpening = self.timeNewHeroSummon2 > 0
            self.config.eventNewHeroTime2.gameObject:SetActive(isEventOpening)
            self.config.eventNewHeroTime2.enabled = isEventOpening
            if isEventOpening then
                UIUtils.AlignText(self.config.eventNewHeroTime2)
                self.config.eventNewHeroTime2.text = string.format("%s %s",
                        LanguageUtils.LocalizeCommon("will_end_in"),
                        UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeNewHeroSummon2)))
            else
                self.config.newHeroBtn2.gameObject:SetActive(false)
                self.newHeroSummonSeason2 = true
                self:RemoveUpdateTime(self.updateEventNewHeroTime2)
                if self.currentSummonType == SummonType.NewHero2 then
                    if self.sceneSummon == SceneSummonType.SummonTable then
                        self:ShowDefault()
                    else
                        self:SetSummonerState(true)
                        self:DoTweenTabBar(false, SummonType.Heroic)
                        self:DoTweenSummonTable(false)
                    end
                    self:ShowTableWithIndex(SummonType.Heroic)
                end
            end
        end
    end

    --- @param isSetTime boolean
    self.updateEventHeroReleaseTime = function(isSetTime)
        if self.eventHeroReleaseModel ~= nil then
            if isSetTime == true then
                local eventTime = self.eventHeroReleaseModel:GetTime()
                self.timeHeroReleaseSummon = eventTime.endTime - zg.timeMgr:GetServerTime()
            else
                self.timeHeroReleaseSummon = self.timeHeroReleaseSummon - 1
            end
            local isEventOpening = self.timeHeroReleaseSummon > 0
            self.config.eventHeroReleaseTime.gameObject:SetActive(isEventOpening)
            self.config.eventHeroReleaseTime.enabled = isEventOpening
            if isEventOpening then
                UIUtils.AlignText(self.config.eventHeroReleaseTime)
                self.config.eventHeroReleaseTime.text = string.format("%s %s",
                        LanguageUtils.LocalizeCommon("will_end_in"),
                        UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeHeroReleaseSummon)))
            else
                self.config.heroReleaseBtn.gameObject:SetActive(false)
                self.heroReleaseSummonSeason = true

                self:RemoveUpdateTime(self.updateEventHeroReleaseTime)
                if self.currentSummonType == SummonType.HeroRelease then
                    if self.sceneSummon == SceneSummonType.SummonTable then
                        self:ShowDefault()
                    else
                        self:SetSummonerState(true)
                        self:DoTweenTabBar(false, SummonType.Heroic)
                        self:DoTweenSummonTable(false)
                    end
                    self:ShowTableWithIndex(SummonType.Heroic)
                end
            end
        end
    end

    --- @param isSetTime boolean
    self.updateTimeBasic = function(isSetTime)
        if isSetTime == true then
            self.timeFreeBasic = self.server:GetTimeFreeSummon()
        else
            self.timeFreeBasic = self.timeFreeBasic - 1
        end
        local isAvailableFree = self.server:IsAvailableFreeSummon(SummonType.Basic)
        self.tableView:SetFreeStatusBasic(self.timeFreeBasic, self.config.basicNoti, isAvailableFree)
        if self.timeFreeBasic <= 0 then
            self:RemoveUpdateTime(self.updateTimeBasic)
        end
    end
    --- @param isSetTime boolean
    self.updateTimeHeroic = function(isSetTime)
        if isSetTime == true then
            self.timeFreeHeroic = self.server:GetTimeFreeSummon()
        else
            self.timeFreeHeroic = self.timeFreeHeroic - 1
        end
        local isAvailableFree = self.server:IsAvailableFreeSummon(SummonType.Heroic)
        self.tableView:SetFreeStatusHeroic(self.timeFreeHeroic, self.config.premiumNoti, isAvailableFree)
        --self.tableView:SetAdsStatusHeroic(not self.server:IsAvailableFreeSummon(SummonType.Heroic) and self.server:IsAvailableAdsSummon(SummonType.Heroic))
        self.tableView:UpdateAdsStatusHeroic(self.csv:GetAdsLimit(SummonType.Heroic), self.server.summonWatchedAdsDict:GetOrDefault(SummonType.Heroic, 0))
        if self.timeFreeHeroic <= 0 then
            self:RemoveUpdateTime(self.updateTimeHeroic)
        end
    end

    --- @param isSetTime boolean
    self.updateEventNewHeroRegen = function(isSetTime)
        if isSetTime == true then
            self.timeFreeNewHeroSummon = self.eventNewHeroSummonModel:GetTimeFreeSummon()
        else
            self.timeFreeNewHeroSummon = self.timeFreeNewHeroSummon - 1
        end
        local isAvailableFree = self.eventNewHeroSummonModel:IsAvailableFreeSummon()
        self.tableView:SetFreeStatusNewHero(self.timeFreeNewHeroSummon, self.config.newHeroNoti, isAvailableFree)
    end

    --- @param isSetTime boolean
    self.updateEventNewHeroRegen2 = function(isSetTime)
        if isSetTime == true then
            self.timeFreeNewHeroSummon2 = self.eventNewHeroSummonModel2:GetTimeFreeSummon()
        else
            self.timeFreeNewHeroSummon2 = self.timeFreeNewHeroSummon2 - 1
        end
        local isAvailableFree = self.eventNewHeroSummonModel2:IsAvailableFreeSummon()
        self.tableView:SetFreeStatusNewHero2(self.timeFreeNewHeroSummon2, self.config.newHeroNoti2, isAvailableFree)
    end

    --- @param isSetTime boolean
    self.updateEventHeroReleaseRegen = function(isSetTime)
        if isSetTime == true then
            self.timeFreeHeroReleaseSummon = self.eventHeroReleaseModel:GetTimeFreeSummon()
        else
            self.timeFreeHeroReleaseSummon = self.timeFreeHeroReleaseSummon - 1
        end
        local isAvailableFree = self.eventHeroReleaseModel:IsAvailableFreeSummon()
        self.tableView:SetFreeStatusHeroRelease(self.timeFreeHeroReleaseSummon, self.config.notifyHeroRelease, SummonType.HeroRelease, isAvailableFree)
    end

    --- @param isSetTime boolean
    self.updateEventKazetsuReleaseRegen = function(isSetTime)
        if isSetTime == true then
            self.timeFreeHeroKazetsuReleaseSummon = self.eventKazetsuModel:GetTimeFreeSummon()
        else
            self.timeFreeHeroKazetsuReleaseSummon = self.timeFreeHeroKazetsuReleaseSummon - 1
        end
        local isAvailableFree = self.eventKazetsuModel:IsAvailableFreeSummon()
        self.tableView:SetFreeStatusHeroKazetsu(self.timeFreeHeroKazetsuReleaseSummon, self.config.notifyHeroRelease, SummonType.Kazetsu, isAvailableFree)
    end
end

function UIHeroSummonViewRemake:RemoveUpdateTime(updateTime)
    if updateTime then
        zg.timeMgr:RemoveUpdateFunction(updateTime)
    end
end

--- @return void
function UIHeroSummonViewRemake:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTimeBasic)
    zg.timeMgr:AddUpdateFunction(self.updateTimeHeroic)
    if self:IsRateUpOpening() then
        zg.timeMgr:AddUpdateFunction(self.updateEventRateUpTime)
    end
    if self:IsEventKazetsuOpening() then
        zg.timeMgr:AddUpdateFunction(self.updateEventKazetsuRateUpTime)
        zg.timeMgr:AddUpdateFunction(self.updateEventKazetsuReleaseRegen)
    end
    if self:IsNewHeroOpening() then
        zg.timeMgr:AddUpdateFunction(self.updateEventNewHeroTime)
        zg.timeMgr:AddUpdateFunction(self.updateEventNewHeroRegen)
    end
    if self:IsNewHero2Opening() then
        zg.timeMgr:AddUpdateFunction(self.updateEventNewHeroTime2)
        zg.timeMgr:AddUpdateFunction(self.updateEventNewHeroRegen2)
    end
    if self:IsHeroReleaseOpening() then
        zg.timeMgr:AddUpdateFunction(self.updateEventHeroReleaseTime)
        zg.timeMgr:AddUpdateFunction(self.updateEventHeroReleaseRegen)
    end
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIHeroSummonViewRemake:ShowTutorial(tutorial, step)
    --XDebug.Log(step)
    if step == TutorialStep.BASIC_SUMMON_INFO then
        tutorial:ViewFocusCurrentTutorial(self.config.basicSummonBtn,U_Vector2(600, 240), self.config.basicSummonBtn.transform:GetChild(0))
    elseif step == TutorialStep.HEROIC_SUMMON_INFO then
        tutorial:ViewFocusCurrentTutorial(self.config.premiumSummonBtn, U_Vector2(600, 300), self.config.premiumSummonBtn.transform:GetChild(0))
    elseif step == TutorialStep.FRIEND_SUMMON_INFO then
        tutorial:ViewFocusCurrentTutorial(self.config.friendShipSummonBtn, U_Vector2(600, 240), self.config.friendShipSummonBtn.transform:GetChild(0))
    elseif step == TutorialStep.CLICK_SUMMON_BASIC then
        tutorial:ViewFocusCurrentTutorial(self.config.basicSummonBtn, U_Vector2(480, 180), self.config.basicSummonBtn.transform:GetChild(0), nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.CLICK_SUMMON_HEROIC then
        tutorial:ViewFocusCurrentTutorial(self.config.premiumSummonBtn, U_Vector2(700, 290), self.config.premiumSummonBtn.transform:GetChild(0), nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.FREE_BASIC_SUMMON_CLICK then
        tutorial:ViewFocusCurrentTutorial(self.tableView.config.buttonBasicSummon1, U_Vector2(500, 180), nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.FREE_HEROIC_SUMMON_CLICK then
        self:ShowTableWithIndex(SummonType.Heroic)
        tutorial:ViewFocusCurrentTutorial(self.tableView.config.buttonHeroicSummon1, U_Vector2(500, 180), self.tableView.config.buttonHeroicSummon1.transform, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.BACK_SUMMON_CLICK then
        tutorial:ViewFocusCurrentTutorial(self.config.buttonBack, 0.6,
                self.config.buttonBack.transform:GetChild(0), nil, TutorialHandType.MOVE_CLICK)
    elseif step == TutorialStep.PLEASE_CLICK_SUMMON_HEROIC then
        tutorial:ViewFocusCurrentTutorial(self.config.premiumSummonBtn, U_Vector2(550, 250), self.config.premiumSummonBtn.transform:GetChild(0), nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.BACK_SUMMON_RESULT_CLICK then
        tutorial:ViewFocusCurrentTutorial(self.resultView.config.buttonOk, 0.5, self.resultView.config.buttonOk.transform:GetChild(0), nil, tutorial:GetHandType(TutorialHandType.MOVE_CLICK))
    elseif step == TutorialStep.TEN_HEROIC_SUMMON_CLICK then
        self:ShowTableWithIndex(SummonType.Heroic)
        tutorial:ViewFocusCurrentTutorial(self.tableView.config.buttonHeroicSummon10, U_Vector2(400, 180), self.tableView.config.buttonHeroicSummon10.transform, nil, TutorialHandType.CLICK)
    end
end

function UIHeroSummonViewRemake:OnClickHelpInfo()
    ---@type RateSummonConfig
    local rateSummon = ResourceMgr.GetRateSummonConfig()
    local info = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeHelpInfo("summon_circle_info"),
            rateSummon.basicSummon:GetRateStringByStar(1) .. "%%",
            rateSummon.basicSummon:GetRateStringByStar(2) .. "%%",
            rateSummon.basicSummon:GetRateStringByStar(3) .. "%%",
            rateSummon.basicSummon:GetRateStringByStar(4) .. "%%",
            rateSummon.basicSummon:GetRateStringByStar(5) .. "%%",
            rateSummon.heroicSummon:GetRateStringByStar(3) .. "%%",
            rateSummon.heroicSummon:GetRateStringByStar(4) .. "%%",
            rateSummon.heroicSummon:GetRateStringByStar(5) .. "%%",
            rateSummon.friendSummon:GetRateStringByStar(2) .. "%%",
            rateSummon.friendSummon:GetRateStringByStar(3) .. "%%",
            rateSummon.friendSummon:GetRateStringByStar(4) .. "%%",
            rateSummon.friendSummon:GetRateStringByStar(5) .. "%%"
    )
    --info = string.gsub(info, "{1}", tostring(
    --        MathUtils.Round(self.csv:GetSummonPrice(SummonType.Heroic, 1).point)))
    --info = string.gsub(info, "{2}", tostring(
    --        MathUtils.Round(self.csv:GetSummonPrice(SummonType.Cumulative, 1).summonPrice)))
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

--- @return void
function UIHeroSummonViewRemake:CheckTutorialSummon()
    if UIBaseView.IsActiveTutorial() then
        Coroutine.start(function()
            coroutine.waitforendofframe()
            coroutine.waitforendofframe()
            if UIBaseView.tutorial.isWaitingFocusPosition == true then
                local step = UIBaseView.tutorial.currentTutorial.tutorialStepData.step
                local tutorial = UIBaseView.tutorial
                if step == TutorialStep.BACK_SUMMON_RESULT_CLICK then
                    tutorial:ViewFocusCurrentTutorial(self.resultView.config.buttonOk, 0.5, self.resultView.config.buttonOk.transform:GetChild(0), nil,
                            tutorial:GetHandType(TutorialHandType.MOVE_CLICK))
                elseif step == TutorialStep.INTRODUCE_HERO_SUMMONED then
                    tutorial:ViewFocusCurrentTutorial(nil, 3.5, self.uiPreviewHeroSummon.config.bookAnchor.transform.position, nil)
                end
            end
        end)
    end
end

--- @return boolean
--- @param summonType SummonType
--- @param quantity number
function UIHeroSummonViewRemake:IsFreeSummon(summonType, quantity)
    if quantity == 1 then
        if summonType == SummonType.Basic and self.server:IsAvailableFreeSummon(summonType) then
            return true
        end
        if summonType == SummonType.Heroic and self.server:IsAvailableFreeSummon(summonType) then
            return true
        end
        if summonType == SummonType.NewHero and self.eventNewHeroSummonModel:IsAvailableFreeSummon() then
            return true
        end
        if summonType == SummonType.NewHero2 and self.eventNewHeroSummonModel2:IsAvailableFreeSummon()  then
            return true
        end
        if summonType == SummonType.HeroRelease and self.eventHeroReleaseModel:IsAvailableFreeSummon() then
            return true
        end
        if summonType == SummonType.Kazetsu and self.eventKazetsuModel:IsAvailableFreeSummon() then
            return true
        end
    end
    return false
end

--- @return void
--- @param summonType SummonType
--- @param time number
function UIHeroSummonViewRemake:SetTimeFreeSummon(summonType, time)
    self.server:SetTimeFreeSummon(summonType, time)
end

function UIHeroSummonViewRemake:OnReadyHide()
    if self.callbackClose ~= nil then
        self.callbackClose()
        self.callbackClose = nil
    else
        PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
        if self.hasHero5Star == true then
            require("lua.client.scene.ui.rate.UserRate")
            UserRate.CheckRate()
        end
        self.hasHero5Star = false
    end
end

function UIHeroSummonViewRemake:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

--- @return void
function UIHeroSummonViewRemake:Hide()
    UIBaseView.Hide(self)
    zg.timeMgr:RemoveUpdateFunction(self.updateTimeBasic)
    zg.timeMgr:RemoveUpdateFunction(self.updateTimeHeroic)
    zg.timeMgr:RemoveUpdateFunction(self.updateEventRateUpTime)
    zg.timeMgr:RemoveUpdateFunction(self.updateEventNewHeroRegen)
    zg.timeMgr:RemoveUpdateFunction(self.updateEventNewHeroTime)
    zg.timeMgr:RemoveUpdateFunction(self.updateEventNewHeroRegen2)
    zg.timeMgr:RemoveUpdateFunction(self.updateEventNewHeroTime2)
    zg.timeMgr:RemoveUpdateFunction(self.updateEventHeroReleaseRegen)
    zg.timeMgr:RemoveUpdateFunction(self.updateEventHeroReleaseTime)
    self.uiPreviewHeroSummon:OnHide()
    self.currentSummonType = nil

    self:HidePreviewHeroMenu()

    self.moneyBarListView:Hide()
    self:RemoveListener()
    self:RemoveListenerTutorial()
end

--- @return void
--- @param image UnityEngine_UI_Image
--- @param type MoneyType
function UIHeroSummonViewRemake.SetPriceIcon(image, type)
    image.sprite = ResourceLoadUtils.LoadMoneyIcon(type)
    image:SetNativeSize()
end

--- @param summonType SummonType
function UIHeroSummonViewRemake:SetBackground(summonType)
    self:EnableBgNewHero(false)
    self:HidePreviewHeroMenu()

    if summonType == SummonType.RateUp then
        self:ValidatePreviewHeroMenu()
        local rateSummon = self.eventRateUpConfig:GetRateUpCumulative()
        local pityConfig = self.eventRateUpConfig:GetPityConfig()
        self.heroResource = HeroResource.CreateInstance(nil, rateSummon.heroId, 5)
        if pityConfig.pity_enable == true then
            self.previewHeroMenu:PreviewHero(self.heroResource)
            local factionId = ClientConfigUtils.GetFactionIdByHeroId(self.heroResource.heroId)
            self.previewHeroMenu:UpdateFactionBackground(factionId, PreviewHeroBgAnchorType.HeroSummon)
        end
        self.config.bookCircle:SetActive(false)
        self.config.backGround.gameObject:SetActive(false)
    elseif summonType == SummonType.Kazetsu then
        self:ValidatePreviewHeroMenu()
        local pityConfig = self.eventKazetsuConfig:GetPityConfig()
        self.heroResource = HeroResource.CreateInstance(nil, pityConfig.heroId, 5)
        if pityConfig.pityEnable == true then
            self.previewHeroMenu:PreviewHero(self.heroResource)
            local factionId = ClientConfigUtils.GetFactionIdByHeroId(self.heroResource.heroId)
            self.previewHeroMenu:UpdateFactionBackground(factionId, PreviewHeroBgAnchorType.HeroSummon)
        end
        self.config.bookCircle:SetActive(false)
        self.config.backGround.gameObject:SetActive(false)
        self:EnableBgNewHero(true, summonType)
    elseif summonType == SummonType.NewHero
            or summonType == SummonType.NewHero2
            or summonType == SummonType.HeroRelease then
        self.config.bookCircle:SetActive(false)
        self:EnableBgNewHero(true, summonType)
    else
        self.config.bookCircle:SetActive(true)
        self.config.backGround.gameObject:SetActive(true)
    end
    self.uiPreviewHeroSummon:OnHide()
end
--- @return void
--- @param image UnityEngine_UI_Image
--- @param text TMPro_TextMeshProUGUI
--- @param summonType SummonType
--- @param quantity number
function UIHeroSummonViewRemake.SetScrollInfo(image, text, summonType, quantity)
    local priceData = nil
    if summonType == SummonType.RateUp then
        --- @type EventRateUp
        local eventRateUpConfig = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_RATE_UP):GetConfig()
        priceData = eventRateUpConfig:GetSummonRateUpPrice(summonType, quantity)
    elseif summonType == SummonType.Kazetsu then
        --- @type EventKazetsuConfig
        local eventConfig = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU):GetConfig()
        priceData = eventConfig:GetSummonRateUpPrice(summonType, quantity)
    elseif summonType == SummonType.NewHero then
        --- @type EventNewHeroSummonConfig
        local eventConfig = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_SUMMON):GetConfig()
        priceData = eventConfig:GetSummonRateUpPrice(summonType, quantity)
    elseif summonType == SummonType.NewHero2 then
        --- @type EventNewHeroSummonConfig
        local eventConfig = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_RATE_UP):GetConfig()
        priceData = eventConfig:GetSummonRateUpPrice(summonType, quantity)
    elseif summonType == SummonType.HeroRelease then
        --- @type EventHeroReleaseConfig
        local eventConfig = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HERO_RELEASE):GetConfig()
        --- @type EventNewHeroSummonConfig
        local eventNewHeroSummonConfig = eventConfig:GetSummonConfig()
        priceData = eventNewHeroSummonConfig:GetSummonRateUpPrice(summonType, quantity)
    else
        priceData = ResourceMgr.GetHeroSummonConfig():GetSummonPrice(summonType, quantity)
    end
    if ((summonType == SummonType.Heroic or summonType == SummonType.RateUp)
            and (not InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_HEROIC_SCROLL, priceData.summonPrice)))
            or
            ((summonType == SummonType.NewHero or summonType == SummonType.NewHero2 or summonType == SummonType.HeroRelease or summonType == SummonType.Kazetsu)
                    and (not InventoryUtils.IsValid(ResourceType.Money, MoneyType.SUMMON_ELITE_SCROLL, priceData.summonPrice))) then
        image.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.GEM)
        text.text = ClientConfigUtils.FormatNumber(priceData.gemPrice)
    else
        image.sprite = ResourceLoadUtils.LoadMoneyIcon(priceData.moneyType)
        text.text = ClientConfigUtils.FormatNumber(priceData.summonPrice)
    end
    image:SetNativeSize()
end

--- @param isHide boolean
function UIHeroSummonViewRemake:DoTweenBottom(isHide)
    if isHide == true then
        if self.currentSummonType == SummonType.Heroic then
            self.config.bottomRect.anchoredPosition3D = U_Vector3(320, 77, 0)
        else
            self.config.bottomRect.anchoredPosition3D = U_Vector3(0, 77, 0)
        end
        self.config.bottomRect.gameObject:SetActive(true)
        self.config.bgBack.gameObject:SetActive((false))
        DOTweenUtils.DoAnchorPosY(self.config.bottomRect, -100, 0.3, nil, function()
            self.config.bottomRect.gameObject:SetActive(false)
        end)
    else
        if self.currentSummonType == SummonType.Heroic then
            self.config.bottomRect.anchoredPosition3D = U_Vector3(320, -100, 0)
        else
            self.config.bottomRect.anchoredPosition3D = U_Vector3(0, -100, 0)
        end
        self.config.bottomRect.gameObject:SetActive(true)
        DOTweenUtils.DoAnchorPosY(self.config.bottomRect, 77, 0.2, nil, function()
            self.config.bgBack.gameObject:SetActive((true))
        end)
    end
end

--- @param isHide boolean
function UIHeroSummonViewRemake:DoTweenHeroMythical(isHide)
    if isHide == true then
        self.config.heroMythicalReward:DOLocalMoveY(self.positionDefaultHeroMythical.y - 550, 0.1):OnComplete(function()
            self.config.heroMythicalReward.gameObject:SetActive(false)
        end)
    else
        if self.currentSummonType == SummonType.RateUp or self.currentSummonType == SummonType.Heroic
                or self.currentSummonType == SummonType.Cumulative then
            self.config.heroMythicalReward.gameObject:SetActive(true)
        else
            self.config.heroMythicalReward.gameObject:SetActive(false)
        end
        self.config.heroMythicalReward:DOLocalMoveY(self.positionDefaultHeroMythical.y, 0.2)
    end
end

function UIHeroSummonViewRemake:DoTweenTabBar(isHide, summonType)
    if isHide == true then
        local moveTime = 1.4
        self.config.fxFlareBook:Play()
        self.config.fxUiSummonBook:Play()

        --DOTweenUtils.DOScale(self.config.backGround.transform, U_Vector3.one * 3.5, moveTime, U_Ease.Linear, function()
        --end)
        local touchObject = TouchUtils.Spawn("UIHeroSummonViewRemake:DoTweenTabBar")
        self.config.tabAnchor:DOLocalMoveX(self.positionDefaultTabBar.x + 550, 0.1):OnComplete(function()
            self.config.tabAnchor.gameObject:SetActive(false)
            if (summonType == SummonType.RateUp) then
                Coroutine.start(function()
                    coroutine.waitforseconds(0.2)
                    self:DoTweenHeroMythical(false)
                end)
                self:HidePreviewHeroMenu()
                self:SetSummonerState(false)
                self:CheckTutorialSummon()
                touchObject:Enable()
            elseif (summonType == SummonType.NewHero or summonType == SummonType.NewHero2 or summonType == SummonType.HeroRelease or summonType == SummonType.Kazetsu) then
                Coroutine.start(function()
                    coroutine.waitforseconds(0.2)
                    self:DoTweenHeroMythical(false)
                end)
                self:EnableBook(false)
                self:EnableBgNewHero(false)
                self.config.backGround.gameObject:SetActive(false)
                self:SetSummonerState(false)
                self:CheckTutorialSummon()
                touchObject:Enable()
            else
                Coroutine.start(function()
                    coroutine.waitforseconds(moveTime)
                    self:DoTweenHeroMythical(false)
                    self:EnableBook(false)
                    self:SetSummonerState(false)
                    self:CheckTutorialSummon()
                    touchObject:Enable()
                end)
            end
        end)
    else
        self:HidePreviewHeroMenu()
        if (summonType == SummonType.RateUp) then
            self.config.bookCircle:SetActive(false)
            self:ValidatePreviewHeroMenu()
            if self.heroResource ~= nil then
                self.previewHeroMenu:PreviewHero(self.heroResource)
                local factionId = ClientConfigUtils.GetFactionIdByHeroId(self.heroResource.heroId)
                self.previewHeroMenu:UpdateFactionBackground(factionId, PreviewHeroBgAnchorType.HeroSummon)
            end
        elseif summonType == SummonType.NewHero
                or summonType == SummonType.NewHero2
                or summonType == SummonType.HeroRelease
                or summonType == SummonType.Kazetsu then
            self.config.bookCircle:SetActive(false)
            self:EnableBgNewHero(true, summonType)
        else
            self:EnableBook(true)
        end
        self.uiPreviewHeroSummon:OnHide()
        self.config.tabAnchor.gameObject:SetActive(true)
        self.config.tabAnchor:DOLocalMoveX(self.positionDefaultTabBar.x, 0.2)
        self.sceneSummon = SceneSummonType.SummonTable
    end
end

function UIHeroSummonViewRemake:DoTweenSummonTable(isHide)
    if isHide == true then
        self.config.summonerTable:DOLocalMoveY(self.positionDefaultSummonTable.y - 400, 0.1):OnComplete(function()
            self.config.summonerTable.gameObject:SetActive(false)
        end)
    else
        self.config.summonerTable.gameObject:SetActive(true)
        self.config.summonerTable:DOLocalMoveY(self.positionDefaultSummonTable.y, 0.2)
    end
end
--- @param isEnable boolean
function UIHeroSummonViewRemake:EnableBottom(isEnable)
    self.config.bottomRect.gameObject:SetActive(isEnable)
    self.config.bgBack.gameObject:SetActive((isEnable))
end

function UIHeroSummonViewRemake:OnDestroy()
    self.uiPreviewHeroSummon:OnDestroy()
end

function UIHeroSummonViewRemake:SetMoneyBar(...)
    local args = { ... }
    self.moneyList:Clear()
    for i = 1, #args do
        self.moneyList:Add(args[i])
    end
    self.moneyBarListView:SetData(self.moneyList, UIPoolType.MoneyBarView)
end

function UIHeroSummonViewRemake:SetChooseButtonWithIndex(index)
    for k, v in pairs(self.buttonDic:GetItems()) do
        v:SetTabState(k == index)
    end
end

function UIHeroSummonViewRemake:SetShowTableWithIndex(index)
    for k, v in pairs(self.summonerTableDic:GetItems()) do
        if (k == index) then
            v.gameObject:SetActive(true)
        else
            v.gameObject:SetActive(false)
        end
    end
end

--- @return void
--- @param summonType SummonType
function UIHeroSummonViewRemake:ShowTableWithIndex(summonType)
    if self.currentSummonType == summonType then
        self.uiPreviewHeroSummon:OnHide()
        return
    end

    self.currentSummonType = summonType
    self:ShowBook(summonType)
    self.tableView:Show()
    self.moneyList:Clear()
    self:SetBackground(summonType)
    if summonType == SummonType.Heroic then
        self.resultView.skipAnimation = false
        self.resultView:InitTickEnableAnimation()
        self:SetMoneyBar(MoneyType.GEM, MoneyType.SUMMON_HEROIC_SCROLL)
        self:SetSummonPoint(InventoryUtils.GetMoney(MoneyType.SUMMON_POINT))
        self.config.buttonSummonPoint.onClick:RemoveAllListeners()
        self.config.buttonSummonPoint.onClick:AddListener(function()
            self:OnClickSummonPoint(SummonType.Cumulative, 1)
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        end)
    elseif summonType == SummonType.Friendship then
        self:SetMoneyBar(MoneyType.FRIEND_POINT)
    elseif summonType == SummonType.Basic then
        self:SetMoneyBar(MoneyType.SUMMON_BASIC_SCROLL)
    elseif summonType == SummonType.NewHero then
        self:SetMoneyBar(MoneyType.SUMMON_ELITE_SCROLL, MoneyType.GEM)
        local event = EventTimeType.EVENT_HERO_RELEASE
        if EventInBound.IsEventOpening(event) then
            ---@type MoneyBarView
            local moneyBar = self.moneyBarListView.iconViewList:Get(1)
            moneyBar:AddListener(function()
                PopupMgr.HidePopup(self.model.uiName)
                PopupMgr.ShowPopup(UIPopupName.UIEventHeroRelease, { ["eventTab"] = EventHeroReleaseTab.Bundle })
            end)
        end
        self:UpdateListItemPointNewHero()
    elseif summonType == SummonType.NewHero2 then
        self:SetMoneyBar(MoneyType.SUMMON_ELITE_SCROLL, MoneyType.GEM)
        local event = EventTimeType.EVENT_NEW_HERO_BUNDLE
        if EventInBound.IsEventOpening(event) then
            ---@type MoneyBarView
            local moneyBar = self.moneyBarListView.iconViewList:Get(1)
            moneyBar:AddListener(function()
                PopupMgr.HidePopup(self.model.uiName)
                PopupMgr.ShowPopup(UIPopupName.UIEventNewHero, { ["eventType"] = event })
            end)
        end
        self:UpdateListItemPointNewHero2()
    elseif summonType == SummonType.Kazetsu then
        self:SetMoneyBar(MoneyType.SUMMON_ELITE_SCROLL, MoneyType.GEM)
        local event = EventTimeType.EVENT_KAZETSU
        if EventInBound.IsEventOpening(event) then
            ---@type MoneyBarView
            local moneyBar = self.moneyBarListView.iconViewList:Get(1)
            local data = {}
            data.tab = EventKazetsuTab.BUNDLE;
            moneyBar:AddListener(function()
                PopupMgr.HidePopup(self.model.uiName)
                PopupMgr.ShowPopup(UIPopupName.UIEventKazetsu, data)
            end)
        end
        self:UpdateListItemPointHeroKazetsu()
    elseif summonType == SummonType.HeroRelease then
        self:SetMoneyBar(MoneyType.SUMMON_ELITE_SCROLL, MoneyType.GEM)
        local event = EventTimeType.EVENT_HERO_RELEASE
        if EventInBound.IsEventOpening(event) then
            ---@type MoneyBarView
            local moneyBar = self.moneyBarListView.iconViewList:Get(1)
            moneyBar:AddListener(function()
                PopupMgr.HidePopup(self.model.uiName)
                PopupMgr.ShowPopup(UIPopupName.UIEventHeroRelease, { ["eventTab"] = EventHeroReleaseTab.Bundle })
            end)
        end
        self:UpdateListItemPointHeroRelease()
    elseif summonType == SummonType.RateUp then
        self:SetMoneyBar(MoneyType.GEM, MoneyType.SUMMON_HEROIC_SCROLL)
        self:SetEventRateUpPoint(false)
        self.config.buttonSummonPoint.onClick:RemoveAllListeners()
    end
    self.mythicalReward:SetupMythical(summonType)
    self:SetChooseButtonWithIndex(summonType)
    self:SetShowTableWithIndex(summonType)
    self:InitLocalization()
end

--- @param summonType SummonType
function UIHeroSummonViewRemake:ShowBook(summonType)
    --- @param k SummonType
    --- @param v UnityEngine_Transform
    for k, v in pairs(self.imgBookDict:GetItems()) do
        v.gameObject:SetActive(k == summonType)
    end
end

function UIHeroSummonViewRemake:ShowDefault()
    if self:IsRateUpOpening() then
        self:DoTweenTabBar(false, SummonType.RateUp)
    elseif self:IsEventKazetsuOpening() then
        self:DoTweenTabBar(false, SummonType.Kazetsu)
    elseif self:IsNewHeroOpening() then
        self:DoTweenTabBar(false, SummonType.NewHero)
    elseif self:IsNewHero2Opening() then
        self:DoTweenTabBar(false, SummonType.NewHero2)
    else
        self:DoTweenTabBar(false, SummonType.Heroic)
    end
    self:DoTweenSummonTable(false)
end

--- @param enable boolean
function UIHeroSummonViewRemake:EnableBook(enable)
    self.config.bookCircle:SetActive(enable)
    if enable then
        self.config.fadeInSummon.gameObject:SetActive(false)
        self.config.fadeInSummon.color = U_Color(79 / 255, 62 / 255, 6 / 255, 1)
    else
        self.config.fadeInSummon.gameObject:SetActive(true)
        self.config.fadeInSummon:DOColor(U_Color(79 / 255, 62 / 255, 6 / 255, 0), 0.8)
    end
    self.config.backGround.gameObject:SetActive(enable)
end

--- @return void
function UIHeroSummonViewRemake:CreateListItemPointNewHero()
    self:ReturnPoolListItemPointNewHero()
    self.listItemPointNewHero = List()
    local list = self.eventNewHeroSummonConfig:GetListQuest()
    for i = 1, list:Count(), 1 do
        local v = list:Get(i)
        ---@type UIPointSummonNewHeroItemView
        local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIPointSummonNewHeroItemView, self.newHeroConfig1.point)
        item.config.transform:SetAsFirstSibling()
        item:SetData(v._listRequirements:Get(1), v._listReward)
        self.listItemPointNewHero:Add(item)
    end
end

--- @return void
function UIHeroSummonViewRemake:CreateListItemPointNewHero2()
    self:ReturnPoolListItemPointNewHero2()
    self.listItemPointNewHero2 = List()
    local list = self.eventNewHeroSummonConfig2:GetListQuest()
    for i = 1, list:Count(), 1 do
        local v = list:Get(i)
        ---@type UIPointSummonNewHeroItemView
        local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIPointSummonNewHeroItemView, self.newHeroConfig2.point)
        item.config.transform:SetAsFirstSibling()
        item:SetData(v._listRequirements:Get(1), v._listReward)
        self.listItemPointNewHero2:Add(item)
    end
end

--- @return void
function UIHeroSummonViewRemake:CreateListItemPointHeroRelease()
    self:ReturnPoolListItemPointHeroRelease()
    self.listItemPointHeroRelease = List()
    local list = self.eventHeroReleaseSummonConfig:GetListQuest()
    for i = 1, list:Count(), 1 do
        local v = list:Get(i)
        ---@type UIPointSummonNewHeroItemView
        local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIPointSummonNewHeroItemView, self.heroReleaseConfig.point)
        item.config.transform:SetAsFirstSibling()
        item:SetData(v._listRequirements:Get(1), v._listReward)
        self.listItemPointHeroRelease:Add(item)
    end
end

--- @return void
function UIHeroSummonViewRemake:CreateListItemPointHeroKazetsu()
    self:ReturnPoolListItemPointHeroKazetsu()
    self.listItemPointHeroKazetsu = List()
    local list = self.eventKazetsuConfig:GetFirstListKazetsuSummonQuestConfig()
    for i = 1, list:Count(), 1 do
        local v = list:Get(i)
        ---@type UIPointSummonNewHeroItemView
        local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIPointSummonNewHeroItemView, self.heroKazetsuConfig.point)
        item.config.transform:SetAsFirstSibling()
        item:SetData(v._listRequirements:Get(1), v._listReward)
        self.listItemPointHeroKazetsu:Add(item)
    end
end

function UIHeroSummonViewRemake:UpdateListItemPointNewHero()
    if self.listItemPointNewHero == nil then
        self:CreateListItemPointNewHero()
    end

    local max = 731
    local step = 160
    local deltaNode = 40
    local start = max - step * (self.listItemPointNewHero:Count() - 1)
    self.newHeroConfig1.textNewHeroSummonPoint.text = tostring(self.eventNewHeroSummonModel.numberSummon)

    local index = 0
    for i = 1, self.listItemPointNewHero:Count(), 1 do
        ---@type UIPointSummonNewHeroItemView
        local v = self.listItemPointNewHero:Get(i)
        if v.point <= self.eventNewHeroSummonModel.numberSummon then
            index = i
            v:SetClaimReward(true)
        else
            v:SetClaimReward(false)
        end
    end
    local delta = 0
    if index < self.listItemPointNewHero:Count() then
        local p1 = 0
        local currentStep = step
        local d = deltaNode
        if index > 0 then
            ---@type UIPointSummonNewHeroItemView
            local point1 = self.listItemPointNewHero:Get(index)
            p1 = point1.point
            delta = start + step * (index - 1)
            currentStep = step - deltaNode
            d = deltaNode / 2
        else
            delta = 0
            currentStep = start - deltaNode / 2
            d = 0
        end
        ---@type UIPointSummonNewHeroItemView
        local point2 = self.listItemPointNewHero:Get(index + 1)
        if self.eventNewHeroSummonModel.numberSummon > p1 then
            delta = delta + d + currentStep * ((self.eventNewHeroSummonModel.numberSummon - p1) / (point2.point - p1))
        end
    else
        delta = 731
    end
    self.newHeroConfig1.progressSummonNewHero.sizeDelta = U_Vector2(self.newHeroConfig1.progressSummonNewHero.sizeDelta.x,
            delta)
end

function UIHeroSummonViewRemake:UpdateListItemPointNewHero2()
    if self.listItemPointNewHero2 == nil then
        self:CreateListItemPointNewHero2()
    end

    local max = 731
    local step = 160
    local deltaNode = 40
    local start = max - step * (self.listItemPointNewHero2:Count() - 1)
    self.newHeroConfig2.textNewHeroSummonPoint.text = tostring(self.eventNewHeroSummonModel2.numberSummon)

    local index = 0
    for i = 1, self.listItemPointNewHero2:Count(), 1 do
        ---@type UIPointSummonNewHeroItemView
        local v = self.listItemPointNewHero2:Get(i)
        if v.point <= self.eventNewHeroSummonModel2.numberSummon then
            index = i
            v:SetClaimReward(true)
        else
            v:SetClaimReward(false)
        end
    end
    local delta = 0
    if index < self.listItemPointNewHero2:Count() then
        local p1 = 0
        local currentStep = step
        local d = deltaNode
        if index > 0 then
            ---@type UIPointSummonNewHeroItemView
            local point1 = self.listItemPointNewHero2:Get(index)
            p1 = point1.point
            delta = start + step * (index - 1)
            currentStep = step - deltaNode
            d = deltaNode / 2
        else
            delta = 0
            currentStep = start - deltaNode / 2
            d = 0
        end
        ---@type UIPointSummonNewHeroItemView
        local point2 = self.listItemPointNewHero2:Get(index + 1)
        if self.eventNewHeroSummonModel2.numberSummon > p1 then
            delta = delta + d + currentStep * ((self.eventNewHeroSummonModel2.numberSummon - p1) / (point2.point - p1))
        end
    else
        delta = 731
    end
    self.newHeroConfig2.progressSummonNewHero.sizeDelta = U_Vector2(self.newHeroConfig2.progressSummonNewHero.sizeDelta.x,
            delta)
end

function UIHeroSummonViewRemake:UpdateListItemPointHeroRelease()
    --if self.listItemPointHeroRelease == nil then
        self:CreateListItemPointHeroRelease()
    --end

    local max = 731
    local step = 160
    local deltaNode = 40
    local start = max - step * (self.listItemPointHeroRelease:Count() - 1)
    self.heroReleaseConfig.textNewHeroSummonPoint.text = tostring(self.eventHeroReleaseModel.numberSummon)

    local index = 0
    for i = 1, self.listItemPointHeroRelease:Count(), 1 do
        ---@type UIPointSummonNewHeroItemView
        local v = self.listItemPointHeroRelease:Get(i)
        if v.point <= self.eventHeroReleaseModel.numberSummon then
            index = i
            v:SetClaimReward(true)
        else
            v:SetClaimReward(false)
        end
    end
    local delta = 0
    if index < self.listItemPointHeroRelease:Count() then
        local p1 = 0
        local currentStep = step
        local d = deltaNode
        if index > 0 then
            ---@type UIPointSummonNewHeroItemView
            local point1 = self.listItemPointHeroRelease:Get(index)
            p1 = point1.point
            delta = start + step * (index - 1)
            currentStep = step - deltaNode
            d = deltaNode / 2
        else
            delta = 0
            currentStep = start - deltaNode / 2
            d = 0
        end
        ---@type UIPointSummonNewHeroItemView
        local point2 = self.listItemPointHeroRelease:Get(index + 1)
        if self.eventHeroReleaseModel.numberSummon > p1 then
            delta = delta + d + currentStep * ((self.eventHeroReleaseModel.numberSummon - p1) / (point2.point - p1))
        end
    else
        delta = 731
    end
    self.heroReleaseConfig.progressSummonNewHero.sizeDelta = U_Vector2(self.heroReleaseConfig.progressSummonNewHero.sizeDelta.x,
            delta)
end

function UIHeroSummonViewRemake:UpdateListItemPointHeroKazetsu()
    if self.listItemPointHeroKazetsu == nil then
        self:CreateListItemPointHeroKazetsu()
    end

    local max = 731
    local step = 160
    local deltaNode = 40
    local start = max - step * (self.listItemPointHeroKazetsu:Count() - 1)
    --- @type QuestElementConfig
    local listSummonQuest = self.eventKazetsuConfig:GetFirstListKazetsuSummonQuestConfig():GetLastItem()
    local maxProgressPoint = listSummonQuest:GetMainRequirementTarget()
    local numberSummoned = self.eventKazetsuModel.numberSummon % maxProgressPoint
    self.heroKazetsuConfig.textNewHeroSummonPoint.text = tostring(numberSummoned)

    local index = 0
    for i = 1, self.listItemPointHeroKazetsu:Count(), 1 do
        ---@type UIPointSummonNewHeroItemView
        local v = self.listItemPointHeroKazetsu:Get(i)
        if v.point <= numberSummoned then
            index = i
            v:SetClaimReward(true)
        else
            v:SetClaimReward(false)
        end
    end
    local delta = 0
    if index < self.listItemPointHeroKazetsu:Count() then
        local p1 = 0
        local currentStep = step
        local d = deltaNode
        if index > 0 then
            ---@type UIPointSummonNewHeroItemView
            local point1 = self.listItemPointHeroKazetsu:Get(index)
            p1 = point1.point
            delta = start + step * (index - 1)
            currentStep = step - deltaNode
            d = deltaNode / 2
        else
            delta = 0
            currentStep = start - deltaNode / 2
            d = 0
        end
        ---@type UIPointSummonNewHeroItemView
        local point2 = self.listItemPointHeroKazetsu:Get(index + 1)
        if numberSummoned > p1 then
            delta = delta + d + currentStep * ((numberSummoned - p1) / (point2.point - p1))
        end
    else
        delta = 731
    end
    self.heroKazetsuConfig.progressSummonNewHero.sizeDelta = U_Vector2(self.heroKazetsuConfig.progressSummonNewHero.sizeDelta.x,
            delta)
end

function UIHeroSummonViewRemake:ReturnPoolListItemPointNewHero()
    if self.listItemPointNewHero ~= nil then
        ---@param v UIPointSummonNewHeroItemView
        for i, v in ipairs(self.listItemPointNewHero:GetItems()) do
            v:ReturnPool()
        end
        self.listItemPointNewHero:Clear()
        self.listItemPointNewHero = nil
    end
end

function UIHeroSummonViewRemake:ReturnPoolListItemPointNewHero2()
    if self.listItemPointNewHero2 ~= nil then
        ---@param v UIPointSummonNewHeroItemView
        for i, v in ipairs(self.listItemPointNewHero2:GetItems()) do
            v:ReturnPool()
        end
        self.listItemPointNewHero2:Clear()
        self.listItemPointNewHero2 = nil
    end
end

function UIHeroSummonViewRemake:ReturnPoolListItemPointHeroRelease()
    if self.listItemPointHeroRelease ~= nil then
        ---@param v UIPointSummonNewHeroItemView
        for i, v in ipairs(self.listItemPointHeroRelease:GetItems()) do
            v:ReturnPool()
        end
        self.listItemPointHeroRelease:Clear()
        self.listItemPointHeroRelease = nil
    end
end

function UIHeroSummonViewRemake:ReturnPoolListItemPointHeroKazetsu()
    if self.listItemPointHeroKazetsu ~= nil then
        ---@param v UIPointSummonNewHeroItemView
        for i, v in ipairs(self.listItemPointHeroKazetsu:GetItems()) do
            v:ReturnPool()
        end
        self.listItemPointHeroKazetsu:Clear()
        self.listItemPointHeroKazetsu = nil
    end
end


function UIHeroSummonViewRemake:SetPreviewBySummonEvent(dataId)
    if (dataId ~= nil and dataId == 7) then
        self.previewHeroMenu.config.heroAnchor.localScale = U_Vector3(1.55,1.55,1) -- nero only
    end
    --self.previewHeroMenu.config.heroAnchor.localScale = U_Vector3(1.55,1.55,1) -- jeronim only
end

function UIHeroSummonViewRemake:ValidatePreviewHeroMenu()

    if self.previewHeroMenu == nil then
        self.previewHeroMenu = PrefabLoadUtils.Get(PreviewHeroMenu, zgUnity.transform)
    end
    self.previewHeroMenu:OnShow()
end

function UIHeroSummonViewRemake:HidePreviewHeroMenu()
    if self.previewHeroMenu ~= nil then
        self.previewHeroMenu:SetPreviewHeroBackgroundScale(1.15);
        self.previewHeroMenu:Hide()
        self.previewHeroMenu.config.heroAnchor.localScale = U_Vector3(2,2,1)
        self.previewHeroMenu = nil
    end
end

function UIHeroSummonViewRemake:EnableBgNewHero(isEnable, summonType)
    self.config.newHero:SetActive(false)
    self.config.newHero2:SetActive(false)
    self.config.heroRelease:SetActive(false)
    self.config.heroKazetsu:SetActive(false)
    self.config.backGround.gameObject:SetActive(not isEnable)
    if isEnable then
        self:ValidatePreviewHeroMenu()
        --- @type EventNewHeroSummonModel
        local eventPopupModel
        if summonType == SummonType.NewHero then
            self.config.newHero:SetActive(true)
            eventPopupModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_SUMMON)
            local dataId = 1
            if eventPopupModel ~= nil and eventPopupModel:IsOpening() then
                dataId = eventPopupModel.timeData.dataId
            end
            self.previewHeroMenu:SetBgHeroMenuByName("bg_hero_event_summon_" .. dataId, PreviewHeroBgAnchorType.EventNewHeroSummon)
        elseif summonType == SummonType.Kazetsu then
            self.config.heroKazetsu:SetActive(true)
            local idAbyss = 7
            --- @type EventKazetsuModel
            eventPopupModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
            self.previewHeroMenu:SetBgHeroMenuByName("bg_hero_release_event_summon_" .. idAbyss, PreviewHeroBgAnchorType.EventNewHeroSummon, idAbyss)
            self:SetPreviewBySummonEvent(idAbyss)
        elseif summonType == SummonType.NewHero2 then
            self.config.newHero2:SetActive(true)
            eventPopupModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_RATE_UP)
            local dataId = 1
            if eventPopupModel ~= nil and eventPopupModel:IsOpening() then
                dataId = eventPopupModel.timeData.dataId
            end
            self.previewHeroMenu:SetBgHeroMenuByName("bg_hero_event_summon2_" .. dataId, PreviewHeroBgAnchorType.EventNewHeroSummon, dataId)
        elseif summonType == SummonType.HeroRelease then
            self.config.heroRelease:SetActive(true)
            eventPopupModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HERO_RELEASE)
            local dataId = 1
            if eventPopupModel ~= nil and eventPopupModel:IsOpening() then
                dataId = eventPopupModel.timeData.dataId
            end
            self:SetPreviewBySummonEvent(dataId)
            self.previewHeroMenu:SetBgHeroMenuByName("bg_hero_release_event_summon_" .. dataId, PreviewHeroBgAnchorType.EventNewHeroSummon,dataId)
        end
        self.previewHeroMenu:SetPreviewHeroScale(2)
        self.previewHeroMenu:SetPreviewHeroBackgroundScale(1.15)
        ---@type EventNewHeroSummonConfig
        local eventNewHeroSummonConfig = eventPopupModel:GetConfig()
        local heroId, heroStar = eventNewHeroSummonConfig:GetHeroIdAndStar()
        local heroResource = HeroResource()
        heroResource:SetData(nil, heroId, heroStar, 1)
        self.previewHeroMenu:PreviewHero(heroResource)
    else
        self:HidePreviewHeroMenu()
    end
end

--- @param summonType SummonType
function UIHeroSummonViewRemake:OpenTabBySummonType(summonType)
    if summonType == SummonType.Heroic
            or summonType == SummonType.Friendship
            or summonType == SummonType.Basic then
        self:ShowTableWithIndex(summonType)
    elseif summonType == SummonType.RateUp and self:IsRateUpOpening() then
        self:ShowTableWithIndex(summonType)
    elseif summonType == SummonType.Kazetsu and self:IsEventKazetsuOpening() then
        self:ShowTableWithIndex(summonType)
    elseif summonType == SummonType.NewHero and self:IsNewHeroOpening() then
        self:ShowTableWithIndex(summonType)
    elseif summonType == SummonType.NewHero2 and self:IsNewHero2Opening() then
        self:ShowTableWithIndex(summonType)
    elseif summonType == SummonType.HeroRelease and self:IsHeroReleaseOpening() then
        self:ShowTableWithIndex(summonType)
    else
        self:ShowTableWithIndex(SummonType.Heroic)
    end
end
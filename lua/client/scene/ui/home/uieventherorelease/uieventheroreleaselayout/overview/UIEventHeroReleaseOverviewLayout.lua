--- @class UIEventHeroReleaseOverviewLayout : UIEventHeroReleaseLayout
UIEventHeroReleaseOverviewLayout = Class(UIEventHeroReleaseOverviewLayout, UIEventHeroReleaseLayout)
local ICON_BUNDLE_IMG_PATH = "TexturesAutoLoaded/UI/HomeScene/Event/EventHeroRelease/overview/"
--- @param view UIEventHeroReleaseView
--- @param eventTimeType EventTimeType
--- @param anchor UnityEngine_RectTransform
function UIEventHeroReleaseOverviewLayout:Ctor(view, eventTimeType, anchor)
    --- @type UIEventHeroReleaseOverviewLayoutConfig
    self.layoutConfig = nil
    --- @type ItemsTableView
    self.moneyTableView = nil
    --- @type EventHeroReleaseModel
    self.eventModel = nil
    --- @type WorldSpaceHeroView
    self.worldSpaceHeroView = nil

    UIEventHeroReleaseLayout.Ctor(self, view, eventTimeType, anchor)
end

function UIEventHeroReleaseOverviewLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_hero_release_overview", self.anchor)
    UIEventHeroReleaseLayout.InitLayoutConfig(self, inst)

    self.moneyTableView = ItemsTableView(self.layoutConfig.moneyTableView, nil, UIPoolType.MoneyBarView)

    self:InitLocalization()

    self:InitUpdateTime()

    self:InitButtons()
end

function UIEventHeroReleaseOverviewLayout:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateEventHeroReleaseTime = function(isSetTime)
        if isSetTime == true then
            self.timeHeroReleaseSummon = self.eventModel.timeData.endTime - zg.timeMgr:GetServerTime()
        else
            self.timeHeroReleaseSummon = self.timeHeroReleaseSummon - 1
        end
        if self.timeHeroReleaseSummon > 0 then
            self.layoutConfig.eventRateupTime.text = string.format("%s %s",
                    LanguageUtils.LocalizeCommon("will_end_in"),
                    UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeHeroReleaseSummon)))
        else
            self:RemoveUpdateTime()
        end
    end
end



function UIEventHeroReleaseOverviewLayout:InitLocalization()
    self.layoutConfig.textBundle.text = LanguageUtils.LocalizeCommon("hero_release_bundle")

    self.layoutConfig.textQuest.text = LanguageUtils.LocalizeCommon("hero_release_daily_quest")

    self.layoutConfig.rateUpText.text = LanguageUtils.LocalizeCommon("rate_up")
end

function UIEventHeroReleaseOverviewLayout:InitButtons()
    self.layoutConfig.buttonHeroInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHeroInfo()
    end)
    self.layoutConfig.buttonSummon.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSummon()
    end)
    self.layoutConfig.buttonBundle.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBundle()
    end)
    self.layoutConfig.buttonDailyQuest.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickQuest()
    end)
end

function UIEventHeroReleaseOverviewLayout:GetModelConfig()
    UIEventHeroReleaseLayout.GetModelConfig(self)

    self.dataId = self.eventModel.timeData.dataId
    self.questConfig = self.eventConfig:GetDailyQuestConfig()
end

function UIEventHeroReleaseOverviewLayout:UpdateLayoutByDataId()
    --- @type EventNewHeroSummonConfig
    local eventNewHeroSummonConfig = self.eventConfig:GetSummonConfig()
    self.heroId, self.heroStar = eventNewHeroSummonConfig:GetHeroIdAndStar()

    if self.eventModel:IsOpening() then
        zg.timeMgr:AddUpdateFunction(self.updateEventHeroReleaseTime)
    end

    self.layoutConfig.iconSummon.sprite = ResourceLoadUtils.LoadTexture("BannerEventHeroReleaseSummon",
            self.dataId, ComponentName.UnityEngine_Sprite)
    self.layoutConfig.iconSummon:SetNativeSize()

--[[    self.layoutConfig.iconTextHeroName.sprite = ResourceLoadUtils.LoadTexture("BannerEventHeroReleaseSummon",
            "text_" .. self.dataId, ComponentName.UnityEngine_Sprite)
    self.layoutConfig.iconTextHeroName:SetNativeSize()]]

    local factionNumber = ClientConfigUtils.GetFactionIdByHeroId(self.heroId)
    local folderPath = "Textures/BannerHeroReleaseOverview/"
    ClientConfigUtils.SetSprite(self.layoutConfig.bgImg,folderPath .. factionNumber )
    ClientConfigUtils.SetSprite(self.layoutConfig.factionImg,folderPath .. "icon_faction_" .. factionNumber)
    ClientConfigUtils.SetSprite(self.layoutConfig.iconBundle,folderPath .. "bg_banner_bundle_" .. factionNumber)
    ClientConfigUtils.SetSprite(self.layoutConfig.iconDailyQuest,folderPath .. "bg_banner_daily_quest_" .. factionNumber)
    self.layoutConfig.textBundle.color = ClientConfigUtils.GetTextOverviewColorByFaction(factionNumber)
    self.layoutConfig.textQuest.color = ClientConfigUtils.GetTextOverviewColorByFaction(factionNumber)
    self.layoutConfig.textBundleOutLine.effectColor = ClientConfigUtils.GetTextOverviewOutlineColorByFaction(factionNumber)
    self.layoutConfig.textQuestOutLine.effectColor = ClientConfigUtils.GetTextOverviewOutlineColorByFaction(factionNumber)
    self:ShowHeroModel()
end

function UIEventHeroReleaseOverviewLayout:OnShow()
    UIEventHeroReleaseLayout.OnShow(self)

    self:SetUpMoneyBar()

    self:UpdateLayoutByDataId()

    self:SetTextContent()
end

function UIEventHeroReleaseOverviewLayout:OnHide()
    UIEventHeroReleaseLayout.OnHide(self)

    self.moneyTableView:Hide()

    self:RemoveUpdateTime()

    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end
end

function UIEventHeroReleaseOverviewLayout:SetUpMoneyBar()
    local moneyList = List()
    moneyList:Add(MoneyType.SUMMON_ELITE_SCROLL)
    moneyList:Add(MoneyType.GEM)
    self.moneyTableView:SetData(moneyList)

    ---@type MoneyBarView
    local moneyBar = self.moneyTableView.iconViewList:Get(1)
    moneyBar:AddListener(function()
        self:OnClickBundle()
    end)
end

function UIEventHeroReleaseOverviewLayout:SetTextContent()
    self.layoutConfig.textHeroName.text = LanguageUtils.LocalizeNameHero(self.heroId)

    self.layoutConfig.textContent.text = LanguageUtils.LocalizeCommon("overview_hero_" .. self.heroId)
end

function UIEventHeroReleaseOverviewLayout:OnClickHeroInfo()
    local data = { }
    data.heroSort = List()
    data.callbackClose = function()
        PopupMgr.ShowAndHidePopup(self.model.uiName, nil, UIPopupName.UIHeroMenu2)
    end
    local heroResource = HeroResource()
    heroResource:SetData(nil, self.heroId, self.heroStar,1)
    data.heroSort:Add(heroResource)
    data.index = 1

    PopupMgr.ShowAndHidePopup(UIPopupName.UIHeroMenu2, data, self.model.uiName)
end

function UIEventHeroReleaseOverviewLayout:OnClickSummon()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIHeroSummonRemake, self:GetDataUiSummon(), self.model.uiName)
end

function UIEventHeroReleaseOverviewLayout:GetDataUiSummon()
    local data = {}
    data.eventType = self.eventTimeType
    data.callbackClose = function()
        PopupMgr.ShowAndHidePopup(self.model.uiName, nil, UIPopupName.UIHeroSummonRemake)
    end
    return data
end

function UIEventHeroReleaseOverviewLayout:OnClickBundle()
    self.view:SelectTab(EventHeroReleaseTab.Bundle)
end

function UIEventHeroReleaseOverviewLayout:OnClickQuest()
    self.view:SelectTab(EventHeroReleaseTab.DailyQuest)
end

function UIEventHeroReleaseOverviewLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateEventHeroReleaseTime)
end

function UIEventHeroReleaseOverviewLayout:ShowHeroModel()
    if self.worldSpaceHeroView == nil then
        ---@type UnityEngine_Transform
        local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
        self.worldSpaceHeroView = WorldSpaceHeroView(trans)
        local renderTexture = U_RenderTexture(1000, 1000, 24, U_RenderTextureFormat.ARGB32)
        self.layoutConfig.heroView.texture = renderTexture
        self.worldSpaceHeroView:Init(renderTexture)
    end
    local heroResource = HeroResource()
    heroResource:SetData(-1, self.heroId, self.heroStar,1)
    self.worldSpaceHeroView:ShowHero(heroResource,1)
    self.worldSpaceHeroView.config.bg:SetActive(false)
    if heroResource.heroId == HeroConstants.SCATHACH_HERO_ID then
        self.worldSpaceHeroView:SetSizeCamera(3.71)
    end
end
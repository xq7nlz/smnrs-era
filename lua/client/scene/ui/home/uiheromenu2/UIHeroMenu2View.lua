require "lua.client.scene.ui.home.uiHeroMenu2.UIHeroInfo2"
require "lua.client.scene.ui.home.uiHeroMenu2.UIHeroEvolve2"
require "lua.client.scene.ui.home.uiHeroMenu2.UIHeroSkin"
require "lua.client.scene.ui.home.uiHeroMenu2.UIIdleEffect"
require "lua.client.scene.ui.home.uiHeroMenu2.UIHeroReset2"
require "lua.client.scene.ui.home.uiHeroMenu.HeroStatChangeView"

--- @class UIHeroMenu2View : UIBaseView
UIHeroMenu2View = Class(UIHeroMenu2View, UIBaseView)

--- @return void
--- @param model UIHeroMenu2Model
function UIHeroMenu2View:Ctor(model)
    --- @type UISelect
    self.tab = nil
    --- @type UISelect
    self.tabSkinCollection = nil
    --- @type table
    self.funSelectTab = { self.ShowHeroInfo, self.ShowHeroEvolve, self.ShowHeroSkin, self.ShowIdleEffect, self.ShowHeroReset }
    self.funHideTab = { self.HideHeroInfo, self.HideHeroEvolve, self.HideHeroSkin, self.HideIdleEffect, self.HideHeroReset }
    --- @type PreviewHeroMenu
    self.previewHeroMenu = nil
    ---@type HeroResetConfig
    self.heroResetConfig = ResourceMgr.GetHeroResetConfig()
    -- init variables here
    UIBaseView.Ctor(self, model)
    --- @type UIHeroMenu2Model
    self.model = model
end

--- @return void
function UIHeroMenu2View:OnReadyCreate()
    ---@type UIHeroMenu2Config
    self.config = UIBaseConfig(self.uiTransform)
    ---@type TabHeroInfoConfig
    self.tabInfo = UIBaseConfig(self.config.tabHeroInfo)
    ---@type TabHeroInfoConfig
    self.tabEvolve = UIBaseConfig(self.config.tabEvolve)
    ---@type TabHeroInfoConfig
    self.tabSkin = UIBaseConfig(self.config.tabSkin)
    ---@type TabHeroInfoConfig
    self.tabIdleEffect = UIBaseConfig(self.config.tabIdleEffect)
    ---@type TabHeroInfoConfig
    self.tabReset = UIBaseConfig(self.config.tabReset)

    self.config.backButton.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonHero.onClick:AddListener(function()
        self:OnClickHero()
    end)
    self.config.buttonArrowBack.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBackHero()
    end)
    self.config.buttonArrowNext.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickNextHero()
    end)

    -- Tab
    --- @param obj TabHeroInfoConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect, indexTab)
        obj.button.interactable = not isSelect
        obj.heroInfoTabOn.gameObject:SetActive(isSelect)
        obj.heroInfoTabOff.gameObject:SetActive(not isSelect)
        self.config.content:GetChild(indexTab - 1).gameObject:SetActive(isSelect)
        if isSelect then
            obj.rectTranform.sizeDelta = U_Vector2(0, 40)
        else
            obj.rectTranform.sizeDelta = U_Vector2(0, 0)
        end
    end

    local onChangeSelect = function(indexTab, lastTab)
        if lastTab ~= nil then
            self.funHideTab[lastTab](self)
        end
        if indexTab ~= nil then
            self.funSelectTab[indexTab](self)
        end
        self.config.tab.enabled = false
        self.config.tab.enabled = true
    end

    local conditionClick = function(indexTab)
        if indexTab == HeroMenuTab.EVOLVE then
            return self:CheckCanOpenEvolve(true)
        elseif indexTab == HeroMenuTab.SKIN and ClientConfigUtils.GetListSkinByHeroId(self.model.heroResource.heroId):Count() == 0 then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("has_not_skin"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            return false
        else
            return true
        end
    end
    self.tab = UISelect(self.config.tab.transform, UIBaseConfig, onSelect, onChangeSelect, nil, conditionClick)

    -- Tab Skin
    --- @param obj UnityEngine_UI_Button
    --- @param isSelect boolean
    local onSelectSkin = function(obj, isSelect, indexTab)
        if obj ~= nil then
            UIUtils.SetInteractableButton(obj, not isSelect)
            --trigger image select on off
            obj.transform:GetChild(0).gameObject:SetActive(not isSelect)
            obj.transform:GetChild(1).gameObject:SetActive(isSelect)
        end
    end
    local onChangeSelectSkin = function(indexTab, lastTab)
        if indexTab ~= nil then
            self:UpdateHeroResource()
            self:UpdateHero()
        end
    end
    local onClickSelectSkin = function(indexTab)
        self.previewHeroMenu:ShowFxChangeSkin(self.model.heroResource.heroId)
    end
    self.tabSkinCollection = UISelect(self.config.skinCollection, nil, onSelectSkin, onChangeSelectSkin, onClickSelectSkin)

    --self.uiHeroInfo = UIHeroInfo2(self.config.content:GetChild(0), self.model, self)
    --self.uiHeroEvolve = UIHeroEvolve2(self.config.content:GetChild(1), self.model, self)
    --self.uiHeroSkin = UIHeroSkin(self.config.content:GetChild(2), self.model, self)
    --self.uiHeroReset = UIHeroReset2(self.config.content:GetChild(3), self.model, self)
    self.uiHeroInfo = UIHeroInfo2(self.config.heroInfoRect, self.model, self)
    self.uiHeroEvolve = UIHeroEvolve2(self.config.evolveRect, self.model, self)
    self.uiHeroSkin = UIHeroSkin(self.config.skinRect, self.model, self)
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.IDLE_EFFECT) then
        self.uiIdleEffect = UIIdleEffect(self.config.idleEffectRect, self.model, self)
    else
        self.config.idleEffectRect.gameObject:SetActive(false)
        self.config.tabIdleEffect.gameObject:SetActive(false)
    end
    self.uiHeroReset = UIHeroReset2(self.config.resetRect, self.model, self)
end

--- @return void
function UIHeroMenu2View:InitLocalization()
    local localizeHeroInfo = LanguageUtils.LocalizeCommon("hero_info")
    self.tabInfo.textHeroInfoOff.text = localizeHeroInfo
    self.tabInfo.textHeroInfoOn.text = localizeHeroInfo
    local localizeHeroEvolve = LanguageUtils.LocalizeCommon("evolve")
    self.tabEvolve.textHeroInfoOff.text = localizeHeroEvolve
    self.tabEvolve.textHeroInfoOn.text = localizeHeroEvolve
    local localizeHeroSkin = LanguageUtils.LocalizeCommon("skin")
    self.tabSkin.textHeroInfoOff.text = localizeHeroSkin
    self.tabSkin.textHeroInfoOn.text = localizeHeroSkin
    local localizeIdleEffect = LanguageUtils.LocalizeCommon("idle_effect")
    self.tabIdleEffect.textHeroInfoOff.text = localizeIdleEffect
    self.tabIdleEffect.textHeroInfoOn.text = localizeIdleEffect
    local localizeHeroReset = LanguageUtils.LocalizeCommon("reset")
    self.tabReset.textHeroInfoOff.text = localizeHeroReset
    self.tabReset.textHeroInfoOn.text = localizeHeroReset
    self.config.localizeStat1.text = LanguageUtils.LocalizeStat(StatType.ATTACK)
    self.config.localizeStat2.text = LanguageUtils.LocalizeStat(StatType.HP)
    self.config.localizeStat3.text = LanguageUtils.LocalizeStat(StatType.DEFENSE)
    if self.uiHeroInfo ~= nil then
        self.uiHeroInfo:InitLocalization()
    end
    if self.uiHeroEvolve ~= nil then
        self.uiHeroEvolve:InitLocalization()
    end
    if self.uiHeroReset ~= nil then
        self.uiHeroReset:InitLocalization()
    end
    if self.uiHeroSkin ~= nil then
        self.uiHeroSkin:InitLocalization()
    end
    if self.uiIdleEffect ~= nil then
        self.uiIdleEffect:InitLocalization()
    end
end

--- @return void
function UIHeroMenu2View:UpdateListHeroSort()
    ---@param heroResource HeroResource
    for i, heroResource in ipairs(self.model.heroSort:GetItems()) do
        if heroResource == self.model.heroResource then
            self.model.index = i
        end
    end
    self:UpdateHeroIndex()
end

--- @return void
function UIHeroMenu2View:OnReadyShow(result)
    UIBaseView.OnReadyShow(self, result)

    self.previewHeroMenu = PrefabLoadUtils.Get(PreviewHeroMenu, zgUnity.transform)
    self.previewHeroMenu:Show()
    self:Init(result)

    self:CheckUnlockUltimateSkin()
end

--- @return void
function UIHeroMenu2View:Init(result)
    if result ~= nil then
        self.cacheResult = result
        self.model.heroSort = result.heroSort
        self.model.index = result.index or 1
        self:UpdateHeroResource()
        self.tab:Select(1)
        if self.model.heroResource.inventoryId == nil then
            self.config.tab.gameObject:SetActive(false)
            self.config.skinCollection.gameObject:SetActive(true)
            self.tabSkinCollection:Select(1)
        else
            self.config.tab.gameObject:SetActive(true)
            self.config.skinCollection.gameObject:SetActive(false)
            self:UpdateLastStatHero()
            self:UpdateHero()
        end
    elseif self.cacheResult ~= nil then
        self:Init(self.cacheResult)
    end
end

function UIHeroMenu2View:CheckUnlockUltimateSkin()
    --- @type FeatureConfigInBound
    local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
    --- @type FeatureItemInBound
    local featureItemInBound = featureConfigInBound:GetFeatureConfigInBound(FeatureType.EVOLVE_STAR_13)
    -- get last skin of hero
    local anchor = self.config.skinCollection:GetChild(self.config.skinCollection.childCount - 1)
    anchor.gameObject:SetActive(featureItemInBound:IsAvailableToShowButton())
end

--- @return void
function UIHeroMenu2View:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self:CheckAndInitTutorial()
end

--- @return HeroResource
function UIHeroMenu2View:UpdateHeroResource()
    ---@type HeroResource
    local heroResource = self.model.heroSort:Get(self.model.index)
    if heroResource.inventoryId == nil then
        self.model.heroResource = HeroResource.Clone(self.model.heroSort:Get(self.model.index))
        if self.tabSkinCollection ~= nil and self.tabSkinCollection.indexTab ~= nil then
            self:SelectSkinCollection(self.tabSkinCollection.indexTab)
        end
    else
        self.model.heroResource = heroResource
    end
end

--- @return void
---@param skinIndex number
function UIHeroMenu2View:SelectSkinCollection(skinIndex)
    if skinIndex ~= nil then
        if skinIndex == 1 then
            self.model.heroResource.heroStar = ResourceMgr.GetHeroMenuConfig():GetDictHeroBaseStar(self.model.heroResource.heroId)
        elseif skinIndex == 2 then
            self.model.heroResource.heroStar = 7
        elseif skinIndex == 3 then
            self.model.heroResource.heroStar = 13
        end
        ---@type HeroLevelCapConfig
        local heroLevelCap = ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(self.model.heroResource.heroStar)
        self.model.heroResource.heroLevel = heroLevelCap.levelCap
    end
end

--- @return void
function UIHeroMenu2View:OnClickHero()
    self.previewHeroMenu:PlayAttackAnimation()
end

--- @return void
function UIHeroMenu2View:UpdateLastStatHero(statDict)
    if statDict ~= nil then
        self.lastStatDict = statDict
    elseif self.model.heroResource.inventoryId ~= nil then
        self.lastStatDict = ClientConfigUtils.GetStatHero(self.model.heroResource, zg.playerData:GetMethod(PlayerDataMethod.MASTERY).classDict)
    end
    self.lastLevel = self.model.heroResource.heroLevel
    self.lastStar = self.model.heroResource.heroStar
end

--- @return void
function UIHeroMenu2View:ChangeStatHero()
    self.config.statChange.position = U_Vector3((self.config.buttonArrowNext.transform.position.x + self.config.buttonArrowBack.transform.position.x) / 2,
            self.config.statChange.position.y, self.config.statChange.position.z)
    if self.listStatChange == nil then
        ---@type List
        self.listStatChange = List()
        for i = 1, self.config.statChange.childCount do
            self.listStatChange:Add(HeroStatChangeView(self.config.statChange:GetChild(i - 1)))
        end
    end

    ---@type Dictionary
    local statDict = ClientConfigUtils.GetStatHero(self.model.heroResource, zg.playerData:GetMethod(PlayerDataMethod.MASTERY).classDict)

    local statIndex = 0
    for i, v in pairs(statDict:GetItems()) do
        if i ~= StatType.POWER then
            local lastStat = self.lastStatDict:Get(i)
            if lastStat ~= v and statIndex < self.listStatChange:Count() and
                    (((self.lastLevel == self.model.heroResource.heroLevel) and (self.lastStar == self.model.heroResource.heroStar)) or
                            statIndex < 4) then
                statIndex = statIndex + 1
                ---@type HeroStatChangeView
                local statChange = self.listStatChange:Get(statIndex)
                local percent
                if ClientConfigUtils.GetStatValueTypeByStatType(i) == StatValueType.PERCENT then
                    percent = true
                end
                statChange:ChangeStat(lastStat, v, percent)
                statChange:SetLocalizeStat(LanguageUtils.LocalizeStat(i))
            end
        end
    end

    --XDebug.Log(LogUtils.ToDetail(statDict:GetItems()))
    --XDebug.Log(LogUtils.ToDetail(self.lastStatDict:GetItems()))
    self:UpdateLastStatHero(statDict)

    self:StopCoroutineEffect()
    self.effectStat = Coroutine.start(function()
        ---@param v HeroStatChangeView
        for _, v in pairs(self.listStatChange:GetItems()) do
            v:HideEffect()
        end
        for i = 1, statIndex do
            ---@type HeroStatChangeView
            local statChange = self.listStatChange:Get(i)
            statChange.config.animator.enabled = false
            statChange.config.gameObject:SetActive(true)
        end

        self.config.statChange.gameObject:SetActive(true)

        for i = 1, statIndex do
            ---@type HeroStatChangeView
            local statChange = self.listStatChange:Get(i)
            statChange:RunEffect()
            coroutine.waitforseconds(0.15)
        end
    end)
    self:CheckCanReset()
end

--- @return void
function UIHeroMenu2View:CheckCanReset()
    if self.model.heroResource.inventoryId ~= nil then
        if self.model.heroResource.heroLevel > 1 and self.heroResetConfig.starLimit >= self.model.heroResource.heroStar then
            self.config.tabReset.gameObject:SetActive(true)
        else
            self.config.tabReset.gameObject:SetActive(false)
            if self.tab.indexTab == HeroMenuTab.RESET then
                self.tab:Select(HeroMenuTab.HERO_INFO)
            end
        end
    end
end

---@param noti boolean
function UIHeroMenu2View:CheckCanOpenEvolve(noti)
    if self.model.heroResource.heroStar == HeroConstants.MAX_STAR - 2 then --12 to 13 star
        --- @type FeatureConfigInBound
        local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
        local evolveMaxStar = featureConfigInBound:GetFeatureConfigInBound(FeatureType.EVOLVE_STAR_13)
        local canEvolve =  ClientConfigUtils.CheckUnlockFeatureAndNotification(ResourceMgr.GetMajorFeatureLock().dict:GetItems(), FeatureType.EVOLVE_STAR_13)
        if evolveMaxStar:IsAvailableToGoFeature(noti) == false or not canEvolve then
            return
        end
    elseif self.model.heroResource.heroStar == HeroConstants.MAX_STAR - 1 then --13 to 14 star
        --- @type FeatureConfigInBound
        local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
        local evolveMaxStar = featureConfigInBound:GetFeatureConfigInBound(FeatureType.EVOLVE_STAR_14)
        local canEvolve =  ClientConfigUtils.CheckUnlockFeatureAndNotification(ResourceMgr.GetMajorFeatureLock().dict:GetItems(), FeatureType.EVOLVE_STAR_14)
        if evolveMaxStar:IsAvailableToGoFeature(noti) == false or not canEvolve then
            return
        end
    end

    if not self.model.heroResource:IsCanEvolveStar() then
        if noti == true then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("hero_max_star"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        end
        return false
    else
        return true
    end
end

--- @return void
function UIHeroMenu2View:CheckCanShowTab()
    if (self.tab.indexTab == HeroMenuTab.EVOLVE and self:CheckCanOpenEvolve() == false)
            or (self.tab.indexTab == HeroMenuTab.SKIN and ClientConfigUtils.IsContainSkinByHeroId(self.model.heroResource.heroId) == false) then
        self.tab:Select(HeroMenuTab.HERO_INFO)
    end
end

--- @return void
function UIHeroMenu2View:StopCoroutineEffect()
    self.config.statChange.gameObject:SetActive(false)
    if self.effectStat ~= nil then
        Coroutine.stop(self.effectStat)
        self.effectStat = nil
    end
end

--- @return void
function UIHeroMenu2View:UpdateHeroIndex()
    self.config.buttonArrowBack.gameObject:SetActive(self.model.index > 1)
    self.config.buttonArrowNext.gameObject:SetActive(self.model.index < self.model.heroSort:Count())
end

--- @return void
function UIHeroMenu2View:UpdateHero()
    --- @type HeroResource
    local heroResource = self.model.heroResource
    self.previewHeroMenu:PreviewHero(heroResource, HeroModelType.Basic)
    self.previewHeroMenu:GetScale(self.model.heroResource)
    if self.tab.indexTab == HeroMenuTab.HERO_INFO then
        local factionId = ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId)
        self.previewHeroMenu:UpdateFactionBackground(factionId, PreviewHeroBgAnchorType.HeroInfo, true)
    end

    if self.model.changeHero ~= nil then
        self.model.changeHero()
    end
    self:UpdateHeroIndex()
    self:CheckCanReset()
end

--- @return void
function UIHeroMenu2View:OnChangeHero()
    self:StopCoroutineEffect()
    self:UpdateHeroResource()

    self:CheckCanShowTab()

    self:UpdateHero()
    self:UpdateLastStatHero()
end

--- @return void
function UIHeroMenu2View:OnClickBackHero()
    if self.model.index > 1 then
        self.model.index = self.model.index - 1
        self:OnChangeHero()
    end
end

--- @return void
function UIHeroMenu2View:OnClickNextHero()
    if self.model.index < self.model.heroSort:Count() then
        self.model.index = self.model.index + 1
        self:OnChangeHero()
    end
end

--- @return void
function UIHeroMenu2View:ShowHeroInfo()
    self.uiHeroInfo:Show()
    self.model.changeHero = function()
        self.uiHeroInfo:OnChangeHero()
    end
    local factionId = ClientConfigUtils.GetFactionIdByHeroId(self.model.heroResource.heroId)
    self.previewHeroMenu:UpdateFactionBackground(factionId, PreviewHeroBgAnchorType.HeroInfo, true)
end

--- @return void
function UIHeroMenu2View:HideHeroInfo()
    self.uiHeroInfo:Hide()
end

--- @return void
function UIHeroMenu2View:ShowHeroReset()
    self.uiHeroReset:Show()
    self.model.changeHero = function()
        self.uiHeroReset:OnChangeHero()
    end
    self.previewHeroMenu:SetBgHeroMenuByName("bg_hero_evolve", PreviewHeroBgAnchorType.HeroEvolve)
end

--- @return void
function UIHeroMenu2View:HideHeroReset()
    self.uiHeroReset:Hide()
end

--- @return void
function UIHeroMenu2View:ShowHeroEvolve()
    self.uiHeroEvolve:Show()
    self.model.changeHero = function()
        self.uiHeroEvolve:OnChangeHero()
    end
    self.previewHeroMenu:SetBgHeroMenuByName("bg_hero_evolve", PreviewHeroBgAnchorType.HeroEvolve)
end

--- @return void
function UIHeroMenu2View:HideHeroEvolve()
    self.uiHeroEvolve:Hide()


end

--- @return void
function UIHeroMenu2View:ShowHeroSkin()
    self.uiHeroSkin:Show()
    self.model.changeHero = function()
        self.uiHeroSkin:OnChangeHero()
    end
    self.previewHeroMenu:SetBgHeroMenuByName("bg_dress_room", PreviewHeroBgAnchorType.IdleEffect)
end

--- @return void
function UIHeroMenu2View:HideHeroSkin()
    self.uiHeroSkin:Hide()
end

--- @return void
function UIHeroMenu2View:ShowIdleEffect()
    self.uiIdleEffect:Show()
    self.model.changeHero = function()
        self.uiIdleEffect:OnChangeHero()
    end
    self.previewHeroMenu:SetBgHeroMenuByName("bg_hero_evolve", PreviewHeroBgAnchorType.IdleEffect)
end

--- @return void
function UIHeroMenu2View:HideIdleEffect()
    self.uiIdleEffect:Hide()
end

--- @return void
function UIHeroMenu2View:Hide()
    UIBaseView.Hide(self)
    if self.previewHeroMenu ~= nil then
        self.previewHeroMenu:Hide()
        self.previewHeroMenu = nil
    end

    self.tab:Select(nil)
    if self.model.canSortHero == true then
        ---@type HeroList
        local heroList = InventoryUtils.Get(ResourceType.Hero)
        heroList:SortHeroDataBase()
    end

    self.config.statChange.gameObject:SetActive(false)
    self:RemoveListenerTutorial()
    self.cacheResult.index = self.model.index
end

--- @return void
---@param pivot UnityEngine_Vector3
function UIHeroMenu2View:SetButtonNextHero(pivot)
    self.config.buttonHero.transform.position = U_Vector3(pivot.x, self.config.buttonHero.transform.position.y, self.config.buttonHero.transform.position.z)
    ---@type UnityEngine_RectTransform
    local buttonBack = self.config.buttonArrowBack.transform
    buttonBack.position = U_Vector3(pivot.x + (pivot.x - self.config.buttonArrowNext.transform.position.x), buttonBack.position.y, buttonBack.position.z)
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIHeroMenu2View:ShowTutorial(tutorial, step)
    if step == TutorialStep.CLICK_AUTO_EQUIP then
        if self.tab.indexTab ~= HeroMenuTab.HERO_INFO then
            self.tab:Select(HeroMenuTab.HERO_INFO)
        end
        tutorial:ViewFocusCurrentTutorial(self.uiHeroInfo.config.buttonAutoEquip, U_Vector2(400, 150), nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.BACK_HERO_INFO
            or step == TutorialStep.CLICK_LEVEL_UP_HERO_BACK then
        tutorial:ViewFocusCurrentTutorial(self.config.backButton, 0.5,
                self.config.backButton.transform:GetChild(0), nil,
                tutorial:GetHandType(TutorialHandType.MOVE_CLICK))
    elseif step == TutorialStep.CLICK_LEVEL_UP_HERO then
        if self.tab.indexTab ~= HeroMenuTab.HERO_INFO then
            self.tab:Select(HeroMenuTab.HERO_INFO)
        end
        tutorial:ViewFocusCurrentTutorial(self.uiHeroInfo.config.buttonUpLv, U_Vector2(400, 150), nil, nil, TutorialHandType.MULTIPLE_CLICK)
    elseif step == TutorialStep.UPGRADE_HERO_WEAPON_SLOT then
        if self.tab.indexTab ~= HeroMenuTab.HERO_INFO then
            self.tab:Select(HeroMenuTab.HERO_INFO)
        end
        tutorial:ViewFocusCurrentTutorial(self.uiHeroInfo.config.weapon, U_Vector2(230, 230))
    elseif step == TutorialStep.UPGRADE_HERO_ARMOR_SLOT then
        if self.tab.indexTab ~= HeroMenuTab.HERO_INFO then
            self.tab:Select(HeroMenuTab.HERO_INFO)
        end
        tutorial:ViewFocusCurrentTutorial(self.uiHeroInfo.config.armor, U_Vector2(230, 230))
    elseif step == TutorialStep.UPGRADE_HERO_HELMET_SLOT then
        if self.tab.indexTab ~= HeroMenuTab.HERO_INFO then
            self.tab:Select(HeroMenuTab.HERO_INFO)
        end
        tutorial:ViewFocusCurrentTutorial(self.uiHeroInfo.config.hat, U_Vector2(230, 230))
    elseif step == TutorialStep.UPGRADE_HERO_RING_SLOT then
        if self.tab.indexTab ~= HeroMenuTab.HERO_INFO then
            self.tab:Select(HeroMenuTab.HERO_INFO)
        end
        tutorial:ViewFocusCurrentTutorial(self.uiHeroInfo.config.ring, U_Vector2(230, 230))
    end
end

function UIHeroMenu2View:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

HeroMenuTab = {
    HERO_INFO = 1,
    EVOLVE = 2,
    SKIN = 3,
    IDLE_EFFECT = 4,
    RESET = function()
        if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.IDLE_EFFECT) then
            return 5
        else
            return 4
        end
    end
}

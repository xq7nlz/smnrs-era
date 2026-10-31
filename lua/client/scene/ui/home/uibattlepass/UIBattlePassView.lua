--- @class UIBattlePassView : UIBaseView
UIBattlePassView = Class(UIBattlePassView, UIBaseView)
local POSX_BUTTON_UNLOCK_DATA_1 = 609
local POSX_PANEL_DATA_1 = 38
local POS_RIGHT_PANEL_DATA_1 = -663
local POS_BOTTOM_PANEL_DATA_1 = 156.1
local POS_BOTTOM_PANEL_DATA_2 = 238.083

local UIBattlePassTab = {
    REWARD = 1,
    QUEST = 2
}

--- @param model UIBattlePassModel
function UIBattlePassView:Ctor(model)
    --- @type UIBattlePassConfig
    self.config = nil
    --- @type Dictionary
    self.tabDict = Dictionary()
    ---@type MoneyBarView
    self.moneyBarView = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIBattlePassLayout
    self.currentLayout = nil
    self.eventTimeType = EventTimeType.EVENT_BATTLE_PASS
    ---@type EventBattlePassModel
    self.eventBattlePassModel = nil
    ---@type LevelOnEXP
    self.curLevelOnEXP = nil
    self.haveSkin = nil
    UIBaseView.Ctor(self, model)
    --- @type UIBattlePassModel
    self.model = model
end

function UIBattlePassView:GetBattlePassSkinId()
    self.skinId = ResourceMgr.GetBattlePassExchangeConfig():GetBattlePassFirstSkin().resourceId
end

function UIBattlePassView:ShowFinalProgress()
    ---@type RewardInBound
    local firstRewardInBound = self.eventBattlePassModel:GetConfig():GetFirstReward()
    ---@type RewardInBound
    local lastRewardInBound = self.eventBattlePassModel:GetConfig():GetFinalReward()
    ---@type RewardInBound
    local rewardInBound = firstRewardInBound
    if lastRewardInBound.type == ResourceType.Skin then
        rewardInBound = lastRewardInBound
    end

    if (rewardInBound.type == ResourceType.Skin) then
        self.haveSkin = true
        local skinId = rewardInBound.id
        local heroId = ClientConfigUtils.GetHeroIdBySkinId(skinId)
        local faction = ClientConfigUtils.GetFactionIdByHeroId(heroId)
        if self.worldSpaceHeroView == nil then
            ---@type UnityEngine_Transform
            local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
            self.worldSpaceHeroView = WorldSpaceHeroView(trans)
            local renderTexture = U_RenderTexture(800, 800, 24, U_RenderTextureFormat.ARGB32)
            self.config.rawImage.texture = renderTexture
            self.worldSpaceHeroView:Init(renderTexture)
        end
        self.config.iconFaction.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconFactions, faction)
        self.config.bgHeroNameGlow.color = ClientConfigUtils.GetColorGlowByFaction(faction)
        local heroResource = HeroResource()
        heroResource:SetData(-1, heroId, 1, 1)
        heroResource.heroItem:Add(HeroItemSlot.SKIN, skinId)
        self.worldSpaceHeroView:ShowHero(heroResource)
        self.worldSpaceHeroView.config.transform.position = U_Vector3(95000, 99000, 0)
        if self.worldSpaceHeroView ~= nil then
            self.worldSpaceHeroView.config.bg:SetActive(false)
        end
    else
        self.haveSkin = false
    end
end

function UIBattlePassView:ShowBattlePassSkin(skinId)
    self.config.textHeroName.text = LanguageUtils.LocalizeSkinName(skinId)
    self.haveSkin = true
    local heroId = ClientConfigUtils.GetHeroIdBySkinId(skinId)
    local faction = ClientConfigUtils.GetFactionIdByHeroId(heroId)
    if self.worldSpaceHeroView == nil then
        ---@type UnityEngine_Transform
        local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
        self.worldSpaceHeroView = WorldSpaceHeroView(trans)
        local renderTexture = U_RenderTexture(800, 800, 24, U_RenderTextureFormat.ARGB32)
        self.config.rawImage.texture = renderTexture
        self.worldSpaceHeroView:Init(renderTexture)
    end
    self.config.iconFaction.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconFactions, faction)
    self.config.bgHeroNameGlow.color = ClientConfigUtils.GetColorGlowByFaction(faction)
    local heroResource = HeroResource()
    heroResource:SetData(-1, heroId, 1, 1)
    heroResource.heroItem:Add(HeroItemSlot.SKIN, skinId)
    self.worldSpaceHeroView:ShowHero(heroResource)
    self.worldSpaceHeroView.config.transform.position = U_Vector3(95000, 99000, 0)
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView.config.bg:SetActive(false)
    end
end

function UIBattlePassView:GetWeekTimeToOpen(numberOfWeek)
    return self.eventBattlePassModel.timeData.startTime + (TimeUtils.SecondADay * 7 * numberOfWeek)
end

function UIBattlePassView:GetWeekTimeLeft(numberOfWeek)
    return self:GetWeekTimeToOpen(numberOfWeek) - zg.timeMgr:GetServerTime()
end

---@return number
---@param eventConfig EventBattlePassConfig
function UIBattlePassView:GetWeekNumber()
    ---@type EventBattlePassConfig
    local eventConfig = self.eventBattlePassModel:GetConfig()
    ---@type number
    local startTime = self.eventBattlePassModel.timeData.startTime
    ---@type number
    local timePass = zg.timeMgr:GetServerTime() - startTime
    ---@type number
    local weekNumber = math.floor(timePass / (TimeUtils.SecondADay * 7)) + 1 -- start from 1
    local maxWeekNumber = eventConfig:GetWeeklyQuestRewardConfig():Count()
    if (weekNumber > maxWeekNumber) then
        self.
        weekNumber = maxWeekNumber
    end
    return weekNumber
end

function UIBattlePassView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:InitTabs()
    self:InitButtons()
    self:InitUpdateTime()
    self:InitMoneyBar()
end

function UIBattlePassView:InitMoneyBar()
    if self.moneyBarView == nil then
        self.moneyBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.moneyAnchor)
        self.moneyBarView:SetIconData(MoneyType.GEM)
    end
end

function UIBattlePassView:OnPurchasePremiumSuccess()
    self.eventBattlePassModel:OnUpdatePurchasePremiumSuccess()
    self:OnUpdatePurchase()
end

function UIBattlePassView:OnUpdatePurchase()
    self:SetCommon()
    if (self.currentLayout ~= nil) then
        self.currentLayout:GetDataAndUpdateView()
    end

    if not self:CanPurchaseLevel() then
        PopupMgr.HidePopup(UIPopupName.UIPopupPurchaseLevelBattlePass)
        PopupMgr.HidePopup(UIPopupName.UIPopupBuyLevelBattlePass)
    end
end

---@param _active boolean
function UIBattlePassView:SetBtnPurchaseLevel(_active)
    self.config.purchaseDisabled.gameObject:SetActive(not _active)
end

function UIBattlePassView:SetBtnUnlockPremium()
    local hasPurchasePremium = self.eventBattlePassModel.isPurchasedPremium
    local textPremiumBuy
    if (hasPurchasePremium) then
        textPremiumBuy = "button_battle_pass_unlocked_premium"
    else
        textPremiumBuy = "button_battle_pass_unlock_premium"
    end
    self.config.textUnlockPremium.text = LanguageUtils.LocalizeCommon(textPremiumBuy)
    self.config.unlockPremiumDisable.gameObject:SetActive(hasPurchasePremium)
end

function UIBattlePassView:SetCommon()
    self:SetLevel()
    self:SetBtnUnlockPremium()
end

function UIBattlePassView:HideLayout()
    if self.currentLayout ~= nil then
        self.currentLayout:OnHide() -- hide scroll
    end
end

function UIBattlePassView:ShowLayout(uiTab)
    self:HideLayout()
    --self:DisableCommon()
    self:GetTabLayout(uiTab)
    self.currentLayout:OnShow()
end
function UIBattlePassView:GetTabLayout(uiTab)
    self.currentLayout = self.layoutDict:Get(uiTab)
    if self.currentLayout == nil then
        if uiTab == UIBattlePassTab.REWARD then
            require "lua.client.scene.ui.home.uiBattlePass.UIBattlePassRewardLayout"
            self.currentLayout = UIBattlePassRewardLayout(self, self.config.rewardLayout)
            self.layoutDict:Add(uiTab, self.currentLayout)
        else
            --  uiTab == UIBattlePassTab.QUEST
            require "lua.client.scene.ui.home.uiBattlePass.UIBattlePassQuestLayout"
            self.currentLayout = UIBattlePassQuestLayout(self, self.config.questLayout)
            self.layoutDict:Add(uiTab, self.currentLayout)
        end
    end
end

function UIBattlePassView:CanPurchaseLevel()
    local curExp = self.eventBattlePassModel:GetExp()
    self.curLevelOnEXP = self.eventBattlePassModel:GetLevelByExp(curExp)
    local curLevel = tonumber(self.curLevelOnEXP.level)
    local curExpOnLevel = 0
    local curLevelIsMax = curLevel >= self.eventBattlePassModel:GetConfig():GetLevelMax()
    return self.eventBattlePassModel:CanPurchaseLevel(curExp, curLevelIsMax)
end

function UIBattlePassView:SetLevel()
    local curExp = self.eventBattlePassModel:GetExp()
    ---@type LevelOnEXP
    self.curLevelOnEXP = self.eventBattlePassModel:GetLevelByExp(curExp)
    local curLevel = tonumber(self.curLevelOnEXP.level)
    -- XDebug.Log("curExp is" .. tostring(curExp) .. "CUR LEVEL IS " .. tostring(curLevel))
    local curExpOnLevel = 0
    local curLevelIsMax = curLevel >= self.eventBattlePassModel:GetConfig():GetLevelMax()

    local gap = tonumber(self.curLevelOnEXP.gap)
    if (curLevelIsMax) then
        self.config.textLevelProgress.text = LanguageUtils.LocalizeCommon("max")
        self.config.levelProgressBar.fillAmount = 1
        self.config.textLevel.text = tostring(gap) .. " / " .. gap
    else
        curExpOnLevel = tonumber(curExp) - tonumber(self.curLevelOnEXP.exp)
        --XDebug.Log("curExpOnLevel" .. tostring(curExpOnLevel) .. " gap " .. tostring(gap))
        if (curExpOnLevel > tonumber(gap)) then
            curExpOnLevel = tonumber(gap)
        end
        self.config.textLevelProgress.text = string.format("Lv.%d", tostring(self.curLevelOnEXP.level))
        self.config.levelProgressBar.fillAmount = curExpOnLevel / gap
        self.config.textLevel.text = tostring(math.floor(curExpOnLevel)) .. " / " .. gap
    end

    ---@type RewardInBound
    local firstRewardInBound = self.eventBattlePassModel:GetConfig():GetFirstReward()
    ---@type RewardInBound
    local lastRewardInBound = self.eventBattlePassModel:GetConfig():GetFinalReward()
    ---@type RewardInBound
    local rewardInBound = firstRewardInBound
    if lastRewardInBound.type == ResourceType.Skin then
        rewardInBound = lastRewardInBound
    end
    if (rewardInBound.type == ResourceType.Skin) then
        local skinId = rewardInBound.id
        self.config.textHeroName.text = LanguageUtils.LocalizeSkinName(self.skinId)
    end
    local canPurchaseLevel = self.eventBattlePassModel:CanPurchaseLevel(curExp, curLevelIsMax)
    self:SetBtnPurchaseLevel(canPurchaseLevel)
end

function UIBattlePassView:InitTabs()
    self.selectTab = function(currentTab)
        self:ShowLayout(currentTab)
        --- @param v UITabItem
        for k, v in pairs(self.tabDict:GetItems()) do
            v:SetTabState(k == currentTab)
        end
    end
    local addTab = function(uiBattlePassTab)
        self.tabDict:Add(uiBattlePassTab, UITabItem(self.config.tabRewardQuest:GetChild(uiBattlePassTab - 1),
                self.selectTab, function()
                    return tostring(uiBattlePassTab) --QuestDataInBound.GetQuestTreeTittleByGroupId(uiBattlePassTab)
                end, uiBattlePassTab))
    end
    addTab(UIBattlePassTab.REWARD)
    addTab(UIBattlePassTab.QUEST)
end

function UIBattlePassView:InitButtons()
    self.config.buttonUnlockPremium.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickUnlockPremiumBtn()
    end)
    self.config.buttonPurchaseLevel.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickPurchaseLevel()
    end)
    self.config.buttonExchange.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickExchange()
    end)
    self.config.backButton.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
    self.config.buttonHelpExp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfoExp()
    end)
    self.config.tab1.onClick:AddListener(function()
        self:OnTab1Click()
    end)
    self.config.tab2.onClick:AddListener(function()
        self:OnTab2Click()
    end)
end

function UIBattlePassView:OnTab1Click()
    self.config.bgDarkPopupTheme:SetActive(false)
    self.config.tab2.interactable = true
    self.config.tab1.interactable = false
end

function UIBattlePassView:OnTab2Click()
    self.config.bgDarkPopupTheme:SetActive(true)
    self.config.tab2.interactable = false
    self.config.tab1.interactable = true
end

function UIBattlePassView:OnClickExchange()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIBattlePassExchange, self.skinId, UIPopupName.UIBattlePass)
end

function UIBattlePassView:OnClickPurchaseLevel()
    local data = {}
    data.curLevel = tonumber(self.curLevelOnEXP.level)
    data.maxLevel = self.eventBattlePassModel:GetConfig():GetLevelMax()
    data.onBuySuccess = function()
        self:OnUpdatePurchase()
    end
    if (self:CanPurchaseLevel()) then
        --if self.eventBattlePassModel:IsPurchaseAllLevelByGem() then
        PopupMgr.ShowPopup(UIPopupName.UIPopupPurchaseLevelBattlePass, data)
        --else
        --    PopupMgr.ShowPopup(UIPopupName.UIPopupBuyLevelBattlePass, data)
        --end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("battle_pass_cannot_purchase_level"))
    end
end

function UIBattlePassView:OnClickUnlockPremiumBtn()
    if self.eventBattlePassModel.isPurchasedPremium == true then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("battle_pass_unlocked"))
        return
    end
    local data = {}
    data.onUnlockSuccess = function()
        self:OnPurchasePremiumSuccess()
    end
    data.callbackClose = function()
        self:OnCloseUnlockPremium()
    end
    data.haveSkin = self.haveSkin
    data.skinId = self.skinId
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView.config.gameObject:SetActive(false)
    end
    PopupMgr.ShowPopup(UIPopupName.UIUnlockBattlePass, data)
end
function UIBattlePassView:OnCloseUnlockPremium()
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView.config.gameObject:SetActive(true)
    end
end

function UIBattlePassView:InitLocalization()
    self.config.textPurchaseLevel.text = LanguageUtils.LocalizeCommon("battle_pass_purchase_level")
    self.config.textTabNameQuest.text = LanguageUtils.LocalizeCommon("battle_pass_tab_quest_title")
    self.config.textTabNameReward.text = LanguageUtils.LocalizeCommon("battle_pass_tab_reward_title")
    self.config.textUnlockPremium.text = LanguageUtils.LocalizeCommon("button_battle_pass_unlock_premium")
    self.config.textExchange.text = LanguageUtils.LocalizeCommon("battle_pass_exchange")
    if self.layoutDict then
        --- @param v UIBattlePassLayout
        for k, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

--- @param data {callbackClose : function}
function UIBattlePassView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)
    --- @type EventBattlePassModel
    self.eventBattlePassModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BATTLE_PASS)
    self.config.buttonExchange.gameObject:SetActive(self.eventBattlePassModel.timeData.dataId >= 12)
    self:InitLocalization()
    self.isOpen = self.eventBattlePassModel:IsOpening()
    if self.isOpen then
        self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
    end
    ---@type number
    local startTime = self.eventBattlePassModel.timeData.startTime
    ---@type number
    local month = TimeUtils.GetMonthFromTimestamp(startTime)
    self.config.textTitle.text = string.format(LanguageUtils.LocalizeCommon("battle_pass_title"), LanguageUtils.LocalizeMonth(month))
    self.config.rawImage.enabled = true
    self.config.charDesc:SetActive(true)
    self.dataId = self.eventBattlePassModel.timeData.dataId
    --self:ShowFinalProgress()
    self:GetBattlePassSkinId()
    self:ShowBattlePassSkin(self.skinId)
    self:SetSprite("background", self.config.bgDarkTheme)
    self:SetSprite("holder_main", self.config.bgCharacterHolderDarkTheme)
    self:SetSprite("bg_text_glow", self.config.bgTitleGlow)
    self:SetSprite("bg_title_detail", self.config.bgTitleDetail)
    if self.config.bgBottom then
        self:SetSprite("bg_bottom", self.config.bgBottom)
    end
    if self.config.bgHero then
        self:SetSprite("bg_hero", self.config.bgHero)
    end

    if self.haveSkin == true then
        self:SetLayoutHaveSkin()
    else
        self:SetLayoutNoSkin()
    end
    self:StartTime()
    self:SetCommon()
    self:InitMoneyBar()

    self:CheckNotification()

    self.selectTab(UIBattlePassTab.REWARD)
    local firstTimeOpen = self.eventBattlePassModel:CheckFirstTimeOpen()
    local exp = self.eventBattlePassModel:GetExp()
    if (firstTimeOpen or firstTimeOpen == nil) then
        if exp ~= 0 then
            --- Long : "1 localize tội đâu anh chịu"
            local data = {}
            data.notification = string.format(LanguageUtils.LocalizeCommon("noti_next_battle_pass"),
                    UIUtils.SetColorString(UIUtils.green_light, self.eventBattlePassModel:GetExp()))
            data.alignment = U_TextAnchor.MiddleCenter
            data.canCloseByBackButton = true
            data.listItem = List()
            data.alignment = U_TextAnchor.UpperCenter
            data.listItem:Add(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.BATTLE_PASS_EXP, exp))
            local buttonNo = {}
            buttonNo.text = LanguageUtils.LocalizeCommon("cancel")
            buttonNo.callback = function()
                PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
            end
            data.button1 = buttonNo
            data.SetActiveNoButton = false
            data.disableButtonItem = true
            local buttonYes = {}
            buttonYes.text = LanguageUtils.LocalizeCommon("confirm")
            buttonYes.callback = function()
                PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
            end
            data.button2 = buttonYes
            PopupMgr.ShowPopup(UIPopupName.UIPopupNotification, data)
        end
        self.eventBattlePassModel:SetFirstTimeOpen()
    end
end

--- @return void
function UIBattlePassView:SetSprite(spriteName, image)
    if self.lastDataId ~= self.dataId then
        self.lastDataId = self.dataId
    end
    local sprite = ResourceLoadUtils.LoadAssetBattlePass(self.dataId, spriteName)
    if sprite ~= nil then
        image.sprite = sprite
        image.gameObject:SetActive(true)
    else
        image.gameObject:SetActive(false)
    end
end

function UIBattlePassView:SetLayoutNoSkin()
    self.config.mainpannel.offsetMin = U_Vector2(0, POS_BOTTOM_PANEL_DATA_2);
    self.config.mainpannel.offsetMax = U_Vector2(0, self.config.mainpannel.offsetMax.y);
    self.config.bgDarkTheme2.gameObject:SetActive(true)
    self.config.rawImage.enabled = false
    self.config.charDesc:SetActive(false)
    self.config.bgCharacterHolderDarkTheme.enabled = false
end

function UIBattlePassView:SetLayoutHaveSkin()
    self.config.bgDarkTheme2.gameObject:SetActive(false)
    self.config.bgCharacterHolderDarkTheme.enabled = true
    self.config.mainpannel.offsetMin = U_Vector2(POSX_PANEL_DATA_1, POS_BOTTOM_PANEL_DATA_1);
    self.config.mainpannel.offsetMax = U_Vector2(POS_RIGHT_PANEL_DATA_1, self.config.mainpannel.offsetMax.y);
end

function UIBattlePassView:_GetEventEndTime()
    return self.eventBattlePassModel.timeData.endTime
end

function UIBattlePassView:RemoveListener()
    if self.eventListener ~= nil then
        self.eventListener:Unsubscribe()
        self.eventListener = nil
    end
end

function UIBattlePassView:StartTime()
    if self.updateTime ~= nil then
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end

function UIBattlePassView:StopTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end

function UIBattlePassView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIBattlePass)
end

function UIBattlePassView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UIBattlePassView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            local timeServer = zg.timeMgr:GetServerTime()
            self.timeRemaining = self:_GetEventEndTime() - timeServer
        else
            self.timeRemaining = self.timeRemaining - 1
        end
        if self.timeRemaining > 0 then
            self.config.textEventEndIn.text = string.format("%s %s",
                    LanguageUtils.LocalizeCommon("will_end_in"),
                    UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRemaining, 4)))
        else
            -- XDebug.Log("TIME REMAINING " ..  self.timeRemaining)
            self.config.textEventEndIn.text = ""
            self:StopTime()
            self:OnReadyHide()
        end
    end
end

function UIBattlePassView:EnableTabNotification(uiTab, isEnableNotify)
    --- @type UITabItem
    local uiTabItem = self.tabDict:Get(uiTab)
    uiTabItem:EnableNotify(isEnableNotify)
end

function UIBattlePassView:Hide()
    UIBaseView.Hide(self)
    self:OnTab1Click()
    self:StopTime()

    self:HideLayout()
    if self.moneyBarView ~= nil then
        self.moneyBarView:ReturnPool()
        self.moneyBarView = nil
    end
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end
end

function UIBattlePassView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("battle_pass"))
end

function UIBattlePassView:OnClickHelpInfoExp()
    local info = LanguageUtils.LocalizeHelpInfo("battle_pass_exp_info")
    info = string.gsub(info, "{1}", UIUtils.SetColorString(UIUtils.green_dark, self.eventBattlePassModel:GetExp()))
    --info = string.gsub(info, "{2}", UIUtils.SetColorString(UIUtils.green_dark, self.eventBattlePassModel:GetRedundantExp()))
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, string.format(info))
end

function UIBattlePassView:CheckNotification()
    self:EnableTabNotification(UIBattlePassTab.REWARD, self.eventBattlePassModel:CanClaimAllReward())
    self:EnableTabNotification(UIBattlePassTab.QUEST, self.eventBattlePassModel:HasQuestDoneNotClaimed())
end
require "lua.client.scene.ui.common.SkillHeroView"
require "lua.client.core.network.event.eventAiryuu.EventAiryuuTrialInBound"
require "lua.client.core.network.event.eventAiryuu.EventAiryuuTrialOutBound"
require "lua.client.core.network.event.EventHeroTrialHistory"

--- @class UIEventAiryuuTrialLayout : UIEventAiryuuLayout
UIEventAiryuuTrialLayout = Class(UIEventAiryuuTrialLayout, UIEventAiryuuLayout)

--- @param view UIEventAiryuuView
--- @param anchor UnityEngine_RectTransform
function UIEventAiryuuTrialLayout:Ctor(view, tab, anchor)
    --- @type UIEventAiryuuView
    self.view = view
    ---@type MoneyBarView
    self.moneyBarView = nil
    ---@type UILoopScroll
    self.uiScroll = nil
    ---@type UIEventAiryuuTrialLayoutConfig
    self.layoutConfig = nil
    UIEventAiryuuLayout.Ctor(self, view, tab, anchor)
end

function UIEventAiryuuTrialLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_airyuu_trial_layout", self.anchor)
    UIEventAiryuuLayout.InitLayoutConfig(self, inst)
    self.layoutConfig.slider.value = 1
    self.lastPlayerId = PlayerSettingData.playerId
    self.lastServerId = PlayerSettingData.serverId
    if not self.eventModel then
        self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_AIRYUU)
    end
    ---@type BattleTeamView
    self.battleTeamView = BattleTeamView(self.layoutConfig.enemyAnchor)
    self:InitButton()
    self:InitLocalization()
end

function UIEventAiryuuTrialLayout:InitLocalization()
    UIEventAiryuuLayout.InitLocalization(self)
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("airyuu_trial")
    self.layoutConfig.rewardText.text = LanguageUtils.LocalizeCommon("reward")
    self.layoutConfig.historyText.text = LanguageUtils.LocalizeCommon("history")
    self.layoutConfig.challengeText.text = LanguageUtils.LocalizeCommon("challenge")
    self.layoutConfig.difficultText.text = LanguageUtils.LocalizeCommon("select_difficult")
    self.layoutConfig.transformText.text = LanguageUtils.LocalizeCommon("transform")
end

function UIEventAiryuuTrialLayout:InitButton()
    self.layoutConfig.backButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
        self:CloseLayout()
    end)
    self.layoutConfig.inforButton.gameObject:SetActive(false)
    self.layoutConfig.inforButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_airyuu_trial_info"))
    end)
    self.layoutConfig.sliderHandle.onClick:AddListener(function()

    end)
    self.layoutConfig.slider.onValueChanged:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        local value = self.layoutConfig.slider.value
        self:GetEnemyDefenderTeamData(value)
    end)
    self.layoutConfig.addButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.layoutConfig.slider.value < 5 then
            self.layoutConfig.slider.value = self.layoutConfig.slider.value + 1
        end
    end)
    self.layoutConfig.subButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.layoutConfig.slider.value > 1 then
            self.layoutConfig.slider.value = self.layoutConfig.slider.value - 1
        end
    end)
    self.layoutConfig.rewardButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonReward()
    end)
    self.layoutConfig.historyButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonHistory()
    end)
    self.layoutConfig.transformButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonTransform()
    end)
    self.layoutConfig.ticketButtonAdd.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuyTicket()
    end)
    self.layoutConfig.buttonChallenge.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChallenge()
    end)
end

function UIEventAiryuuTrialLayout:OnClickButtonTransform()
    self.worldSpaceHeroView.previewHero.clientHero.animation:ClearTracks()
    self.worldSpaceHeroView.previewHero.clientHero.animation:SetToSetupPose()
    self.isLastFormDragon = self.worldSpaceHeroView.previewHero.clientHero:SwitchModelInstant2()
    self.worldSpaceHeroView.previewHero.clientHero:PlayIdleAnimation()
end

function UIEventAiryuuTrialLayout:OnClickButtonHistory()
    local data = {}
    data.type = PopupMulti.TrialBattleHistoryItem
    data.titleText = LanguageUtils.LocalizeCommon("history")

    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        ---@type Dictionary
        data.itemDict = EventHeroTrialHistory:ReadBuffer(buffer)
        data.itemDict:Reverse()
    end

    local onSuccess = function()
        PopupMgr.ShowPopup(UIPopupName.UIPopupMultiScrollRewardItem, data)
    end

    local onFailed = function()

    end

    NetworkUtils.RequestAndCallback(OpCode.EVENT_HERO_AIRYUU_HISTORY_GET, nil, onSuccess, onFailed, onBufferReading)
end

function UIEventAiryuuTrialLayout:OnClickButtonReward()
    local data = {}
    data.localize = LanguageUtils.LocalizeCommon("difficult")
    data.itemDict = self.eventModel.config:GetTrialChallengeRewardConfig()
    data.type = PopupMulti.DifficultRewardItem
    data.titleText = LanguageUtils.LocalizeCommon("reward")
    PopupMgr.ShowPopup(UIPopupName.UIPopupMultiScrollRewardItem, data)
end

function UIEventAiryuuTrialLayout:OnClickBuyTicket()
    local numberBought = self.eventModel.eventAiryuuTrialData:GetNumberBuy()
    local maxNumberBuy
    ---@type List
    local listTrialVipBonus = self.eventModel.config:GetTrialVipBonusConfig()
    local vipLevel = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).vipLevel
    for _, v in pairs(listTrialVipBonus:GetItems()) do
        if v.vipMin < 0 then
            if vipLevel <= v.vipMax then
                maxNumberBuy = v.numberBuyStamina
            end
        elseif v.vipMax < 0 then
            if vipLevel >= v.vipMin then
                maxNumberBuy = v.numberBuyStamina
            end
        else
            if vipLevel >= v.vipMin and vipLevel <= v.vipMax then
                maxNumberBuy = v.numberBuyStamina
            end
        end
    end

    if numberBought < maxNumberBuy then
        local callback = function(numberReturn, priceTotal)
            local callback = function(result)
                local onSuccess = function()
                    InventoryUtils.Sub(ResourceType.Money, self.staminaData.moneyType, priceTotal)
                    self.eventModel.eventAiryuuTrialData:AddCurrentStamina(numberReturn)
                    self.eventModel.eventAiryuuTrialData:AddNumberBuy(numberReturn)
                    numberBought = numberBought + numberReturn
                    self:AddChallengeTicket(numberReturn)
                end
                local onFailed = function(logicCode)
                    SmartPoolUtils.LogicCodeNotification(logicCode)
                end
                NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
            end
            NetworkUtils.Request(OpCode.EVENT_HERO_AIRYUU_BUY_STAMINA, UnknownOutBound.CreateInstance(PutMethod.Int, numberReturn), callback)
        end
        ---@type PopupBuyItemData
        local dataPurchase = PopupBuyItemData()
        dataPurchase:SetData(ResourceType.Money, self.staminaData.moneyType, 1, 1, maxNumberBuy - numberBought,
                self.staminaData.moneyType, self.staminaData.moneyValue,
                callback, LanguageUtils.LocalizeCommon("buy_turn"),
                LanguageUtils.LocalizeCommon("buy"), false)

        PopupMgr.ShowPopup(UIPopupName.UIPopupBuyItemString, dataPurchase)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_buy_turn_daily"))
    end
end

function UIEventAiryuuTrialLayout:AddChallengeTicket(value)
    self:SetChallengeTicket(self.currentStamina + value)
end

function UIEventAiryuuTrialLayout:SetChallengeTicket(value)
    local defaultStamina = self.staminaData.dailyFree
    self.currentStamina = value or self.eventModel.eventAiryuuTrialData:GetCurrentStamina()
    if value ~= nil then
        self.lastStamina = nil
    end
    if self.currentStamina < 0 then
        self.currentStamina = 0
    end
    if self.currentStamina > 0 then
        self.layoutConfig.ticketNumber.text = string.format("%s %s/%s", LanguageUtils.LocalizeCommon("remaining_attempts"), UIUtils.SetColorString(UIUtils.green_light, self.currentStamina), UIUtils.SetColorString(UIUtils.green_light, defaultStamina))
    else
        self.layoutConfig.ticketNumber.text = string.format("%s %s/%s", LanguageUtils.LocalizeCommon("remaining_attempts"), UIUtils.SetColorString(UIUtils.red_light, self.currentStamina), UIUtils.SetColorString(UIUtils.green_light, defaultStamina))
    end
end

function UIEventAiryuuTrialLayout:OnClickChallenge()
    if self.currentStamina > 0 then
        self:ShowFormation()
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("out_of_turn"))
    end
end

function UIEventAiryuuTrialLayout:ShowFormation()
    --- @type {gameMode, battleTeamInfo, callbackPlayBattle, callbackClose}
    local result = {}
    result.gameMode = GameMode.EVENT_AIRYUU_TRIAL
    result.battleTeamInfo = self.battleTeamInfo
    result.powerDefenderTeam = self.enemyTeamData.powerTeam
    result.callbackClose = function()
        PopupMgr.HidePopup(UIPopupName.UIFormation)
        local data = {}
        data.tab = EventAiryuuTab.HERO_TRIAL
        data.isAdded = true
        PopupMgr.ShowPopup(UIPopupName.UIEventAiryuu, data)
    end
    result.callbackPlayBattle = function(uiFormationTeamData, callback)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            --- @type EventAiryuuTrialInBound
            self.listChallengeReward = EventAiryuuTrialInBound(buffer)
        end
        local callbackSuccess = function()
            zg.playerData.rewardList = RewardInBound.GetItemIconDataList(self.listChallengeReward:GetChallengeReward())
            zg.playerData:AddListRewardToInventory()
            zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
            self.currentStamina = self.currentStamina - 1
            self.lastStamina = self.currentStamina
            self.eventModel.eventAiryuuTrialData:SubCurrentStamina(1)
            if callback ~= nil then
                callback()
            end
        end
        local difficulty = self.layoutConfig.slider.value
        NetworkUtils.RequestAndCallback(OpCode.EVENT_HERO_AIRYUU_CHALLENGE,
                EventAiryuuTrialOutBound(difficulty, uiFormationTeamData),
                callbackSuccess,
                SmartPoolUtils.LogicCodeNotification, onBufferReading)
    end
    PopupMgr.HidePopup(UIPopupName.UIEventAiryuu)
    PopupMgr.ShowPopup(UIPopupName.UIFormation, result)
end

function UIEventAiryuuTrialLayout:GetEnemyDefenderTeamData(value)
    self.enemyTeamId = self.eventModel.eventAiryuuTrialData:GetEnemyDefenderTeamDataByDifficulty(value)
    self.enemyTeamData = self.eventModel.config:GetTrialDefenderTeamConfigByDifficultyAndId(value, self.enemyTeamId)
    self.enemyTeamDetail = self.enemyTeamData.defenderTeamData
    if self.enemyTeamDetail ~= nil then
        self.layoutConfig.powerNumber.text = self.enemyTeamData.powerTeam
        ---@type BattleTeamInfo
        self.battleTeamInfo = self.enemyTeamData.battleTeamInfor
        self:InnitFormation(self.battleTeamInfo:GetListHero(), self.battleTeamInfo)
        self.uiScroll:Resize(self.battleTeamInfo:GetListHero():Count())
    end
end

---@param listHero List
function UIEventAiryuuTrialLayout:InnitFormation(listHero, battleTeamInfo)
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
    ---@param obj HeroIconView
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        local hero = listHero:Get(dataIndex)
        hero.type = ResourceType.Hero
        hero.faction = ClientConfigUtils.GetFactionIdByHeroId(hero.heroId)
        obj:SetIconData(hero)
        obj:EnableButton()
        obj:RegisterShowInfo()
        local heroResource = HeroResource()
        heroResource:SetData(-1, hero.heroId, hero.star, hero.level)

        ClientConfigUtils.RequireBattleTeam(battleTeamInfo)
        local teamPowerCalculator = TeamPowerCalculator()
        teamPowerCalculator:SetDefenderTeamInfo(battleTeamInfo)
        --- @type Dictionary -- <number, number>
        local powerMap = teamPowerCalculator:CalculatePowerDetail(ResourceMgr.GetServiceConfig():GetBattle(),
                ResourceMgr.GetServiceConfig():GetHeroes(), battleTeamInfo.teamId)

        local result = {}
        result.heroResource = heroResource
        result.power = powerMap:Get(dataIndex)
        obj:AddListener(function()
            PopupMgr.ShowPopup(UIPopupName.UIHeroSummonInfo, result)
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.formationScroll, UIPoolType.HeroIconView, onCreateItem)
end

--- @param battleTeamInfo BattleTeamInfo
function UIEventAiryuuTrialLayout:ShowEnemyFormation(battleTeamInfo)
    self.battleTeamView:Show()
    self.battleTeamView:SetDataDefender(UIPoolType.HeroIconView, battleTeamInfo, nil, nil, true)
    self.battleTeamView.uiTeamView:SetSummonerInfo()
    self.battleTeamView.uiTeamView:ActiveBuff(false)
    self.battleTeamView.uiTeamView:ActiveLinking(false)
end

function UIEventAiryuuTrialLayout:ShowMainHeroAiryuuAndSkillData()
    self.layoutConfig.iconHero.gameObject:SetActive(true)
    ---@type ListSkillView
    self.listSkillView = ListSkillView(self.layoutConfig.skillParent, U_Vector2(0, 0), self.layoutConfig.detailSkillPosition)
    ---@type HeroResource
    local heroResource = HeroResource()

    if self.worldSpaceHeroView == nil then
        ---@type UnityEngine_Transform
        local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
        self.worldSpaceHeroView = WorldSpaceHeroView(trans)
        local renderTexture = U_RenderTexture(1600, 1000, 24, U_RenderTextureFormat.ARGB32)
        self.layoutConfig.iconHero.texture = renderTexture
        self.worldSpaceHeroView:Init(renderTexture)
        self.worldSpaceHeroView:SetDefaultHeroScale()
    end
    local data = self.eventModel.config:GetTrialHeroAiryuuConfig()
    heroResource:SetData(-1, data.heroId, data.heroStar, 1)

    self.worldSpaceHeroView:ShowHero(heroResource)
    self.worldSpaceHeroView.config.transform.position = U_Vector3(11000, 11000, 0)
    self.worldSpaceHeroView.config.bg:SetActive(false)
    self.worldSpaceHeroView.previewHero.clientHero:InitAnimationComponent()

    self.layoutConfig.buttonHero.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self.worldSpaceHeroView.previewHero.clientHero.animation:ClearTracks()
        self.worldSpaceHeroView.previewHero.clientHero.animation:SetToSetupPose()
        self.worldSpaceHeroView.previewHero.clientHero.animation:PlayAnimationWithCallback(AnimationConstants.ATTACK_ANIM, function()
            self.worldSpaceHeroView.previewHero.clientHero:PlayIdleAnimation()
        end, true)
    end)

    ---Show skill hero
    self.listSkillView:SetDataHero(heroResource, false)

    self.layoutConfig.heroNameTxt.text = LanguageUtils.LocalizeNameHero(heroResource.heroId)
    self.layoutConfig.iconFaction.sprite = ResourceLoadUtils.LoadFactionIcon(ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId))
end

function UIEventAiryuuTrialLayout:OnShow()
    UIEventAiryuuLayout.OnShow(self)
    self.anchor.gameObject:SetActive(true)
    self:NeedResetLayout()
    self.staminaData = self.eventModel.config:GetTrialStaminaConfig()
    self:SetChallengeTicket(self.lastStamina)
    self:GetEnemyDefenderTeamData(self.layoutConfig.slider.value)
    self:ShowMainHeroAiryuuAndSkillData()
    if self.isLastFormDragon then
        self:OnClickButtonTransform()
    end
end

function UIEventAiryuuTrialLayout:NeedResetLayout()
    local currentPlayerId = PlayerSettingData.playerId
    local currentSeverId = PlayerSettingData.serverId
    if currentPlayerId ~= self.lastPlayerId then
        self.layoutConfig.slider.value = 1
        self.lastPlayerId = currentPlayerId
    elseif currentSeverId ~= self.lastServerId then
        self.layoutConfig.slider.value = 1
        self.lastServerId = currentSeverId
    end
end

function UIEventAiryuuTrialLayout:SetUpLayout()
    UIEventAiryuuLayout.SetUpLayout(self)
end

function UIEventAiryuuTrialLayout:OnHide()
    UIEventAiryuuLayout.OnHide(self)
    self.listSkillView:ReturnPool()
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end
    self.uiScroll:Hide()
    if self.battleTeamView ~= nil then
        self.battleTeamView:Hide()
    end
end

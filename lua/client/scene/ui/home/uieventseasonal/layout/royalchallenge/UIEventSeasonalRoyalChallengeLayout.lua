--- @class UIEventSeasonalRoyalChallengeLayout : UIEventSeasonalLayout
UIEventSeasonalRoyalChallengeLayout = Class(UIEventSeasonalRoyalChallengeLayout, UIEventSeasonalLayout)

local SINGLE_CHALLENGE = 1

--- @param view UIEventSeasonalView
--- @param anchor UnityEngine_RectTransform
function UIEventSeasonalRoyalChallengeLayout:Ctor(view, tab, anchor)
    self.tab = tab
    --- @type UIEventSeasonalView
    self.view = view
    ---@type UIEventSeasonalRoyalChallengeLayoutConfig
    self.layoutConfig = nil
    ---@type Dictionary
    self.loginRewardDict = Dictionary()
    --- @type EventSeasonalConfig
    self.eventConfig = nil
    ---@type UILoopScroll
    self.uiScroll = nil
    ---@type WorldSpaceHeroView
    self.worldSpaceHeroView = nil
    --- @type ListSkillView
    self.listSkillView = nil
    ---@type number
    self.bossId = nil
    --- @type {moneyType, moneyValue, maxNumberBuy, numberStaminaDefault}
    self.staminaConfig = nil
    ---@type RewardInBound
    self.staminaInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.SEASONAL_BOSS_TICKET, SINGLE_CHALLENGE)
    UIEventSeasonalLayout.Ctor(self, view, tab, anchor)
end

function UIEventSeasonalRoyalChallengeLayout:SetUpLayout()
    UIEventSeasonalLayout.SetUpLayout(self)
end

function UIEventSeasonalRoyalChallengeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_seasonal_royal_challenge_layout", self.anchor)
    UIEventSeasonalLayout.InitLayoutConfig(self, inst)
    self.listSkillView = ListSkillView(self.layoutConfig.anchorBossSkill, U_Vector2(0.5, 0), self.layoutConfig.posSkillPreview)
    self:InitUpdateTime()
    self:InitEventConfigData()
    self:InitEventConfigData()
    self:InitScroll()
end

function UIEventSeasonalRoyalChallengeLayout:InitLocalization()
    UIEventSeasonalLayout.InitLocalization(self)
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("seasonal_royal_challenge")
    self.layoutConfig.textChallenge.text = LanguageUtils.LocalizeCommon("challenge")
    self.layoutConfig.textRewardTitle.text = LanguageUtils.LocalizeCommon("reward")
end

function UIEventSeasonalRoyalChallengeLayout:InitMoneyBar()
    --- @type List
    self.listMoneyBar = List()
    ---@type MoneyBarView
    local moneyBarView1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
    moneyBarView1:SetIconData(MoneyType.EVENT_SEASONAL_MONEY)
    moneyBarView1.config.buttonInfo.interactable = true
    moneyBarView1.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView1:SetSize(0, 0)
    moneyBarView1.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView1:ShowInfo()
    end)
    moneyBarView1:AddListener(function()
        self.view:SelectTab(EventSeasonalTab.FIREWORK_SHOP)
    end)
    ---@type MoneyBarView
    local moneyBarView2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
    moneyBarView2:SetIconData(MoneyType.EVENT_SEASONAL_GUN_POWER)
    moneyBarView2.config.buttonInfo.interactable = true
    moneyBarView2.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView2:SetSize(0, 0)
    moneyBarView2.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView2:ShowInfo()
    end)
    moneyBarView2:AddListener(function()
        self.view:SelectTab(EventSeasonalTab.FIREWORK_SHOP)
    end)
    self.listMoneyBar:Add(moneyBarView1)
    self.listMoneyBar:Add(moneyBarView2)
end

function UIEventSeasonalRoyalChallengeLayout:ReturnPoolMoneyBar()
    ---@param v MoneyBarView
    for _, v in pairs(self.listMoneyBar:GetItems()) do
        v:ReturnPool()
    end
    self.listMoneyBar:Clear()
end

function UIEventSeasonalRoyalChallengeLayout:InitButtonListener()
    self.layoutConfig.backButton.onClick:AddListener(function()
        self:CloseLayout()
    end)
    self.layoutConfig.buttonInfor.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_seasonal_info"))
    end)
    self.layoutConfig.buttonBuyStamina.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuyStamina()
    end)
    self.layoutConfig.buttonChallenge.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChallenge()
    end)
    self.layoutConfig.buttonLeaderBoard.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLeaderBoard()
    end)
end

function UIEventSeasonalRoyalChallengeLayout:OnShow()
    UIEventSeasonalLayout.OnShow(self)
    self.anchor.gameObject:SetActive(true)
    self:SetEndEventTime(self.view:_GetEventEndTime(), function()
        self:OnEventTimeEnded()
    end)
    self:InitEventConfigData()
    self:ShowBoss()
    self:ShowUiBuyStamina()
    self:ResizeScroll()
end

---------------------------------------InitHero----------------------------------------

function UIEventSeasonalRoyalChallengeLayout:ShowBoss()
    --- @type {heroId, skinId}
    local bossData = self.eventConfig:GetChallengeHeroData()
    self.heroId = bossData.heroId

    self.layoutConfig.factionIcon.sprite = ResourceLoadUtils.LoadFactionIcon(ClientConfigUtils.GetFactionIdByHeroId(self.heroId))
    self.layoutConfig.heroName.text = LanguageUtils.LocalizeNameHero(self.heroId)

    self.listSkillView:SetDataHero(HeroResource.CreateInstance(nil, self.heroId, 13, 1), false)
    if self.worldSpaceHeroView == nil then
        ---@type UnityEngine_Transform
        local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
        self.worldSpaceHeroView = WorldSpaceHeroView(trans)
        local renderTexture = U_RenderTexture(1000, 1000, 24, U_RenderTextureFormat.ARGB32)
        self.layoutConfig.iconHero.texture = renderTexture
        self.worldSpaceHeroView:Init(renderTexture)
    end
    local heroResource = HeroResource()
    heroResource:SetData(-1, self.heroId, 13, 1)
    if bossData.skinId ~= nil then
        heroResource.heroItem:Add(HeroItemSlot.SKIN, bossData.skinId)
    end
    self.layoutConfig.iconHero.gameObject:SetActive(true)
    self.worldSpaceHeroView:ShowHero(heroResource)
    self.worldSpaceHeroView.config.heroAnchor.localScale = U_Vector3(1, 1, 1)
    self.worldSpaceHeroView.config.heroAnchor.localPosition = U_Vector3(0, -1.77, 0)
    self.worldSpaceHeroView.config.bg:SetActive(false)
end

---------------------------------------ScrollReward----------------------------------------

function UIEventSeasonalRoyalChallengeLayout:InitScroll()
    local dict = self.eventConfig:GetBossDamageRewardConfig()
    local onCreateItem = function(obj, index)
        ---@type  BossChallengeRewardMilestoneData
        local bossMilestoneReward = dict:Get(index + 1)
        obj:SetIconData(bossMilestoneReward.listInstantReward, bossMilestoneReward.listAllReward, index + 1)
    end
    self.scrollReward = UILoopScroll(self.layoutConfig.scroll, UIPoolType.ChestFindeItemView, onCreateItem)
end

function UIEventSeasonalRoyalChallengeLayout:ResizeScroll()
    local dict = self.eventConfig:GetBossDamageRewardConfig()
    self.scrollReward:Resize(dict:Count())
end

function UIEventSeasonalRoyalChallengeLayout:ReturnPoolScroll()
    self.scrollReward:Hide()
end

function UIEventSeasonalRoyalChallengeLayout:ReturnPoolBoss()
    if self.listSkillView then
        self.listSkillView:ReturnPool()
    end
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView.config.heroAnchor.localScale = U_Vector3(1.3, 1.3, 1)
        self.worldSpaceHeroView.config.heroAnchor.localPosition = U_Vector3(0, -1.28, 0)
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
        self.layoutConfig.iconHero.gameObject:SetActive(false)
    end
end
---------------------------------------LeaderBoard----------------------------------------

function UIEventSeasonalRoyalChallengeLayout:OnClickLeaderBoard()
    PopupMgr.ShowPopup(UIPopupName.UIEventSeasonalBossLeaderboard)
end

---------------------------------------BuyStamina----------------------------------------

function UIEventSeasonalRoyalChallengeLayout:InitEventConfigData()
    self.staminaConfig = self.eventConfig:GetChallengeStaminaConfig()
end

function UIEventSeasonalRoyalChallengeLayout:OnClickBuyStamina()
    local maxCountBuyTurn = self.staminaConfig.maxNumberBuy - self.eventModel:GetNumberBuyStamina()
    if maxCountBuyTurn > 0 then
        local callback = function(numberBuy, priceTotal)
            local onSuccess = function()
                InventoryUtils.Sub(ResourceType.Money, self.staminaConfig.moneyType, priceTotal)
                InventoryUtils.Add(ResourceType.Money, self.staminaInBound.id, numberBuy)
                self.eventModel:AddNumberBuyStamina(numberBuy)
                self:ShowUiBuyStamina()
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("success"))
            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            NetworkUtils.RequestAndCallback(OpCode.EVENT_SEASONAL_BOSS_STAMINA_BUY, UnknownOutBound.CreateInstance(PutMethod.Byte, numberBuy), onSuccess, onFailed)
        end
        ---@type PopupBuyItemData
        local dataPurchase = PopupBuyItemData()
        dataPurchase:SetData(ResourceType.Money, self.staminaConfig.moneyType, 1, 1, maxCountBuyTurn,
                self.staminaConfig.moneyType, self.staminaConfig.moneyValue,
                callback, LanguageUtils.LocalizeCommon("buy_turn"),
                LanguageUtils.LocalizeCommon("buy"), false)

        PopupMgr.ShowPopup(UIPopupName.UIPopupBuyItemString, dataPurchase)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_buy_turn_daily"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

function UIEventSeasonalRoyalChallengeLayout:ShowUiBuyStamina()
    self.layoutConfig.textStamina.text = string.format("%s %s/%s", LanguageUtils.LocalizeCommon("remaining_attempts"),
            InventoryUtils.Get(ResourceType.Money, self.staminaInBound.id),
            self.staminaConfig.numberStaminaDefault)
end

---------------------------------------Challenge----------------------------------------

function UIEventSeasonalRoyalChallengeLayout:OnClickChallenge()
    if zg.timeMgr:GetRemainingTime() < self.eventConfig:GetChallengeConfig().blockDuration then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("wait_next_day"))
    else
        if InventoryUtils.IsEnoughSingleResourceRequirement(self.staminaInBound, false) then
            self:ShowFormation()
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("out_of_turn"))
        end

    end
end

--- @return void
function UIEventSeasonalRoyalChallengeLayout:ShowFormation()
    ---@type DefenderTeamData
    local dataStage = self.eventConfig:GetDefenderTeamData()
    ---@type BattleTeamInfo
    local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(dataStage)
    --- @type {gameMode, battleTeamInfo, callbackPlayBattle, callbackClose}
    local result = {}
    result.gameMode = GameMode.EVENT_SEASONAL_ROYAL_CHALLENGE
    result.battleTeamInfo = battleTeamInfo
    result.powerDefenderTeam = dataStage:GetPowerTeam()
    result.callbackClose = function()
        PopupMgr.HidePopup(UIPopupName.UIFormation)
        local data = {}
        data.tab = EventSeasonalTab.ROYAL_CHALLENGE
        PopupMgr.ShowPopup(UIPopupName.UIEventSeasonal, data)
    end
    result.callbackPlayBattle = function(uiFormationTeamData, callback)
        --- @type ChristmasChallengeBossInBound
        local christmasChallengeBossInBound
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            require "lua.client.core.network.event.eventXmasModel.ChristmasChallengeBossInBound"
            christmasChallengeBossInBound = ChristmasChallengeBossInBound(buffer)
        end
        local callbackSuccess = function()
            InventoryUtils.SubSingleRewardInBound(self.staminaInBound)
            zg.playerData.rewardList = RewardInBound.GetItemIconDataList(christmasChallengeBossInBound:GetListReward())
            zg.playerData:AddListRewardToInventory()
            zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
            if callback ~= nil then
                callback()
            end
        end
        NetworkUtils.RequestAndCallback(OpCode.EVENT_SEASONAL_BOSS_CHALLENGE,
                BattleFormationOutBound(uiFormationTeamData), callbackSuccess,
                SmartPoolUtils.LogicCodeNotification, onBufferReading)
    end
    PopupMgr.HidePopup(self.view.model.uiName)
    PopupMgr.ShowPopup(UIPopupName.UIFormation, result)
end

---------------------------------------End----------------------------------------


function UIEventSeasonalRoyalChallengeLayout:OnHide()
    UIEventSeasonalLayout.OnHide(self)
    self:RemoveUpdateTime()
    self:ReturnPoolBoss()
    self:ReturnPoolScroll()
end

function UIEventSeasonalRoyalChallengeLayout:GetEventEndTime()
    return self.eventModel.timeData.endTime
end

--- @param onEventTimeEnded function
function UIEventSeasonalRoyalChallengeLayout:SetEndEventTime(endTime, onEventTimeEnded)
    self.endTime = endTime
    self.onEventTimeEnded = onEventTimeEnded
    self:StartUpdateTime()
end

--- @param eventTimeType EventTimeType
function UIEventSeasonalRoyalChallengeLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventSeasonalRoyalChallengeLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventSeasonalRoyalChallengeLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventSeasonalRoyalChallengeLayout:SetTimeRefresh()
    self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
end

function UIEventSeasonalRoyalChallengeLayout:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.layoutConfig.textEventTime.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end

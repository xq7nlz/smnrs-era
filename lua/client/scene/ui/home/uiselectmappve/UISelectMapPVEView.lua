require "lua.client.core.network.campaign.CampaignReceiveItemInBound"
require "lua.client.scene.ui.common.UIBarPercentView"

require "lua.client.battleShow.ClientBattleShowController"
require "lua.client.scene.ui.home.uiSelectMapPVE.BattleSelectMapController"

require "lua.client.data.CampaignData.CampaignData"
local TUT_PATH = "csv/tutorial/battle_show.csv"
--- @class UISelectMapPVEView : UIBaseView
UISelectMapPVEView = Class(UISelectMapPVEView, UIBaseView)

--- @return void
--- @param model UISelectMapPVEModel
function UISelectMapPVEView:Ctor(model)
    self.campaignDataConfig = ResourceMgr.GetCampaignDataConfig()
    --- @type BattleSelectMapController
    self.battleSelectMapController = nil
    --- @type UISelectMapPVEConfig
    self.config = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type function
    self.coroutineMoney = nil
    --- @type function
    self.coroutineItem = nil
    ---@type CampaignData
    self.campaignData = nil

    ---@type List
    self.listStage = List()

    --- @type MoneyBarView
    self.goldBarView = nil
    --- @type MoneyBarView
    self.magicPotionBarView = nil

    ---@type UnityEngine_GameObject
    self.particleGold = nil

    ---@type boolean
    self.fromBattleScreen = false
    -- init variables here
    UIBaseView.Ctor(self, model)
    --- @type UISelectMapPVEModel
    self.model = self.model
end

--- @return void
function UISelectMapPVEView:OnReadyCreate()
    ---@type UISelectMapPVEConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:InitAutoTimeBar()
    self:InitButtonListener()
    self:InitScrollView()
    self:InitParticleGold()
    self:InitUpdateTime()
end

function UISelectMapPVEView:OnClickBackOrClose()
    self:OnReadyHide()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
end

function UISelectMapPVEView:InitParticleGold()
    self.particleGold = ResourceLoadUtils.LoadUIEffect("fx_ui_treasure_claim", self.config.transform)
    self.particleGold.transform.position = self.config.goldRoot.transform.position
    self.particleGold:SetActive(false)
end

function UISelectMapPVEView:InitAutoTimeBar()
    --- @type UIBarPercentView
    self.autoTimeBar = UIBarPercentView(self.config.autoTimeBar)
    self.autoTimeBar.callback = function(time)
        local maxTimeIdle = self.campaignDataConfig:GetMaxTimeIdle()
        if time > maxTimeIdle then
            self.autoTimeBar:SetText(LanguageUtils.LocalizeCommon("max"))
            self.autoTimeBar:SetValue(1)
            self:StopTimeIdle()
        else
            self.autoTimeBar:SetText(TimeUtils.SecondsToClock(time))
            self.autoTimeBar:SetValue(time / maxTimeIdle)
        end
    end
end

function UISelectMapPVEView:InitButtonListener()
    self.config.buttonBattle.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBattle()
    end)

    if self.config.buttonTutorial ~= nil then
        self.config.buttonTutorial.onClick:AddListener(function()
            self:OnClickHelpInfo()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        end)
    end

    self.config.buttonTeam.onClick:AddListener(function()
        self:OnClickButtonTeam()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)

    self.config.buttonMap.onClick:AddListener(function()
        self:OnClickButtonMap()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)

    self.config.buttonQuickBattle.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickQuickBattle()
    end)

    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)

    self.config.buttonLeaderBoard.onClick:AddListener(function()
        self:_OnClickShowLeaderBoard()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)

    self.config.buttonQuickGold.onClick:AddListener(function()
        self:OnClickQuickBattleTicket(ResourceType.Money, MoneyType.GOLD)
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)

    self.config.buttonQuickMagicPotion.onClick:AddListener(function()
        self:OnClickQuickBattleTicket(ResourceType.Money, MoneyType.MAGIC_POTION)
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)

    self.config.buttonQuickExp.gameObject:SetActive(false)
    self.config.buttonQuickExp.onClick:AddListener(function()
        self:OnClickQuickBattleTicket(ResourceType.SummonerExp, 0)
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function UISelectMapPVEView:InitScrollView()
    --- @param obj UIButtonStageView
    --- @param index number
    local onUpdateItem = function(obj, index)
        obj:SetState()
    end
    --- @param obj UIButtonStageView
    --- @param index number
    local onCreateItem = function(obj, index)
        if not self.listStage:IsContainValue(obj) then
            self.listStage:Add(obj)
        end
        local stageId = self:GetStageId(self.campaignData.currentDifficultLevel, self.campaignData.currentMapId, index + 1)
        obj:SetStageId(stageId)
        obj:AddListener(function()
            self:OnClickStage(stageId)
        end)
        onUpdateItem(obj, index)
    end
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.UIButtonStageView, onCreateItem, onUpdateItem)
end

--- @return number
function UISelectMapPVEView:CheckFinalStage(stageCount)
    local stageId = self:GetStageId(self.campaignData.currentDifficultLevel, self.campaignData.currentMapId, stageCount)
    ---@type List
    local reward = ResourceMgr.GetCampaignDataConfig():GetCampaignRewardById(stageId)
    local isHeroFragment = false
    ---@param v ItemIconData
    for _, v in pairs(reward:GetItems()) do
        if v.type == ResourceType.HeroFragment then
            isHeroFragment = true
            break
        end
    end
    self.config.textFinalStageReward.text = ""
    if isHeroFragment then
        self.config.textFinalStageReward.text = string.format(UIUtils.SetColorString(UIUtils.white, LanguageUtils.LocalizeCommon("pass_stage_x_get_reward")), UIUtils.SetColorString(UIUtils.red1, stageId))
    end
end

--- @return number
function UISelectMapPVEView:GetStageId(difficultId, mapId, stageId)
    return difficultId * 100000 + mapId * 1000 + stageId
end

--- @return void
function UISelectMapPVEView:InitLocalization()
    self.config.localizeBattle.text = LanguageUtils.LocalizeCommon("battle")
    self.config.localizeMap.text = LanguageUtils.LocalizeCommon("quick_battle")
    self.config.localizeTraining.text = LanguageUtils.LocalizeCommon("training_hero")
end

--- @return void
--- @param stageId number
function UISelectMapPVEView:CallbackAutoBattle(stageId)
    if self.campaignData.stageIdle ~= stageId then
        local onReceived = function(result)
            local onSuccess = function()
                XDebug.Log("AutoBattle success")
            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
        end
        NetworkUtils.Request(OpCode.CAMPAIGN_IDLE_STAGE_CHANGE, UnknownOutBound.CreateInstance(PutMethod.Int, stageId), onReceived)

        self:SetCoroutineCheckMoney()
        self:SetCoroutineCheckItem()

        self.campaignData:SetDataTrainHero()
        self.campaignData:SetStageIdle(stageId)
        self:UpdateUI()
    end
end

--- @return void
function UISelectMapPVEView:UpdateUI()
    self.uiScroll:RefreshCells()
end

--- @return void
function UISelectMapPVEView:UpdateUIIdleMoney()
    --self.config.textGold.text = ClientConfigUtils.FormatNumber(self.model.gold)
    --self.config.textGem.text = ClientConfigUtils.FormatNumber(self.model.magicPotion)
    --self.config.textExp.text = ClientConfigUtils.FormatNumber(self.model.exp)
end

--- @return void
function UISelectMapPVEView:InitBattleShow()
    if self.battleSelectMapController == nil then
        require "lua.client.scene.ui.home.uiSelectMapPVE.BattleSelectMapController"
        self.battleSelectMapController = BattleSelectMapController()
        self.battleSelectMapController:OnCreate()
    end
    zg.battleMgr.clientBattleShowController = self.battleSelectMapController

    self.battleSelectMapController.onClickLootTreasure = function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonLoot()
    end
    self:_CheckRequestTeamCampaignDetailTeamFormation()
end

--- @return void
function UISelectMapPVEView:OnShowDummyBattle()
    self.battleSelectMapController:InitBattleView()
    self:ShowBgAnchor()
end

--- @return void
function UISelectMapPVEView:_InitMoneyBar()
    self.goldBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.goldRoot)
    self.goldBarView:SetIconData(MoneyType.GOLD)

    self.magicPotionBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.magicPotionRoot)
    self.magicPotionBarView:SetIconData(MoneyType.MAGIC_POTION)
end

--- @return void
function UISelectMapPVEView:OnReadyShow(data)
    if (data == nil) then
        self.fromBattleScreen = false
    else
        self.fromBattleScreen = data.fromBattleScreen
    end

    self.campaignData = zg.playerData:GetCampaignData()
    self:_InitMoneyBar()
    local stageCount = ResourceMgr.GetCampaignDataConfig().campaignStageConfig:GetNumberStageByCurrentStage(self.campaignData.stageNext)
    --self:CheckFinalStage(stageCount)
    self.config.textFinalStageReward.gameObject:SetActive(false)
    self.uiScroll:SetSize(stageCount)
    if self.campaignData.stageCurrent > 0 then
        local index = self.campaignData.stageNext % 100
        if index < stageCount - 2 then
            -- FIX SCROLL 1-10
            self.uiScroll:RefillCells(MathUtils.Clamp(index - 3, 0, stageCount - 4))
        else
            self.uiScroll:RefillCells(MathUtils.Clamp(index - 2, 0, stageCount - 4))
        end
    else
        self.uiScroll:RefillCells()
    end
    self:InitBattleShow()
    self:OnShowDummyBattle()
    self:StartTimeIdle()
    self:SetCoroutineCheckMoney()
    self:SetCoroutineCheckItem()
    self:UpdateUI()
    self:CheckPassStage()
    self:CheckAllNotification()
    self:CheckShowSoftTutFirstMap()
    self.battleSelectMapController:SetTreasureView(self.timeIdle / self.campaignDataConfig:GetMaxTimeIdle())
    if UIBaseView.IsActiveTutorial() == true then
        local step = UIBaseView.tutorial.currentStep
        if step == TutorialStartGame.stepId then
            self:ShowFakeBattleTutorial()
            self:Hide()
        end
    end
end

function UISelectMapPVEView:CheckShowSoftTutFirstMap()
    self.config.softTutFirstMap.gameObject:SetActive(NotificationCheckUtils.IsCanShowSoftTutBattleCampaignFirstMap())
end

function UISelectMapPVEView:DisableSoftTutFirstMap()
    self.config.softTutFirstMap.gameObject:SetActive(false)
end

--- @return void
function UISelectMapPVEView:ShowFakeBattleTutorial()
    --local tut = TutorialAutoBattle()
    --if tut:CanRunTutorial() then
    --    zg.battleMgr.clientBattleShowController:PauseBattle(false)
    --    UIBaseView.tutorial:InsertTutorial(tut)
    --end
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(TUT_PATH)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", TUT_PATH))
        return
    end
    local attacker = DefenderTeamData(parsedData[1])
    local defender = DefenderTeamData(parsedData[2])
    ---@type BattleTeamInfo
    self.attackerTeam = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(attacker:GetPredefineTeamData(), BattleConstants.ATTACKER_TEAM_ID)
    ---@type BattleTeamInfo
    self.defenderTeam = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(defender)
    ClientBattleData.skipForReplay = true
    zg.playerData.rewardList = nil
    zg.battleMgr:RunCalculatedBattleScene(self.attackerTeam, self.defenderTeam, GameMode.TUT_BATTLE)
end

--- @return void
function UISelectMapPVEView:CheckNotificationQuickBattle()
    self.config.notiQuickBattle:SetActive(ClientConfigUtils.CheckUnlockMinorFeatureAndNotification(MinorFeatureType.CAMPAIGN_QUICK_BATTLE, false)
            and self.campaignData:CanUseQuickBattleFree())
end

--- @return void
function UISelectMapPVEView:CheckNotificationQuickBattle()
    self.config.notiQuickBattle:SetActive(ClientConfigUtils.CheckUnlockMinorFeatureAndNotification(MinorFeatureType.CAMPAIGN_QUICK_BATTLE, false)
            and self.campaignData:CanUseQuickBattleFree())
end

--- @return void
function UISelectMapPVEView:CheckNotificationTraining()
    self:RemoveCheckNotificationTraining()
    if ClientConfigUtils.CheckUnlockMinorFeatureAndNotification(MinorFeatureType.CAMPAIGN_AUTO_TRAIN, false) then
        local timeNoti = zg.playerData:GetCampaignData():GetTimeFinishTraining()
        if timeNoti > 0 then
            self.config.notiTraining:SetActive(false)
            self.coroutineNotiTraining = Coroutine.start(function()
                coroutine.waitforseconds(timeNoti)
                self.config.notiTraining:SetActive(true)
            end)
        else
            self.config.notiTraining:SetActive(true)
        end
    else
        self.config.notiTraining:SetActive(false)
    end
end

--- @return void
function UISelectMapPVEView:RemoveCheckNotificationTraining()
    if self.coroutineNotiTraining ~= nil then
        Coroutine.stop(self.coroutineNotiTraining)
    end
end

--- @return void
function UISelectMapPVEView:CheckAllNotification()
    self:CheckNotificationTraining()
    self:CheckNotificationQuickBattle()
end

--- @return void
function UISelectMapPVEView.GetIdleRewardStage(stage)
    --- @type VipData
    local vip = ResourceMgr.GetVipConfig():GetCurrentBenefits()
    ---@type List
    local listIdle = ResourceMgr.GetIdleRewardConfig():GetIdleMoney(stage)
    ---@type number
    local gold, magicPotion, exp = 0, 0, 0
    ---@param v IdleMoneyConfig
    for _, v in pairs(listIdle:GetItems()) do
        if v.number ~= nil then
            if v.typeId == ResourceType.Money then
                if v.id == MoneyType.GOLD and v.number ~= nil then
                    gold = v.number * (1 + vip.campaignBonusGold)
                elseif v.id == MoneyType.MAGIC_POTION then
                    magicPotion = v.number * (1 + vip.campaignBonusMagicPotion)
                end
            else
                exp = v.number * (1 + vip.campaignBonusExpSummoners)
            end
        end
    end
    return gold, magicPotion, exp
end

--- @return void
function UISelectMapPVEView:CheckPassStage()
    if self.coroutineIdleInfo ~= nil then
        Coroutine.stop(self.coroutineIdleInfo)
    end
    self.config.idleGold.gameObject:SetActive(false)
    self.config.idleMagicPotion.gameObject:SetActive(false)
    self.config.idleExp.gameObject:SetActive(false)
    if self.campaignData.lastStage ~= nil and self.campaignData.lastStage ~= self.campaignData.stageIdle then
        ---@param idleInfo UIIdleRewardInfoConfig
        local setIdleInfo = function(idleInfo, before, after)
            idleInfo.bg:SetActive(false)
            idleInfo.animator.enabled = false
            idleInfo.before.text = string.format("+%s/5s", before)
            idleInfo.after.text = string.format("+%s/5s", after)
        end

        ---@type number
        local gold1, magicPotion1, exp1 = 0, 0, 0
        if self.campaignData.lastStage > 0 then
            gold1, magicPotion1, exp1 = UISelectMapPVEView.GetIdleRewardStage(self.campaignData.lastStage)
        end
        ---@type number
        local gold2, magicPotion2, exp2 = UISelectMapPVEView.GetIdleRewardStage(self.campaignData.stageIdle)
        if self.idleGold == nil then
            ---@type UIIdleRewardInfoConfig
            self.idleGold = UIBaseConfig(self.config.idleGold)
        end
        if self.idleMagicPotion == nil then
            ---@type UIIdleRewardInfoConfig
            self.idleMagicPotion = UIBaseConfig(self.config.idleMagicPotion)
        end
        if self.idleExp == nil then
            ---@type UIIdleRewardInfoConfig
            self.idleExp = UIBaseConfig(self.config.idleExp)
        end

        if gold1 ~= gold2 then
            setIdleInfo(self.idleGold, gold1, gold2)
            self.config.idleGold.gameObject:SetActive(true)
        end
        if magicPotion1 ~= magicPotion2 then
            setIdleInfo(self.idleMagicPotion, magicPotion1, magicPotion2)
            self.config.idleMagicPotion.gameObject:SetActive(true)
        end
        if exp1 ~= exp2 then
            setIdleInfo(self.idleExp, exp1, exp2)
            self.config.idleExp.gameObject:SetActive(true)
        end

        self.coroutineIdleInfo = Coroutine.start(function()
            coroutine.waitforseconds(1.5)
            local step = 0.2
            if gold1 ~= gold2 then
                coroutine.waitforseconds(step)
                self.idleGold.animator.enabled = true
            end
            if magicPotion1 ~= magicPotion2 then
                coroutine.waitforseconds(step)
                self.idleMagicPotion.animator.enabled = true
            end
            if exp1 ~= exp2 then
                coroutine.waitforseconds(step)
                self.idleExp.animator.enabled = true
            end
        end)

    end
    self.campaignData.lastStage = self.campaignData.stageIdle
end

--- @return void
function UISelectMapPVEView:CheckSingleTutorial()
    ---@type number
    local stageIdle = self.campaignData.stageIdle
    ---@type number
    local step
    if stageIdle == 101010 then
        step = TutorialHeroFragment.stepId
    elseif stageIdle == 104025 then
        step = TutorialEvolveSummoner.stepId
    end
    if step ~= nil and zg.playerData:GetMethod(PlayerDataMethod.TUTORIAL).listStepTutComplete:IsContainValue(step) == false then
        XDebug.Log("Show UITutorial: " .. step)
        PopupMgr.ShowPopup(UIPopupName.UITutorial, { ["step"] = step })
    end
end

--- @return void
function UISelectMapPVEView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self:CheckAndInitTutorial()
    self:CheckSingleTutorial()
end

function UISelectMapPVEView:ShowBgAnchor()
    local selectBackgroundId = 101
    local stageId = self.campaignData.stageCurrent
    selectBackgroundId = ResourceMgr.GetCampaignDataConfig():GetRandomBgByStage(stageId, 1)
    self.battleSelectMapController:ShowBgAnchor("background_" .. selectBackgroundId, "back_anchor_bot_" .. selectBackgroundId)
end

--- @return boolean
function UISelectMapPVEView:IsAvailableToShowBattle()
    --- @type CampaignDetailTeamFormationInBound
    local inbound = zg.playerData:GetMethod(PlayerDataMethod.CAMPAIGN_DETAIL_FORMATION)
    if inbound ~= nil then
        return inbound.hasDetailTeamFormation and self.campaignData:CanIdle()
    end
    return false
end

--- @return void
function UISelectMapPVEView:Hide()
    UIBaseView.Hide(self)
    self:RemoveCoroutineCheckMoney()
    self:RemoveCoroutineCheckItem()
    self:RemoveCheckNotificationTraining()
    self:DisableSoftTutFirstMap()

    if self.goldBarView ~= nil then
        self.goldBarView:ReturnPool()
        self.goldBarView = nil
    end
    if self.magicPotionBarView ~= nil then
        self.magicPotionBarView:ReturnPool()
        self.magicPotionBarView = nil
    end

    --self.particleGold:SetActive(false)
    --self.particleGem:SetActive(false)
    --self.particleGoldEnd:SetActive(false)
    --self.particleGemEnd:SetActive(false)

    if PopupUtils.IsPopupShowing(UIPopupName.UIStageSelect) then
        PopupMgr.HidePopup(UIPopupName.UIStageSelect)
    end

    self:StopTimeIdle()

    self.battleSelectMapController:OnHide()
    self.uiScroll:Hide()
    self:RemoveListenerTutorial()

    self.particleGold:SetActive(false)
end

function UISelectMapPVEView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self.timeIdle = self.campaignData:GetTotalTimeIdle()
        else
            self.timeIdle = self.timeIdle + 1
        end
        self.autoTimeBar:SetPercent(self.timeIdle)
    end
end

--- @return void
function UISelectMapPVEView:StartTimeIdle()
    self:StopTimeIdle()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

--- @return void
function UISelectMapPVEView:StopTimeIdle()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

----- @return void
function UISelectMapPVEView:InitTimeIdleMoney()
    if self.campaignData:CanIdle() then
        self.model.timeIdleCurrentStageMoney = math.min(self.timeIdle, self.campaignDataConfig:GetMaxTimeIdle())
        self.campaignData:InitTimeIdleMoney(self.model.timeIdleCurrentStageMoney)
    end
end

--- @return void
---@param level number
function UISelectMapPVEView:GetTimeUpToLevel(level)
    local timeUpLevel = 0
    local expEnough = 0
    self:GetMoneyIdle()
    ---@type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    if level > basicInfoInBound.level then
        for i = basicInfoInBound.level + 1, level do
            ---@type MainCharacterExpConfig
            local mainCharacterExp = ResourceMgr.GetMainCharacterConfig().mainCharacterExpDictionary:Get(i)
            expEnough = expEnough + mainCharacterExp.exp
        end
    end
    expEnough = expEnough - (InventoryUtils.Get(ResourceType.SummonerExp, 0) + self.model.exp)
    if expEnough > 0 then
        local idleMoney = ResourceMgr.GetIdleRewardConfig():GetIdleMoney(self.campaignData.stageIdle)
        if idleMoney then
            ---@param idleMoneyConfig IdleMoneyConfig
            for _, idleMoneyConfig in pairs(idleMoney:GetItems()) do
                if idleMoneyConfig.typeId == ResourceType.SummonerExp then
                    timeUpLevel = math.ceil(expEnough / idleMoneyConfig.number) * self.campaignDataConfig:GetTimeRewardMoney()
                end
            end
        end
    end
    return timeUpLevel
end

--- @return void
function UISelectMapPVEView:GetMoneyIdle()
    self.model.gold = 0
    self.model.magicPotion = 0
    self.model.exp = 0
    if self.campaignData:CanIdle() then
        --- @type VipData
        local vip = ResourceMgr.GetVipConfig():GetCurrentBenefits()
        local timeCurrentStage = math.min(self.timeIdle, self.campaignDataConfig:GetMaxTimeIdle())
        timeCurrentStage = self.campaignData:GetTimeCurrentStage(timeCurrentStage)
        --XDebug.Log("timeCurrentStage" .. timeCurrentStage)
        local getResourceStageIdle = function(stageId, timeStage)
            --XDebug.Log(string.format("stage%stime%s", stageId, timeStage))
            if timeStage >= self.campaignDataConfig:GetTimeRewardMoney() then
                local number = math.floor(timeStage / self.campaignDataConfig:GetTimeRewardMoney())
                local idleMoney = ResourceMgr.GetIdleRewardConfig():GetIdleMoney(stageId)
                if idleMoney then
                    ---@param idleMoneyConfig IdleMoneyConfig
                    for _, idleMoneyConfig in pairs(idleMoney:GetItems()) do
                        if idleMoneyConfig.typeId == ResourceType.Money and idleMoneyConfig.id == MoneyType.GOLD then
                            self.model.gold = self.model.gold + idleMoneyConfig.number * (1 + vip.campaignBonusGold) * number
                        elseif idleMoneyConfig.typeId == ResourceType.Money and idleMoneyConfig.id == MoneyType.MAGIC_POTION then
                            self.model.magicPotion = self.model.magicPotion + idleMoneyConfig.number * (1 + vip.campaignBonusMagicPotion) * number
                        elseif idleMoneyConfig.typeId == ResourceType.SummonerExp then
                            self.model.exp = self.model.exp + idleMoneyConfig.number * number
                        end
                    end
                end
            end
        end
        getResourceStageIdle(self.campaignData.stageIdle, timeCurrentStage)
        for stageId, time in pairs(self.campaignData.idleResources.totalTime:GetItems()) do
            if stageId ~= self.campaignData.stageIdle then
                getResourceStageIdle(stageId, time)
            end
        end
    end
    self.model.gold = math.floor(self.model.gold)
    self.model.magicPotion = math.floor(self.model.magicPotion)
    self.model.exp = math.floor(self.model.exp)
    if self.model.gold > 0 or self.model.magicPotion > 0 or self.model.exp > 0 then
        self.model.canClaimMoney = true
    else
        self.model.canClaimMoney = false
    end
end

--- @return void
function UISelectMapPVEView:SetCoroutineCheckMoney()
    if self.campaignData:CanIdle() then
        self:RemoveCoroutineCheckMoney()
        self.coroutineMoney = Coroutine.start(function()
            while true do
                --self:InitTimeIdleMoney()
                self:GetMoneyIdle()
                self:UpdateUIIdleMoney()
                coroutine.waitforseconds(self.campaignDataConfig:GetTimeRewardMoney())
                if self.campaignData ~= nil then
                    if self.timeIdle > self.campaignDataConfig:GetMaxTimeIdle() + self.campaignDataConfig:GetTimeRewardMoney() then
                        self:RemoveCoroutineCheckMoney()
                    end
                else
                    XDebug.Error("self.campaignData == nil")
                    self:RemoveCoroutineCheckMoney()
                end
            end
        end)
    end
end

--- @return void
function UISelectMapPVEView:RemoveCoroutineCheckMoney()
    if self.coroutineMoney ~= nil then
        Coroutine.stop(self.coroutineMoney)
        self.coroutineMoney = nil
    end
end

----- @return void
function UISelectMapPVEView:InitTimeIdleItem()
    if self.campaignData:CanIdle() then
        self.model.timeIdleCurrentStageItem = math.min(self.timeIdle, self.campaignDataConfig:GetMaxTimeIdle())
        self.campaignData:InitTimeIdleItem(self.model.timeIdleCurrentStageItem)
    end
end

--- @return number
function UISelectMapPVEView:GetTimeToLootItem()
    local timeToLoot = self.campaignData:GetTimeToLootItem()
    self.model.canLootItem = (timeToLoot <= 0)
    --self.config.notiLoot.gameObject:SetActive(self.model.canLootItem)
    return timeToLoot
end

--- @return void
function UISelectMapPVEView:SetCoroutineCheckItem()
    if self.campaignData:CanIdle() then
        self:RemoveCoroutineCheckItem()
        local timeToLootItem = self:GetTimeToLootItem()
        if timeToLootItem > 0 then
            self.coroutineItem = Coroutine.start(function()
                coroutine.waitforseconds(timeToLootItem)
                self:GetTimeToLootItem()
            end)
        end
    end
end

--- @return void
function UISelectMapPVEView:RemoveCoroutineCheckItem()
    if self.coroutineItem ~= nil then
        Coroutine.stop(self.coroutineItem)
        self.coroutineItem = nil
    end
end

--- @return void
function UISelectMapPVEView:OnClickButtonHero()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIHeroCollection, { ["callbackClose"] = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UISelectMapPVE, nil, UIPopupName.UIHeroCollection)
    end }, UIPopupName.UISelectMapPVE
    )
end

--- @return void
function UISelectMapPVEView:OnClickBattle()
    local levelRequired = ResourceMgr.GetCampaignDataConfig():GetLevelRequired(self.campaignData.stageNext)
    ---@type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    if levelRequired == nil or basicInfoInBound.level >= levelRequired then
        UISelectMapPVEView.ShowFormation(self.fromBattleScreen)
    else
        local notification = string.format(LanguageUtils.LocalizeCommon("require_level_x"),
                UIUtils.SetColorString(UIUtils.color7, levelRequired)) .. ".n"

        local timeUpLevel = self:GetTimeUpToLevel(levelRequired)
        local maxTime = self.campaignDataConfig:GetMaxTimeIdle()
        if timeUpLevel <= 0 then
            notification = notification .. LanguageUtils.LocalizeCommon("claim_reach_level")
        else
            if timeUpLevel > maxTime - self.timeIdle then
                notification = notification .. StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("more_time_reach_level"),
                        UIUtils.SetColorString(UIUtils.color2, TimeUtils.SecondsToClock(maxTime)), UIUtils.SetColorString(UIUtils.color2, levelRequired)) .. ".n" ..
                        LanguageUtils.LocalizeCommon("claim_to_not_max")
            else
                notification = notification .. ".n" ..
                        StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("to_reach_level_x"),
                                UIUtils.SetColorString(UIUtils.color2, TimeUtils.SecondsToClock(timeUpLevel)), levelRequired)
            end
        end
        PopupUtils.ShowPopupNotificationOK(notification)
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

function UISelectMapPVEView:OnClickQuickBattleTicket(resourceType, resourceId)
    local data = {}
    data.resourceType = resourceType
    data.resourceId = resourceId
    PopupMgr.ShowPopup(UIPopupName.UIQuickBattleCollection, data)
end

--- @param id number id of stage
function UISelectMapPVEView:OnClickStage(id)
    if id == self.campaignData.stageIdle or id == self.campaignData.stageNext then
        PopupMgr.ShowPopup(UIPopupName.UIStageSelect, { ["stageId"] = id })
        self.battleSelectMapController:SetPauseByPopup(true)
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end
end

--- @return void
function UISelectMapPVEView:OnClickButtonTeam()
    if ClientConfigUtils.CheckUnlockMinorFeatureAndNotification(MinorFeatureType.CAMPAIGN_AUTO_TRAIN) then
        self.battleSelectMapController:SetPauseByPopup(true)
        PopupMgr.ShowPopup(UIPopupName.UITrainingTeam, { ["callbackClose"] = function()
            PopupMgr.HidePopup(UIPopupName.UITrainingTeam)
            self:CheckNotificationTraining()
        end })
    end
end

--- @return void
function UISelectMapPVEView:OnClickButtonMap()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIWorldMap, { ["callbackClose"] = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UISelectMapPVE, nil, UIPopupName.UIWorldMap)
    end }, UIPopupName.UISelectMapPVE
    )
end

--- @return void
function UISelectMapPVEView:OnClickQuickBattle()
    if ClientConfigUtils.CheckUnlockMinorFeatureAndNotification(MinorFeatureType.CAMPAIGN_QUICK_BATTLE) then
        if self.campaignData:CanUseQuickBattle() then
            PopupMgr.ShowPopup(UIPopupName.UIQuickBattle, { ["callbackCheckNoti"] = function()
                self:CheckNotificationQuickBattle()
                self:UpdateUI()
            end })
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_quick_battle_turn"))
        end
    end
end

--- @return void
function UISelectMapPVEView:RequestItemReward(success, failed)
    local onReceived = function(result)
        ---@type CampaignReceiveItemInBound
        local campaignReceiveItemInBound
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            campaignReceiveItemInBound = CampaignReceiveItemInBound(buffer)
        end

        local onSuccess = function()
            if success ~= nil then
                success(campaignReceiveItemInBound)
            end
        end

        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if failed ~= nil then
                failed()
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.CAMPAIGN_ITEM_CLAIM, nil, onReceived)
end

--- @return void
function UISelectMapPVEView:RequestResourceReward(success, failed)
    local onReceived = function(result)
        ---@type CampaignReceiveItemInBound
        local campaignReceiveItemInBound
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            campaignReceiveItemInBound = CampaignReceiveItemInBound(buffer)
            campaignReceiveItemInBound.listItem = NetworkUtils.AddInjectRewardInBoundList(buffer, campaignReceiveItemInBound.listItem)
        end
        local onSuccess = function()
            if success ~= nil then
                success(campaignReceiveItemInBound)
            end
        end

        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if failed ~= nil then
                failed()
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.CAMPAIGN_RESOURCE_CLAIM, nil, onReceived)
end

--- @return void
function UISelectMapPVEView:OnClickHelpInfo()
    local info = LanguageUtils.LocalizeHelpInfo("campaign_info")
    local config = ResourceMgr.GetCampaignDataConfig().campaignConfig
    info = string.gsub(info, "{1}", tostring(MathUtils.Round(config.maxTime / TimeUtils.SecondAHour)))
    info = string.gsub(info, "{2}", "3")
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

--- @return void
function UISelectMapPVEView:OnClickButtonLoot()
    local timeToLoot = self:GetTimeToLootItem()
    if self.model.canLootItem == true then
        ---@type Job
        local requestItem = Job(function(onSuccess, onFailed)
            self:RequestItemReward(function(item)
                self.campaignData.idleItems.lastTimeIdle = zg.timeMgr:GetServerTime()
                self.campaignData.idleItems.totalTime:Clear()
                self:SetCoroutineCheckItem()
                onSuccess(item)
            end, onFailed)
        end)

        ---@type Job
        local requestResource = Job(function(onSuccess, onFailed)
            self:RequestResourceReward(function(resource)
                self.campaignData.idleResources.lastTimeIdle = zg.timeMgr:GetServerTime()
                self.campaignData.idleResources.totalTime:Clear()
                self:StartTimeIdle()
                self:SetCoroutineCheckMoney()
                onSuccess(resource)
            end, onFailed)
        end)

        ---@type Job
        local animationJob = Job(function(onSuccess, onFailed)
            local touchObject = TouchUtils.Spawn("UISelectMapPVEView:OnClickButtonLoot")
            self.battleSelectMapController:SetPauseByPopup(true)
            self.battleSelectMapController:OnGainLootSuccess()
            Coroutine.start(function()
                coroutine.waitforseconds(1)
                onSuccess()
                touchObject:Enable()
            end)
        end)

        ---@type Job
        local jobMultiple = requestItem + requestResource + animationJob
        jobMultiple:Complete(function()
            local resource = requestResource.data
            local item = requestItem.data
            local showPopup = false
            local exp = 0
            local resourceList = List()
            ---@param v RewardInBound
            for _, v in pairs(resource.listItem:GetItems()) do
                if v.type == ResourceType.Money then
                    ClientConfigUtils.AddIconDataToList(resourceList, v:GetIconData())
                elseif v.type == ResourceType.SummonerExp then
                    exp = exp + v.number
                end
                if v.number > 0 then
                    showPopup = true
                end
                --InventoryUtils.Add(v.type, v.id, v.number)
            end

            ---@param v RewardInBound
            for _, v in pairs(item.listItem:GetItems()) do
                ClientConfigUtils.AddIconDataToList(resourceList, v:GetIconData())
                if v.number > 0 then
                    showPopup = true
                end
            end
            if showPopup == true then
                ---@param v ItemIconData
                for i, v in ipairs(resourceList:GetItems()) do
                    if v.type == ResourceType.Money and ClientConfigUtils.IsMoneyEvent(v.itemId) then
                        resourceList:RemoveByIndex(i)
                        resourceList:Insert(v, 1)
                    end
                end
                ----- @return number
                -----@param x ItemIconData
                -----@param y ItemIconData
                --local sortMoney = function(x, y)
                --    if (x.type == ResourceType.Money and (x.itemId == MoneyType.EVENT_MID_AUTUMN_LANTERN or x.itemId == MoneyType.EVENT_MID_AUTUMN_MOON_CAKE)) then
                --        return -1
                --    else
                --        return 1
                --    end
                --end
                --resourceList:SortWithMethod(sortMoney)
                self.battleSelectMapController:SetTreasureView(0)
                local callbackClose = function()
                    local touchObject = TouchUtils.Spawn("UISelectMapPVEView:OnClickButtonLoot")
                    PopupMgr.HidePopup(UIPopupName.UIStageSelect)
                    self.particleGold:SetActive(false)
                    self.particleGold:SetActive(true)
                    Coroutine.start(function()
                        coroutine.waitforseconds(0.8)
                        touchObject:Enable()

                        ---@param v ItemIconData
                        for _, v in pairs(resourceList:GetItems()) do
                            v:AddToInventory()
                        end

                        self.uiScroll:RefreshCells()
                    end)
                end
                PopupMgr.ShowPopup(UIPopupName.UIStageSelect, { ["stageId"] = self.campaignData.stageIdle,
                                                                ["listItem"] = resourceList, ["callbackClose"] = callbackClose })
                InventoryUtils.Add(ResourceType.SummonerExp, 0, exp)
                ClientConfigUtils.CheckLevelUpAndUnlockFeature()
            end
        end)
    else
        SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("please_wait_for_seconds"), timeToLoot))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

--- @return void
function UISelectMapPVEView:OnClickButtonClaim()
    if self.model.canClaimMoney == true then
        local onReceived = function(result)
            local onSuccess = function()
                XDebug.Log("Claim success")
                PlayerDataRequest.Request(PlayerDataMethod.SUMMONER)
            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
        end
        NetworkUtils.Request(OpCode.CAMPAIGN_RESOURCE_CLAIM, nil, onReceived)

        InventoryUtils.Add(ResourceType.Money, MoneyType.GOLD, self.model.gold)
        InventoryUtils.Add(ResourceType.Money, MoneyType.MAGIC_POTION, self.model.magicPotion)
        InventoryUtils.Add(ResourceType.SummonerExp, 0, self.model.exp)

        self.campaignData.idleResources.lastTimeIdle = zg.timeMgr:GetServerTime()
        self.campaignData.idleResources.totalTime:Clear()
        self:StartTimeIdle()
        self:SetCoroutineCheckMoney()
    end
end

--- @return void
function UISelectMapPVEView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UISelectMapPVE)
end

function UISelectMapPVEView:_OnClickShowLeaderBoard()
    PopupUtils.ShowLeaderBoard(LeaderBoardType.CAMPAIGN)
    self.battleSelectMapController:SetPauseByPopup(true)
end

function UISelectMapPVEView:_CheckRequestTeamCampaignDetailTeamFormation()
    self.battleSelectMapController:InitBattleView()
    --if zg.playerData:GetMethod(PlayerDataMethod.CAMPAIGN_DETAIL_FORMATION) == nil then
    --    local onSuccess = function()
    --        if self:IsAvailableToShowBattle() == true then
    --            self.battleSelectMapController:OnShowBattle()
    --        end
    --    end
    --    PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.CAMPAIGN_DETAIL_FORMATION }, onSuccess, SmartPoolUtils.LogicCodeNotification)
    --else
    --    if self:IsAvailableToShowBattle() == true then
    --        self.battleSelectMapController:OnShowBattle()
    --    end
    --end
    local showDummyBattle = function()
        --- @type CampaignDetailTeamFormationInBound
        local inbound = zg.playerData:GetMethod(PlayerDataMethod.CAMPAIGN_DETAIL_FORMATION)
        if inbound.hasDetailTeamFormation and self.campaignData:CanIdle() then
            self.battleSelectMapController:OnShowBattle()
        end
    end
    CampaignDetailTeamFormationInBound.Validate(showDummyBattle)
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UISelectMapPVEView:ShowTutorial(tutorial, step)
    --XDebug.Log(step)
    if step == TutorialStep.CAMPAIGN_BATTLE_CLICK then
        tutorial:ViewFocusCurrentTutorial(self.config.buttonBattle, U_Vector2(500, 150), nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.CAMPAIGN_IDLE_REWARD_CLICK then
        tutorial:ViewFocusCurrentTutorial(self.battleSelectMapController.treasure:GetComponent(ComponentName.UnityEngine_UI_Button), 1, function()
            return uiCanvas.camUI:ScreenToWorldPoint(
                    self.battleSelectMapController.battleView:WorldToScreenPoint(self.battleSelectMapController.treasure.transform.position))
        end, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.BACK_CAMPAIGN then
        tutorial:ViewFocusCurrentTutorial(self.config.buttonBack, 0.5, function()
            return self.config.buttonBack.transform:GetChild(0).position
        end, nil, tutorial:GetHandType(TutorialHandType.MOVE_CLICK))
    elseif step == TutorialStep.STAGE10_INFO then
        self.uiScroll.scroll:RefillCellsFromEnd(0)
        Coroutine.start(function()
            local button
            while button == nil do
                coroutine.waitforseconds(0.5)
                self.uiScroll.scroll:RefillCellsFromEnd(0)
                ---@param v UIButtonStageView
                for i, v in ipairs(self.listStage:GetItems()) do
                    if v.config.gameObject.activeInHierarchy == true and v.stage == 10 then
                        button = v.config.button
                    end
                end
                if button ~= nil then
                    tutorial:ViewFocusCurrentTutorial(button, 0.8)
                else
                    XDebug.Log("MISSing stage 10")
                end
            end
        end)
    elseif step == TutorialStep.CLICK_TRAINING and self.config.buttonTeam.gameObject.activeSelf == true then
        tutorial:ViewFocusCurrentTutorial(self.config.buttonTeam, 0.5)
    end
end

--- @return void
function UISelectMapPVEView.CheckIsNextMap()
    local campaignData = zg.playerData:GetCampaignData()
    local nextDifficultId, nextMapId, nextStage = ClientConfigUtils.GetIdFromStageId(campaignData.stageNext)
    local difficultId, mapId, stage = ClientConfigUtils.GetIdFromStageId(campaignData.stageCurrent)
    return nextMapId ~= mapId
end

--- @return void
function UISelectMapPVEView.ShowFormation(fromBattleScreen)
    local campaignData = zg.playerData:GetCampaignData()
    ---@type DefenderTeamData
    local dataStage = ResourceMgr.GetCampaignDataConfig():GetCampaignStageConfigById(campaignData.stageNext)
    ---@type BattleTeamInfo
    local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(dataStage)
    --- @type {gameMode, battleTeamInfo, callbackPlayBattle, callbackClose}
    local result = {}
    result.gameMode = GameMode.CAMPAIGN
    result.battleTeamInfo = battleTeamInfo
    result.powerDefenderTeam = dataStage:GetPowerTeam()
    result.bgParams = campaignData.stageNext
    result.fromBattleScreen = fromBattleScreen
    result.callbackClose = function()
        PopupMgr.HidePopup(UIPopupName.UIFormation)
        PopupMgr.ShowPopup(UIPopupName.UISelectMapPVE)
    end
    result.callbackPlayBattle = function(uiFormationTeamData, callback)
        ---@param battleResultInBound BattleResultInBound
        local callbackSuccess = function(battleResultInBound, listRewardEvent)
            if battleResultInBound.isWin == true then
                UISelectMapPVEView.OnWinChallengeCampaignStage(campaignData.stageNext, listRewardEvent)
                PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.CAMPAIGN }, callback(nil, nil, nil, nil, battleResultInBound.battleLog))
            else
                zg.playerData.rewardList = nil
                if callback ~= nil then
                    callback(nil, nil, nil, nil, battleResultInBound.battleLog)
                end
            end
            for _, v in pairs(CampaignTrackingList) do
                if campaignData.stageCurrent == v then
                    TrackingUtils.TrackingCampaign(campaignData.stageCurrent, tostring(battleResultInBound.isWin))
                    break
                end
            end
            zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
        end
        --- @param logicCode LogicCode
        local onFailed = function(logicCode)
            if logicCode == LogicCode.CAMPAIGN_STAGE_INVALID then
                PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.CAMPAIGN }, result.callbackClose)
            end
        end
        BattleFormationRequest.BattleRequestInjectRewardEvent(OpCode.CAMPAIGN_CHALLENGE,
                uiFormationTeamData,
                campaignData.stageNext,
                callbackSuccess,
                onFailed)
        UISelectMapPVEView.UpdateCampaignTeamFormationData(uiFormationTeamData)
    end
    PopupMgr.HidePopup(UIPopupName.UISelectMapPVE)
    PopupMgr.ShowPopup(UIPopupName.UIFormation, result)
end

function UISelectMapPVEView.OnWinChallengeCampaignStage(stage, listRewardEvent)
    local rewardList = ResourceMgr.GetCampaignDataConfig():GetCampaignRewardById(stage)
    zg.playerData.rewardList = ClientConfigUtils.CombineListItemIconData(RewardInBound.GetItemIconDataList(listRewardEvent), rewardList)
    zg.playerData:AddListRewardToInventory()
    TrackingUtils.SetStage(AFInAppEvents.CAMPAIGN, stage)
    TrackingUtils.AddFirebaseProperty(FBProperties.STAGE, stage)
end

function UISelectMapPVEView.UpdateCampaignTeamFormationData(uiFormationTeamData)
    CampaignDetailTeamFormationInBound.Validate(function()
        --- @type CampaignDetailTeamFormationInBound
        local inbound = zg.playerData:GetMethod(PlayerDataMethod.CAMPAIGN_DETAIL_FORMATION)
        inbound:UpdateCampaignTeamFormation(uiFormationTeamData)
    end, false)
end
require "lua.client.core.network.raid.BattleRaidOutBound"
require "lua.client.core.network.raid.BattleRaidInBound"
require "lua.client.core.network.battleFormation.BattleFormationOutBound"
require "lua.client.scene.ui.home.uiRaid.PopupBuyItemRaidData"
require "lua.client.scene.ui.home.uiFormation.UIFormationTeamData"

local DEFAULT_POSITION = -600
local TARGET_POSITION = -528
local MAX_FLOOR = 60

--- @class UIRaidView : UIBaseView
UIRaidView = Class(UIRaidView, UIBaseView)

--- @return void
--- @param model UIRaidModel
function UIRaidView:Ctor(model)
    ---@type UIRaidConfig
    self.config = nil
    ---@type MoneyType
    self.raidMoneyType = nil
    ---@type RaidModeType
    self.raidModeType = nil

    self.tabDic = Dictionary()
    ---@type List
    self.listRaidRewardConfig = nil
    ---@type List
    self.listRaidDefenderConfig = nil
    ---@type number
    self.cacheStage = nil
    ---@type boolean
    self.cacheData = false
    ---@type RaidInBound
    self.raidInbound = nil
    ---@type boolean
    self.isShowButtonBack = false
    UIBaseView.Ctor(self, model)
    --- @type UIRaidModel
    self.model = model
end

--- @return void
function UIRaidView:OnReadyCreate()
    ---@type UIRaidConfig
    self.config = UIBaseConfig(self.uiTransform)
    uiCanvas:SetBackgroundSize(self.config.backGround)

    self:InitSelectTab()
    self:InitButtonListener()
    self:InitUpdateTime()
end

function UIRaidView:InitSelectTab()
    self.raidInbound = zg.playerData:GetMethod(PlayerDataMethod.RAID)

    self.currentTab = RaidModeType.Gold
    self.selectTab = function(currentTab)
        --if self.currentTab == currentTab then
        --    return
        --end
        self.currentTab = currentTab
        for k, v in pairs(self.tabDic:GetItems()) do
            local isSelect = k == currentTab
            v:SetTabState(isSelect)
            if isSelect then
                v.config.textTabName.color = U_Color(80 / 255, 68 / 255, 56 / 255, 1)
                self.config.banner.sprite = ResourceLoadUtils.LoadBannerRaid(currentTab)
                self.config.banner:SetNativeSize()
            end
        end
        self:UpdateUI()
    end
    local addTab = function(tabId, anchor, localizeFunction)
        self.tabDic:Add(tabId, UITabItem(anchor, self.selectTab, localizeFunction, tabId))
    end
    addTab(RaidModeType.GOLD, self.config.goldTab, function()
        return LanguageUtils.LocalizeRaidType(RaidModeType.GOLD - 1)
    end)
    addTab(RaidModeType.MAGIC_POTION, self.config.magicPotionTab, function()
        return LanguageUtils.LocalizeRaidType(RaidModeType.MAGIC_POTION - 1)
    end)
    addTab(RaidModeType.HERO_FRAGMENT, self.config.heroFragmentTab, function()
        return LanguageUtils.LocalizeRaidType(RaidModeType.HERO_FRAGMENT - 1)
    end)

    if self.currentTab == nil then
        self.selectTab(RaidModeType.GOLD)
    else
        --if self.currentTab ~= RaidModeType.Gold then
        --    self.selectTab(RaidModeType.GOLD)
        --end
        self.selectTab(self.currentTab)
    end

    --- @param obj RaidStageView
    --- @param index number
    local onCreateItem = function(obj, index)
        ---@type RaidRewardConfig
        local raidRewardConfig = self.listRaidRewardConfig:Get(index + 1)
        ---@type DefenderTeamData
        local defenderTeamData = self.listRaidDefenderConfig:Get(index + 1)
        local onClickChallenge = function()
            self:OnClickChallenge(obj, false)
        end

        local onClickSweep = function()
            self:OnClickChallenge(obj, true)
        end

        obj:SetData(defenderTeamData:GetPowerTeam(), raidRewardConfig, onClickChallenge, onClickSweep, defenderTeamData:GetBattleTeamInfo(),self.playableStage, self.raidModeType)

        self.isShowButtonBack = true
        for k,v in pairs(self.uiScroll:GetItems()) do
            if v.stage == self.playableStage then
                self.isShowButtonBack = false
            end
        end

        if self.isShowButtonBack == false or self.playableStage > MAX_FLOOR then
            local buttonBackCurrent = self.config.backToCurrentButton.transform.localPosition
            ---@type UnityEngine_Vector3
            local backButtonPos = buttonBackCurrent
            backButtonPos.y = DEFAULT_POSITION
            self.config.backToCurrentButton.transform.localPosition = backButtonPos
        else
            local buttonBackCurrent = self.config.backToCurrentButton.transform.localPosition
            ---@type UnityEngine_Vector3
            local backButtonPos = buttonBackCurrent
            self.coroutine = Coroutine.start(function()
                while true do
                    coroutine.waitforendofframe()
                    if backButtonPos.y == TARGET_POSITION or self.isShowButtonBack == false then
                        break
                    else
                        backButtonPos.y = backButtonPos.y + 3
                        self.config.backToCurrentButton.transform.localPosition = backButtonPos
                    end
                end
            end)
        end
        local currentStage = self.playableStage
        if self.playableStage > MAX_FLOOR then
            currentStage = MAX_FLOOR
        end
        self.config.currentFloor.text = LanguageUtils.LocalizeCommon("current_floor") .. " " .. currentStage
    end
    ---@type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.RaidStageView, onCreateItem, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig())
end

function UIRaidView:OnClickReturnCurrentStage()
    self:ResizeScroll()
end

--- @return void
function UIRaidView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeFeature(FeatureType.RAID)
    self.config.localizeRemaining.text = LanguageUtils.LocalizeCommon("remaining_attempts")
    self.config.backToCurrentText.text = LanguageUtils.LocalizeCommon("back_current")
    local currentStage = self.playableStage
    if self.playableStage > MAX_FLOOR then
        currentStage = MAX_FLOOR
    end
    self.config.currentFloor.text = LanguageUtils.LocalizeCommon("current_floor") .. " " .. currentStage


    if self.tabDic ~= nil then
        --- @param v UITabItem
        for _, v in pairs(self.tabDic:GetItems()) do
            v:InitLocalization()
        end
    end
end

--- @return void
function UIRaidView:InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonBuyTurn.onClick:AddListener(function()
        self:OnClickBuyTurn()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonHelp.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.backToCurrentButton.onClick:AddListener(function()
        self:OnClickReturnCurrentStage()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function UIRaidView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.config.textTimeRefesh.text = string.format(LanguageUtils.LocalizeCommon("refresh_in"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.SecondsToClock(self.timeRefresh)))
    end
end

function UIRaidView:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

--- @return void
function UIRaidView:StartTimeRefresh()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

--- @return void
function UIRaidView:OnReadyShow()
    self.raidInbound = zg.playerData:GetMethod(PlayerDataMethod.RAID)
    if self.currentTab == nil then
        self.selectTab(RaidModeType.GOLD)
    else
        --if self.currentTab ~= RaidModeType.Gold then
        --    self.selectTab(RaidModeType.GOLD)
        --end
        self.selectTab(self.currentTab)
    end

    self:StartTimeRefresh()
    self.uiScroll:PlayMotion()
end

--- @return void
function UIRaidView:Hide()
    UIBaseView.Hide(self)
    self.uiScroll:Hide()
    self.cacheStage = nil
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

--- @return void
function UIRaidView:UpdateUI()
    local raid = ResourceMgr.GetRaidConfig()
    self.listRaidRewardConfig = raid:GetRewardMode(self.currentTab)
    self.listRaidDefenderConfig = raid:GetDefenderMode(self.currentTab)
    if self.currentTab == RaidModeType.GOLD then
        self.raidModeType = RaidModeType.GOLD - 1
        self.raidMoneyType = MoneyType.RAID_GOLD_TURN
    elseif self.currentTab == RaidModeType.MAGIC_POTION then
        self.raidModeType = RaidModeType.MAGIC_POTION - 1
        self.raidMoneyType = MoneyType.RAID_MAGIC_POTION_TURN
    else
        self.raidModeType = RaidModeType.HERO_FRAGMENT - 1
        self.raidMoneyType = MoneyType.RAID_HERO_FRAGMENT_TURN
    end
    self:UpdateUITurn()

    self.playableStage = nil
    if self.raidInbound.playableStage:Get(self.raidModeType) == nil then
        self.playableStage = 1
    else
        self.playableStage = self.raidInbound.playableStage:Get(self.raidModeType)
    end

    self.config.iconMoneyImg.sprite = ResourceLoadUtils.LoadMoneyIcon(self.raidMoneyType)
    self.config.iconMoneyButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = {["type"] = ResourceType.Money, ["id"] = self.raidMoneyType}})
    end)

    self:ResizeScroll()
end

function UIRaidView:ResizeScroll()
    local id = self.playableStage
    local offset = nil

    if id >= self.listRaidRewardConfig:Count() then
        id = self.listRaidRewardConfig:Count() + 1
        offset = id - 4
    else
        offset = id - 2
    end
    if self.uiScroll ~= nil then
        self.uiScroll:Resize(self.listRaidRewardConfig:Count(), math.max(0, offset))
    end
end

--- @return void
function UIRaidView:UpdateUITurn()
    self.config.textTurn.text = string.format("%s/%s", InventoryUtils.GetMoney(self.raidMoneyType),
            ResourceMgr.GetRaidConfig().raidConfig.turnResetDaily)
    self:UpdateNotify()
end

--- @return void
function UIRaidView:UpdateNotify()
    self.config.notifyRaid1:SetActive(InventoryUtils.GetMoney(MoneyType.RAID_GOLD_TURN) > 0)
    self.config.notifyRaid2:SetActive(InventoryUtils.GetMoney(MoneyType.RAID_MAGIC_POTION_TURN) > 0)
    self.config.notifyRaid3:SetActive(InventoryUtils.GetMoney(MoneyType.RAID_HERO_FRAGMENT_TURN) > 0)
end

--- @return void
function UIRaidView:OnClickHelpInfo()
    local info = LanguageUtils.LocalizeHelpInfo("raid_info")
    info = string.gsub(info, "{1}", tostring(MathUtils.Round(ResourceMgr.GetRaidConfig().raidConfig.turnResetDaily)))
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

--- @return void
function UIRaidView:OnClickBuyTurn()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.RAID, "buy_more", self.raidModeType)
    local turnBuyDailyVip = ResourceMgr.GetRaidConfig().raidConfig:GetTurnBuyDailyVip()
    local turnAdsDailyVip = ResourceMgr.GetRaidConfig().raidConfig:GetTurnAdsDailyVip()
    local maxCountBuyTurn = turnBuyDailyVip - self.raidInbound.turnBuyInDay:Get(self.raidModeType)
    local maxCountAdsTurn = turnAdsDailyVip - self.raidInbound.turnAdsInDay:Get(self.raidModeType)
    local gemPrice = ResourceMgr.GetRaidConfig().raidConfig.turnPrice

    --if maxCountBuyTurn > 0 then
        local callback = function(isAdsBuy, callBackUpdateUI)
            local callback = function(result)
                local onSuccess = function()
                    XDebug.Log("RAID_STAMINA_BUY success")
                    if not isAdsBuy then
                        InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, gemPrice)
                        self.raidInbound.turnBuyInDay:Add(self.raidModeType, self.raidInbound.turnBuyInDay:Get(self.raidModeType) + 1)
                    else
                        self.raidInbound.turnAdsInDay:Add(self.raidModeType, self.raidInbound.turnAdsInDay:Get(self.raidModeType) + 1)
                    end
                    local rewardInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, self.raidMoneyType, 1)
                    local rewardList = List()
                    rewardList:Add(rewardInBound)
                    PopupUtils.ClaimAndShowRewardList(rewardList)
                    self:UpdateUITurn()
                    if callBackUpdateUI ~= nil then
                        callBackUpdateUI()
                    end
                end
                local onFailed = function(logicCode)
                    SmartPoolUtils.LogicCodeNotification(logicCode)
                end
                NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
            end
            NetworkUtils.Request(OpCode.RAID_STAMINA_BUY, UnknownOutBound.CreateInstance(PutMethod.Byte, 1, PutMethod.Byte, self.raidModeType, PutMethod.Bool, isAdsBuy), callback)
        end
        ---@type PopupBuyItemRaidData
        local dataPurchase = PopupBuyItemRaidData()
        dataPurchase:SetData(ResourceType.Money, self.raidMoneyType, maxCountBuyTurn, maxCountAdsTurn, turnBuyDailyVip, turnAdsDailyVip,
                MoneyType.GEM, gemPrice, callback, false, self.raidModeType)

        PopupMgr.ShowPopup(UIPopupName.UIPopupBuyItemRaid, dataPurchase)
    --else
    --    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_buy_turn_daily"))
    --    zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    --end
end

--- @return void
---@param raidStageView RaidStageView
function UIRaidView:OnClickChallenge(raidStageView, isSweep)
    ---@type RaidRewardConfig
    local raidRewardConfig = raidStageView.raidRewardConfig
    self.cacheStage = raidRewardConfig.stage
    local canChallenge = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, self.raidMoneyType, 1))
    if canChallenge then
        if isSweep then
            self:RequestSweep(raidRewardConfig, raidStageView)
        else
            self:RequestChallenge(raidRewardConfig, raidStageView)
        end
    end
end

function UIRaidView:RequestSweep(raidRewardConfig, raidStageView)
    local teamFormation = TeamFormationInBound()
    teamFormation:SetDefaultTeam()

    --- @type List
    local listHeroResource = List()
    listHeroResource = InventoryUtils.Get(ResourceType.Hero)

    local uiFormationTeamData = UIFormationTeamData.CreateByTeamFormationInBound(teamFormation,
            listHeroResource)

    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            ---@type BattleRaidInBound
            self.raidInbound.raidBattleResultInbound = BattleRaidInBound.CreateByBuffer(buffer)
        end
        local onSuccess = function()
            local raidData = zg.playerData:GetRaidData()
            raidData.raidModeType = self.raidModeType
            raidData.raidModeStage = raidRewardConfig.stage
            if self.raidInbound.raidBattleResultInbound ~= nil then
                PopupUtils.ClaimAndShowRewardList(self.raidInbound.raidBattleResultInbound.listReward)
            end
            InventoryUtils.Sub(ResourceType.Money, self.raidMoneyType, 1)
            self:UpdateUITurn()
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
    NetworkUtils.Request(OpCode.RAID_CHALLENGE, BattleRaidOutBound(self.currentTab - 1, raidRewardConfig.stage, uiFormationTeamData, true), onReceived)
end

local GOLD_MAP_ID = 402
local POTION_MAP_ID = 801
local FRAGMENT_MAP_ID = 703

function UIRaidView:RequestChallenge(raidRewardConfig, raidStageView)
    local data = {}
    if self.raidModeType ~= RaidModeType.HERO_FRAGMENT - 1 then
        data.gameMode = GameMode.RAID
    else
        data.gameMode = GameMode.RAID_HERO_FRAGMENT
    end
    ---@type DefenderTeamData
    local dataStage = self.listRaidDefenderConfig:Get(raidRewardConfig.stage)
    local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(dataStage)
    data.battleTeamInfo = battleTeamInfo
    data.callbackClose = function()
        if self.raidModeType ~= RaidModeType.HERO_FRAGMENT - 1 then
            PopupMgr.ShowAndHidePopup(UIPopupName.UIRaid, nil, UIPopupName.UIFormation)
        else
            PopupMgr.ShowAndHidePopup(UIPopupName.UIRaid, nil, UIPopupName.UIFormationRaid)
        end
    end
    data.canSkip = true
    data.power = raidStageView.power
    data.stage = raidRewardConfig.stage
    --print(ResourceMgr.GetRaidConfig():GetBattleRaidBg(self.raidModeType, raidRewardConfig.stage))
    local id = nil
    if self.raidModeType == RaidModeType.GOLD - 1 then
        id = GOLD_MAP_ID
    elseif self.raidModeType == RaidModeType.MAGIC_POTION - 1 then
        id = POTION_MAP_ID
    else
        id = FRAGMENT_MAP_ID
    end
    --UIRaidModel.raidBgId = ResourceMgr.GetRaidConfig():GetBattleRaidBg(self.raidModeType, raidRewardConfig.stage)
    UIRaidModel.raidBgId = id
    data.callbackPlayBattle = function(uiFormationTeamData, callback)
        --Request
        local onReceived = function(result)
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                ---@type BattleRaidInBound
                self.raidInbound.raidBattleResultInbound = BattleRaidInBound.CreateByBuffer(buffer)
            end
            local onSuccess = function()
                local raidData = zg.playerData:GetRaidData()
                raidData.raidModeType = self.raidModeType
                raidData.raidModeStage = raidRewardConfig.stage
                if self.raidInbound.raidBattleResultInbound.battleResultInBound.isWin == true then
                    if self.raidInbound.playableStage:Get(self.raidModeType) == nil then
                        self.raidInbound.playableStage:Add(self.raidModeType, 2)
                    else
                        if raidRewardConfig.stage == self.raidInbound.playableStage:Get(self.raidModeType) then
                            self.raidInbound.playableStage:Add(self.raidModeType, self.raidInbound.playableStage:Get(self.raidModeType) + 1)
                        end
                    end
                    if self.raidInbound.raidBattleResultInbound ~= nil then
                        zg.playerData.rewardList = RewardInBound.GetItemIconDataList(self.raidInbound.raidBattleResultInbound.listReward)
                    end
                    InventoryUtils.Sub(ResourceType.Money, self.raidMoneyType, 1)
                    zg.playerData:AddListRewardToInventory()
                else
                    zg.playerData.rewardList = nil
                end
                if callback ~= nil then
                    callback(nil, nil, nil, nil, self.raidInbound.raidBattleResultInbound.battleResultInBound.battleLog)
                end
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
        end
        zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
        NetworkUtils.Request(OpCode.RAID_CHALLENGE, BattleRaidOutBound(self.currentTab - 1, raidRewardConfig.stage, uiFormationTeamData, false), onReceived)
    end
    if self.raidModeType ~= RaidModeType.HERO_FRAGMENT - 1 then
        PopupMgr.ShowAndHidePopup(UIPopupName.UIFormation, data, UIPopupName.UIRaid)
    else
        PopupMgr.ShowAndHidePopup(UIPopupName.UIFormationRaid, data, UIPopupName.UIRaid)
    end
end


function UIRaidView:OnClickBackOrClose()
    self:OnReadyHide()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self.currentTab = nil
end
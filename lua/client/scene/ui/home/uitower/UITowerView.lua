require "lua.client.scene.ui.home.uiTower.towerWorld.TowerWorld"
require "lua.client.core.network.tower.TowerRequest"
require "lua.client.scene.ui.common.BattleTeamView"

--- @class UITowerView : UIBaseView
UITowerView = Class(UITowerView, UIBaseView)

--- @return void
--- @param model UITowerModel
function UITowerView:Ctor(model)
    --- @type TowerWorld
    self.towerWorld = nil
    --- @type UITowerConfig
    self.config = nil
    --- @type MoneyBarView
    self.staminaBarView = nil
    --- @type BattleTeamView
    self.battleTeamView = nil

    --- @type Coroutine
    self.updateCoroutine = nil
    --- @type Coroutine
    self.switchFloorCoroutine = nil

    --- @type ItemsTableView
    self.rewardView = nil
    --- @type Coroutine
    self.coroutineScroll = nil
    --- @type boolean
    self.isClick = nil
    --- @type List<HeroIconView>
    self.listBossIconView = List()
    --- @type TowerInBound
    self.towerInBound = nil

    UIBaseView.Ctor(self, model)
    --- @type UITowerModel
    self.model = model
    --- @type TowerData
    self.csv = nil
end


--- @return void
function UITowerView:OnReadyCreate()
    ---@type UITowerConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtonListener()
    self:InitBuildTower()
    self:InitEventTrigger()
    self:InitUpdateTime()

    self.rewardView = ItemsTableView(self.config.rewardAnchor)
    self.battleTeamView = BattleTeamView(self.config.defenderTeamAnchor)
end

function UITowerView:InitLocalization()
    self.config.localizeItemReward.text = LanguageUtils.LocalizeCommon("reward")
    self.config.localizeEnemyTeam.text = LanguageUtils.LocalizeCommon("enemy_team")
    self.config.localizeBattle.text = LanguageUtils.LocalizeCommon("battle")
    self.config.localizeRecord.text = LanguageUtils.LocalizeCommon("record")
    self.config.localizeReturn.text = LanguageUtils.LocalizeCommon("back_to_current")
end

function UITowerView:InitEventTrigger()
    self.config.eventTrigger.triggers:Clear()
    local entryPointerDown = U_EventSystems.EventTrigger.Entry()
    entryPointerDown.eventID = U_EventSystems.EventTriggerType.PointerDown
    entryPointerDown.callback:AddListener(function(data)
        self:OnPointerChange(true)
    end)
    self.config.eventTrigger.triggers:Add(entryPointerDown)

    local entryPointerUp = U_EventSystems.EventTrigger.Entry()
    entryPointerUp.eventID = U_EventSystems.EventTriggerType.PointerUp
    entryPointerUp.callback:AddListener(function(data)
        self:OnPointerChange(false, data)
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.eventTrigger.triggers:Add(entryPointerUp)

    --- calculate and drag slot hero
    --- @type UnityEngine_EventSystems_EventTrigger_Entry
    local entryDrag = U_EventSystems.EventTrigger.Entry()
    entryDrag.eventID = U_EventSystems.EventTriggerType.Drag
    entryDrag.callback:AddListener(function(data)
        self.isClick = false
    end)
    self.config.eventTrigger.triggers:Add(entryDrag)
end

function UITowerView:OnReadyShow(isBackFromBattle)
    self.towerInBound = zg.playerData:GetMethod(PlayerDataMethod.TOWER)
    self.csv = ResourceMgr.GetTowerConfig()
    self:InitMoneyBar()
    self:UpdateRefreshTime()
    self:ScrollTower(isBackFromBattle)
end

function UITowerView:CanBattle()
    return self.towerInBound.levelCurrent < self.csv.maxFloor
end

function UITowerView:GetFloorShow(isBackFromBattle)
    local floorShow = self.towerInBound.levelCurrent
    if self:CanBattle() then
        if isBackFromBattle == true and self.towerInBound.isWinLastLevel == true then
            self.listenToHideLoading = RxMgr.hideLoading:Subscribe(RxMgr.CreateFunction(self, self.OnHideLoading))
        else
            floorShow = self.towerInBound.levelCurrent + 1
        end
    end
    return floorShow
end

function UITowerView:ScrollTower(isBackFromBattle)
    local floorShow = self:GetFloorShow(isBackFromBattle)
    self.model:SetAvailableFloor(floorShow)
    local scrollBarValue = self:GetScrollBarValueByFloorLevel(floorShow)
    self.towerWorld:OnShow(scrollBarValue)
    self:GoToFloor(floorShow, isBackFromBattle)
    self.updateCoroutine = Coroutine.start(function()
        coroutine.yield(nil)
        self.towerWorld:Update(scrollBarValue)
        while true do
            coroutine.yield(nil)
            self.towerWorld:Update(self.config.scrollView.verticalScrollbar.value)
        end
    end)
end

--- @param floor number
--- @param useTweenMove boolean
function UITowerView:GoToFloor(floor, useTweenMove)
    local scrollbar = self.config.scrollView.verticalScrollbar
    if useTweenMove ~= true then
        scrollbar.value = self:GetScrollBarValueByFloorLevel(floor)
        self:SelectFloor(floor)
        return scrollbar.value
    end
    local targetScrollValue = self:GetScrollBarValueByFloorLevel(floor)
    local deltaValue = (targetScrollValue - scrollbar.value) / ClientConfigUtils.FPS
    local tweenTime = 1
    ClientConfigUtils.KillCoroutine(self.coroutineScroll)
    self.coroutineScroll = Coroutine.start(function()
        while (tweenTime > 0) do
            scrollbar.value = scrollbar.value + deltaValue
            if (deltaValue > 0 and scrollbar.value > targetScrollValue) or (deltaValue < 0 and scrollbar.value < targetScrollValue) then
                scrollbar.value = targetScrollValue
            end
            tweenTime = tweenTime - 1 / ClientConfigUtils.FPS
            coroutine.yield(nil)
        end
        self:SelectFloor(floor)
    end)
end

function UITowerView:GetScrollBarValueByFloorLevel(floorLevel)
    return (floorLevel - 1) / (self.model.maxFloor - 1)
end

function UITowerView:InitMoneyBar()
    self.staminaBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.currencyBar)
    self.staminaBarView:SetIconData(MoneyType.TOWER_STAMINA)
    self.staminaBarView:AddListener(function()
        local callback = function(numberReturn, priceTotal)
            local onBuySuccess = function()
                InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, priceTotal)
                InventoryUtils.Add(ResourceType.Money, MoneyType.TOWER_STAMINA, numberReturn)
                self.staminaBarView:SetBuyText(self.csv.maxStamina)
                SmartPoolUtils.ShowReward1Item(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.TOWER_STAMINA, numberReturn))
                self:CheckStopUpdateTime()
            end
            TowerRequest.BuyItem(numberReturn, onBuySuccess)
        end

        ---@type PopupBuyItemData
        local dataPurchase = PopupBuyItemData()
        dataPurchase:SetData(ResourceType.Money, MoneyType.TOWER_STAMINA, 1, 1, 100,
                MoneyType.GEM, self.csv.staminaGemPrice, callback, LanguageUtils.LocalizeMoneyType(MoneyType.TOWER_STAMINA), LanguageUtils.LocalizeCommon("buy"), false)
        PopupMgr.ShowPopup(UIPopupName.UIPopupBuyItem, dataPurchase)
    end)
end

function UITowerView:InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
    self.config.buttonRank.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupUtils.ShowLeaderBoard(LeaderBoardType.TOWER)
    end)
    self.config.battleButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBattle()
    end)
    self.config.recordButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBattleRecord()
    end)
    self.config.buttonReturn.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:GoToFloor(self.model.availableFloor, true)
    end)
end

--- @return void
function UITowerView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UITowerView:OnClickBackOrClose()
    self:OnReadyHide()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
end

--- @return void
function UITowerView:InitBuildTower()
    self.towerWorld = TowerWorld(self.config.towerWorld, self)
end

function UITowerView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        if self.timeRefresh > 0 then
            self.config.textTime.text = TimeUtils.SecondsToClock(self.timeRefresh)
        else
            InventoryUtils.Add(ResourceType.Money, MoneyType.TOWER_STAMINA, 1)
            self.staminaBarView:SetBuyText(self.csv.maxStamina)

            self.towerInBound.lastFreeStamina = zg.timeMgr:GetServerTime()
            self:CheckStopUpdateTime()
        end
    end
end

function UITowerView:SetTimeRefresh()
    self.timeRefresh = self.csv.staminaRefreshInterval - (zg.timeMgr:GetServerTime() - self.towerInBound.lastFreeStamina)
end

--- @return void
function UITowerView:UpdateRefreshTime()
    local moneyValue = InventoryUtils.GetMoney(MoneyType.TOWER_STAMINA)
    local maxStamina = self.csv.maxStamina
    if moneyValue == nil or maxStamina == nil then
        XDebug.Error(string.format("money: %s, max: %s", moneyValue, maxStamina))
    end
    self.config.textTime.enabled = false
    if moneyValue < maxStamina then
        local serverTime = zg.timeMgr:GetServerTime()
        local deltaTime = serverTime - self.towerInBound.lastFreeStamina
        local coin = deltaTime / self.csv.staminaRefreshInterval
        if coin >= 1 then
            local roundCoin = math.floor(coin)
            if roundCoin >= maxStamina - moneyValue then
                local coinAdded = maxStamina - moneyValue
                InventoryUtils.Add(ResourceType.Money, MoneyType.TOWER_STAMINA, coinAdded)
                self.towerInBound.lastFreeStamina = serverTime
                moneyValue = maxStamina
            else
                InventoryUtils.Add(ResourceType.Money, MoneyType.TOWER_STAMINA, roundCoin)
                self.towerInBound.lastFreeStamina = self.towerInBound.lastFreeStamina + roundCoin * self.csv.staminaRefreshInterval
                moneyValue = moneyValue + roundCoin
            end
        end

        if moneyValue < maxStamina then
            self.config.textTime.enabled = true
            zg.timeMgr:AddUpdateFunction(self.updateTime)
        end
    end
    self.staminaBarView:SetBuyText(self.csv.maxStamina)
end

--- @return void
function UITowerView:CheckStopUpdateTime()
    if InventoryUtils.IsValid(ResourceType.Money, MoneyType.TOWER_STAMINA, self.csv.maxStamina) then
        self.config.textTime.enabled = false
        self:RemoveUpdateTime()
    else
        self:SetTimeRefresh()
        self.config.textTime.text = TimeUtils.SecondsToClock(self.timeRefresh)
    end
end

--- @return void
function UITowerView:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UITowerView:Hide()
    ClientConfigUtils.KillCoroutine(self.updateCoroutine)
    ClientConfigUtils.KillCoroutine(self.coroutineScroll)
    ClientConfigUtils.KillCoroutine(self.switchFloorCoroutine)

    if self.listenToHideLoading then
        self.listenToHideLoading:Unsubscribe()
        self.listenToHideLoading = nil
    end
    self.towerWorld:OnHide()
    self.battleTeamView:Hide()
    self:HideBossIconView()
    if self.staminaBarView ~= nil then
        self.staminaBarView:ReturnPool()
        self.staminaBarView = nil
    end
    self:RemoveUpdateTime()
    UIBaseView.Hide(self)
end

--- @param contentHeight number
function UITowerView:SetTowerScrollContentSize(contentHeight)
    local sizeDelta = self.config.content.sizeDelta
    self.config.content.sizeDelta = U_Vector2(sizeDelta.x, contentHeight)
end

--- @param value number
function UITowerView:SetScrollbarValue(value)
    self.config.towerScrollBar.value = value
end

function UITowerView:GetScrollbarValue()
    return self.config.towerScrollBar.value
end

--- @return void
function UITowerView:OnClickHelpInfo()
    local info = LanguageUtils.LocalizeHelpInfo("tower_of_dragon_info")
    ---@type TowerData
    local config = self.csv
    info = string.gsub(info, "{1}", "1")
    info = string.gsub(info, "{2}", tostring(MathUtils.Round(config.staminaRefreshInterval / 60)))
    info = string.gsub(info, "{3}", tostring(config.maxStamina))
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

--- @param floorId number
function UITowerView:ShowSelectedFloorReward(floorId)
    if self.rewardView ~= nil then
        self.rewardView:Hide()
    end

    --- @type List -- <ItemIconData>
    local rewardList = self.csv:GetReward(floorId)
    self.model.listSelectedFloorReward = rewardList
    self.rewardView:SetData(rewardList)
    if floorId <= self.towerInBound.levelCurrent then
        self.rewardView:ActiveMaskSelect(true)
    end
end

---@param defenderTeamData DefenderTeamData
function UITowerView:GetBattleTeamInfo(defenderTeamData)
    ---@type BattleTeamInfo
    local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(defenderTeamData)
    ClientConfigUtils.RequireBattleTeam(battleTeamInfo)
    return battleTeamInfo
end

--- @param floorId number
function UITowerView:ShowFloorDefenderTeam(floorId)
    self:HideBossIconView()
    self.battleTeamView:Hide()

    ---@type DefenderTeamData
    local levelConfig = self.csv:GetLevelConfig(floorId)

    self.config.textCp.text = tostring(levelConfig.powerTeam)

    local battleTeamInfo = self:GetBattleTeamInfo(levelConfig)
    local listBossBattleInfo = List()
    for i = 1, battleTeamInfo.listHeroInfo:Count() do
        if battleTeamInfo.listHeroInfo:Get(i).isBoss == true then
            listBossBattleInfo:Add(battleTeamInfo.listHeroInfo:Get(i))
        end
    end

    local teamPowerCalculator = TeamPowerCalculator()
    teamPowerCalculator:SetDefenderTeamInfo(battleTeamInfo)
    --- @type Dictionary -- <number, number>
    local powerMap = teamPowerCalculator:CalculatePowerDetail(ResourceMgr.GetServiceConfig():GetBattle(),
            ResourceMgr.GetServiceConfig():GetHeroes(), BattleConstants.DEFENDER_TEAM_ID)

    --- @param heroBattleInfo HeroBattleInfo
    local showPopupHeroInfo = function(heroBattleInfo)
        local battleSlot = ClientConfigUtils.GetSlotNumberByPositionInfo(battleTeamInfo.formation,
                heroBattleInfo.isFrontLine,
                heroBattleInfo.position)
        if heroBattleInfo ~= nil then
            local data = {}
            data.heroResource = HeroResource.CreateInstanceByHeroBattleInfo(heroBattleInfo)
            data.power = powerMap:Get(battleSlot)
            data.statDict = ClientConfigUtils.GetHeroStatDictByHeroBattleInfo(heroBattleInfo, teamPowerCalculator)
            PopupMgr.ShowPopup(UIPopupName.UIHeroSummonInfo, data)
        end
    end

    if listBossBattleInfo:Count() >= 1 and listBossBattleInfo:Count() <= 2 then
        for i = 1, listBossBattleInfo:Count() do
            --- @type HeroBattleInfo
            local heroBattleInfo = listBossBattleInfo:Get(i)
            --- @type HeroIconView
            local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.bossIconAnchor)
            iconView:SetIconData(HeroIconData.CreateByHeroBattleInfo(heroBattleInfo))
            self.listBossIconView:Add(iconView)
            iconView:ActiveFrameBoss(true)
            iconView:RemoveAllListeners()
            iconView:AddListener(function()
                showPopupHeroInfo(heroBattleInfo)
            end)
        end
    else
        self.battleTeamView:Show()
        self.battleTeamView:SetDataDefender(UIPoolType.HeroIconView, battleTeamInfo, function(slotIndex)
            --- @type HeroBattleInfo
            local heroBattleInfo = ClientConfigUtils.GetHeroBattleInfoInBattleTeamInfoBySlotIndex(battleTeamInfo, slotIndex)
            showPopupHeroInfo(heroBattleInfo)
        end)
        self.battleTeamView.uiTeamView:SetSummonerInfo(battleTeamInfo.summonerBattleInfo)
        self.battleTeamView.uiTeamView:ActiveBuff(false)
        self.battleTeamView.uiTeamView:ActiveLinking(false)

        if battleTeamInfo.summonerBattleInfo.isDummy == true then
            self.config.defenderTeamAnchor.anchoredPosition3D = U_Vector3(0, -172, 0)
        else
            self.config.defenderTeamAnchor.anchoredPosition3D = U_Vector3(64, -172, 0)
        end
    end
end

--- @param floorId number
function UITowerView:SelectFloor(floorId)
    self.model.selectedFloorNum = floorId
    self.battleTeamView:Hide()

    self.config.textFloorTitle.text = string.format("%s %d", LanguageUtils.LocalizeCommon("floor"), floorId)
    self:ShowSelectedFloorReward(floorId)
    self:ShowFloorDefenderTeam(floorId)
    self.towerWorld:SetHighlightFloor(floorId)

    if floorId == self.towerInBound.levelCurrent then
        self.config.battleButton.gameObject:SetActive(false)
    else
        self.config.battleButton.gameObject:SetActive((floorId == self.towerInBound.levelCurrent + 1)
                and floorId <= self.csv.maxFloor)
    end
end

--- @return void
function UITowerView:OnClickBattle()
    local isValidLevel,levelRequired = self.csv:IsValidLevel( self.model.selectedFloorNum)
    local canBattle = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.TOWER_STAMINA, 1))
            and isValidLevel
    if canBattle then
        self.towerInBound.isWinLastLevel = false
        local levelConfig = self.csv:GetLevelConfig(self.model.availableFloor)
        self.towerInBound.selectedLevel = self.model.availableFloor

        ---@type BattleTeamInfo
        local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(levelConfig)
        local rewardList = self.csv:GetReward(self.model.availableFloor)
        local result = {}
        result.gameMode = GameMode.TOWER
        result.powerDefenderTeam = levelConfig:GetPowerTeam()
        result.battleTeamInfo = battleTeamInfo
        result.bgParams = self.towerInBound.selectedLevel
        result.callbackClose = function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UITower, false, UIPopupName.UIFormation)
        end
        result.callbackSkipSuccess = function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UITower, true, UIPopupName.UIFormation)
            self:OnHideLoading()
        end
        result.callbackPlayBattle = function(uiFormationTeamData, callback)
            --- @param logicCode LogicCode
            local onFailed = function(logicCode)
                if logicCode == LogicCode.TOWER_STAGE_INVALID then
                    PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.TOWER }, result.callbackClose)
                end
            end
            ---@param battleResultInBound BattleResultInBound
            local callbackSuccess = function(battleResultInBound)
                if battleResultInBound.isWin then
                    zg.playerData.rewardList = rewardList
                    zg.playerData:AddListRewardToInventory()
                    self.towerInBound:SetDataTowerAfterWin()
                    TrackingUtils.SetStage(AFInAppEvents.TOWER, self.towerInBound.levelCurrent)
                else
                    zg.playerData.rewardList = nil
                    if self.csv.maxStamina - 1 == InventoryUtils.GetMoney(MoneyType.TOWER_STAMINA) then
                        self.towerInBound.lastFreeStamina = zg.timeMgr:GetServerTime()
                    end
                    RxMgr.mktTracking:Next(MktTrackingType.towerLost, 1)
                end
                InventoryUtils.Sub(ResourceType.Money, MoneyType.TOWER_STAMINA, 1)
                if callback ~= nil then
                    callback(nil, nil, battleResultInBound.isWin, nil, battleResultInBound.battleLog)
                end
            end
            BattleFormationRequest.BattleRequest(OpCode.TOWER_CHALLENGE, uiFormationTeamData, self.towerInBound.selectedLevel, callbackSuccess, onFailed)
        end
        PopupMgr.ShowAndHidePopup(UIPopupName.UIFormation, result, UIPopupName.UITower)
    else
        local notification
        if not isValidLevel then
            notification =  string.format(LanguageUtils.LocalizeCommon("tower_lock_level_require"),UIUtils.SetColorString(UIUtils.green_light, levelRequired))
        else
            notification = LanguageUtils.LocalizeCommon("tower_lock_out_of_ticket")
        end
        SmartPoolUtils.ShowShortNotification(notification)
    end

end

--- @param extendedFloor number
function UITowerView:OnExtendFloor(extendedFloor)
    local deltaFloor = math.abs(extendedFloor - self.model.availableFloor)
    self.config.buttonReturn.gameObject:SetActive(deltaFloor > TowerWorldModel.MAX_SPAWNED_FLOOR)
    if self.config.buttonReturn.gameObject.activeSelf == true
            and extendedFloor ~= self.model.availableFloor
            and self.model.selectedFloorNum ~= self.model.availableFloor then
        self.config.battleButton.gameObject:SetActive(false)
    end
    if extendedFloor ~= self.model.selectedFloorNum
            and self.towerWorld:IsUsingFloor(self.model.selectedFloorNum) == false then
        self.towerWorld:SetHighlightFloor(-1)
    else
        self.towerWorld:SetHighlightFloor(self.model.selectedFloorNum)
    end

    if extendedFloor % 5 == 0 then
        --- @type List -- <ItemIconData>
        local rewardList = self.csv:GetReward(extendedFloor)
        self.towerWorld:SetReward(extendedFloor, rewardList:Get(1))
    end
end

--- @param isDown boolean
--- @param data UnityEngine_EventSystems_PointerEventData
function UITowerView:OnPointerChange(isDown, data)
    if isDown then
        self.isClick = true
    else
        if self.isClick == true then
            local selectedFloor = self.towerWorld:FindTowerClicked(data.position)
            if selectedFloor ~= nil then
                self:SelectFloor(selectedFloor)
            end
        end
    end
end

function UITowerView:OnClickBattleRecord()
    local onRecordLoaded = function()
        PopupMgr.ShowPopup(UIPopupName.UITowerBattleRecord, self.model.selectedFloorNum)
    end
    TowerInBound.GetRecord(self.model.selectedFloorNum, onRecordLoaded)
end

function UITowerView:HideBossIconView()
    if self.listBossIconView:Count() == 0 then
        return
    end
    ---@param iconView IconView
    for _, iconView in pairs(self.listBossIconView:GetItems()) do
        iconView:ActiveFrameBoss(false)
        iconView:ReturnPool()
    end
    self.listBossIconView:Clear()
end

function UITowerView:OnHideLoading()
    self.switchFloorCoroutine = Coroutine.start(function()
        coroutine.waitforseconds(0.1)
        self.model:SetAvailableFloor(self.towerInBound.levelCurrent + 1)
        self:GoToFloor(self.model.availableFloor, true)
    end)
end

function UITowerView:OnDestroy()
    self.towerWorld:Destroy()
end
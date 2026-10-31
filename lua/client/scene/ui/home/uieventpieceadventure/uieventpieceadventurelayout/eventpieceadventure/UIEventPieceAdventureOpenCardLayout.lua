require "lua.client.core.network.event.eventPieceAdventure.PieceAdventureOpenCardData"

--- @class UIEventPieceAdventureOpenCardLayout : UIEventPieceAdventureLayout
UIEventPieceAdventureOpenCardLayout = Class(UIEventPieceAdventureOpenCardLayout, UIEventPieceAdventureLayout)

local countCard = 36

--- @param view UIEventPieceAdventureView
--- @param tab number
--- @param anchor UnityEngine_RectTransform
function UIEventPieceAdventureOpenCardLayout:Ctor(view, tab, anchor)
    --- @type RootIconView
    self.currentItem = nil
    ---@type UIEventPieceAdventureOpenCardConfig
    self.layoutConfig = nil
    ---@type List
    self.listCard = List()
    ---@type Dictionary
    self.listKeyItem = Dictionary()
    --- @type boolean
    self.canUnlockFloor = false
    ---@type List
    self.listMoneyBar = List()
    ---@type Dictionary
    self.listKeyItemClaimed = Dictionary()
    ---@type List
    self.listIdClaimed = List()
    UIEventPieceAdventureLayout.Ctor(self, view, tab, anchor)
end

function UIEventPieceAdventureOpenCardLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("piece_adventure_open_card", self.anchor)
    UIEventPieceAdventureLayout.InitLayoutConfig(self, inst)
    self:InitButtonListener()
    self:InitLocalization()
    self:InitScroll()
end

function UIEventPieceAdventureOpenCardLayout:InitLocalization()
    UIEventPieceAdventureLayout.InitLocalization(self)
    self.layoutConfig.textReward.text = LanguageUtils.LocalizeCommon("floor_reward_list")
    self.layoutConfig.textButtonNextFloor.text = LanguageUtils.LocalizeCommon("next_floor")
    self.layoutConfig.textButtonStart.text = LanguageUtils.LocalizeCommon("start")
    self.layoutConfig.textButtonOpenAll.text = LanguageUtils.LocalizeCommon("open_all_card")
    self.layoutConfig.textTut.text = LanguageUtils.LocalizeCommon("open_card_tut_text")
end

function UIEventPieceAdventureOpenCardLayout:InitButtonListener()
    self.layoutConfig.buttonStart.onClick:AddListener(function()
        self:OnClickStart()
    end)
    self.layoutConfig.buttonNextFloor.onClick:AddListener(function()
        self:OnClickUnlockFloor()
    end)
    self.layoutConfig.buttonOpenAll.onClick:AddListener(function()
        local canOpen = InventoryUtils.IsEnoughSingleResourceRequirement(
                RewardInBound.CreateBySingleParam(ResourceType.Money ,MoneyType.EVENT_PIECE_ADVENTURE_KEY ,1))
        if canOpen then
            self:OnClickOpenCardAll()
        end
    end)
end

function UIEventPieceAdventureOpenCardLayout:OnShow()
    UIEventPieceAdventureLayout.OnShow(self)
    self.layoutConfig.bgTouch.gameObject:SetActive(false)
    self:ReturnPoolCard()
    self:ReturnPoolCardWish()
    self:SetActiveButtonNextFloor(self.eventModel.isFirstTime)

    for i = 1, countCard do
        --- @type PieceAdventureOpenCardItemView
        local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.PieceAdventureOpenCardItemView, self.layoutConfig.content)
        item.config.button.interactable = true
        item:AddListener(function ()
            self:OnClickOpenCard(i)
        end)
        self.listCard:Add(item)
    end

    self:InitListIDClaimed()
    self:InitCardReward(self.eventModel.isFirstTime)
    self:InitCardWish()
    self:SetButtonNextFloorVisual()
    self:SetButtonOpenAllVisual()

    self.uiScroll:Resize(self.eventConfig:GetFloorCount(), math.max(0, self.eventModel.currentFloor - 3))
end

function UIEventPieceAdventureOpenCardLayout:InitScroll()
    --- @param obj PieceAdventureLevelRewardItem
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        obj:SetData(dataIndex, self.eventConfig:GetRewardByFloor(dataIndex))
        obj:SetClaim(dataIndex < self.eventModel.currentFloor)
        if dataIndex == self.eventConfig:GetFloorCount() and self.listKeyItemClaimed:Count() == self.eventModel:GetPieceAdventureOpenCardByFloor(self.eventModel.currentFloor).keyItemDict:Count() then
            obj:SetClaim(true)
        end
        obj:Highlight(dataIndex == self.eventModel.currentFloor)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollReward, UIPoolType.PieceAdventureLevelRewardItem, onCreateItem)
end

function UIEventPieceAdventureOpenCardLayout:CheckKeyIsClaimed(id)
    for i = 1, self.listIdClaimed:Count() do
        if id == self.listIdClaimed:Get(i) then
            return true
        end
    end
    return false
end

function UIEventPieceAdventureOpenCardLayout:SetButtonNextFloorVisual()
    if self.canUnlockFloor and self.eventModel.currentFloor ~= self.eventConfig:GetFloorCount() then
        self.layoutConfig.coverButtonNextFloor.gameObject:SetActive(false)
    else
        self.layoutConfig.coverButtonNextFloor.gameObject:SetActive(true)
    end
end

function UIEventPieceAdventureOpenCardLayout:SetButtonOpenAllVisual()
    local openCardData = self.eventModel:GetPieceAdventureOpenCardByFloor(self.eventModel.currentFloor)
    local currentValue = InventoryUtils.GetMoney(MoneyType.EVENT_PIECE_ADVENTURE_KEY)

    if openCardData.openedCardPositionDict:Count() == countCard or currentValue < 1 or self.eventModel.isFirstTime == true then
        self.layoutConfig.coverButtonOpenAll.gameObject:SetActive(true)
    else
        self.layoutConfig.coverButtonOpenAll.gameObject:SetActive(false)
    end
end

function UIEventPieceAdventureOpenCardLayout:InitListIDClaimed()
    self.listIdClaimed = List()
    for k,v in pairs(self.eventModel:GetPieceAdventureOpenCardByFloor(self.eventModel.currentFloor).openedCardPositionDict:GetItems()) do
        self.listIdClaimed:Add(k)
    end
end

function UIEventPieceAdventureOpenCardLayout:ShowEffect(isActive)
    for i = 1, countCard do
        --- @type PieceAdventureOpenCardItemView
        local item = self.listCard:Get(i)
        item:ShowEffect(isActive)
    end
end

function UIEventPieceAdventureOpenCardLayout:InitCardReward(isFirstTime)
    for i = 1, countCard do
        --- @type PieceAdventureOpenCardItemView
        local item = self.listCard:Get(i)
        --- @type PieceAdventureOpenCardData
        local openCardData = self.eventModel:GetPieceAdventureOpenCardByFloor(self.eventModel.currentFloor)

        if isFirstTime == false then
            local isKeyItem = openCardData:CheckIsKeyItemCard(i - 1)
            item.config.button.interactable = true

            if openCardData ~= nil then
                local dataId = openCardData.openedCardPositionDict:Get(i - 1)
                if dataId ~= nil then
                    local reward = nil
                    if isKeyItem then
                        reward = self.eventConfig:GetKeyRewardById(dataId)
                    else
                        reward = self.eventConfig:GetRegularRewardById(dataId)
                    end
                    if reward ~= nil then
                        item:SetIconData(reward:GetIconData())
                        if isKeyItem then
                            item.config.button.interactable = false
                        end
                    else
                        XDebug.Error("NIL card " .. dataId)
                    end
                else
                    item:HideItem()
                end
            end
        else
            local dataId = nil
            --- @type RewardInBound
            local reward = nil
            local listDataId = List()
            for _, v in pairs(openCardData.keyItemDict:GetItems()) do
                listDataId:Add(v)
            end
            if i <= openCardData.keyItemDict:Count() then
                dataId = listDataId:Get(i)
                reward = self.eventConfig:GetKeyRewardById(dataId)
            else
                reward = self.eventConfig:GetRegularRewardWithoutNumberById(1)
            end

            item:SetIconData(reward:GetIconData())
        end
    end

    self.layoutConfig.textCurrentFloor.text = string.format("%s : %s", LanguageUtils.LocalizeCommon("piece_adventure_floor"), self.eventModel.currentFloor)
end

function UIEventPieceAdventureOpenCardLayout:InitCardWish()
    self:ReturnPoolCardWish()
    self.listKeyItem = Dictionary()
    self.listKeyItemClaimed = Dictionary()
    self.canUnlockFloor = false
    --- @type PieceAdventureOpenCardData
    local openCardData = self.eventModel:GetPieceAdventureOpenCardByFloor(self.eventModel.currentFloor)
    for k,v in pairs(openCardData.keyItemDict:GetItems()) do
        ---@type RootIconView
        local itemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.layoutConfig.keyItem)
        local reward = self.eventConfig:GetKeyRewardById(v)
        itemView:SetIconData(reward:GetIconData())
        itemView:RegisterShowInfo()
        self.listKeyItem:Add(k, itemView)
        for k1,v1 in pairs(openCardData.openedCardPositionDict:GetItems()) do
            if k == k1 then
                itemView:ActiveMaskSelect(true)
                self.canUnlockFloor = true
                self.listKeyItemClaimed:Add(k, itemView)
            end
        end
    end

    if self.eventModel.currentFloor == self.eventConfig:GetFloorCount() then
        self.canUnlockFloor = false
    end
end

function UIEventPieceAdventureOpenCardLayout:SetActiveButtonNextFloor(isActive)
    self.layoutConfig.buttonNextFloor.gameObject:SetActive(not isActive)
    self.layoutConfig.buttonStart.gameObject:SetActive(isActive)
end

function UIEventPieceAdventureOpenCardLayout:OnClickStart()
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
        end
        local onSuccess = function()
            self.coroutine1 = Coroutine.start(function()
                self.eventModel.isFirstTime = false
                self:ShowEffect(false)
                self:ShowEffect(true)
                self:InitCardReward(self.eventModel.isFirstTime)
                self:InitCardWish()
                self:SetButtonNextFloorVisual()
                self:SetButtonOpenAllVisual()
                self:SetActiveButtonNextFloor(self.eventModel.isFirstTime)
            end)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.EVENT_PIECE_ADVENTURE_START, nil, onReceived)
end

function UIEventPieceAdventureOpenCardLayout:OnClickOpenCard(index)
    --- @type PieceAdventureOpenCardItemView
    local item = self.listCard:Get(index)
    local openCardData = self.eventModel:GetPieceAdventureOpenCardByFloor(self.eventModel.currentFloor)
    local canOpen = InventoryUtils.IsEnoughSingleResourceRequirement(
            RewardInBound.CreateBySingleParam(ResourceType.Money ,MoneyType.EVENT_PIECE_ADVENTURE_KEY ,1))
    if canOpen and openCardData:CheckCanOpenCard(index - 1) then
        local onReceived = function(result)
            local idCard = nil
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                idCard = buffer:GetInt()
                self.rewards = NetworkUtils.GetListDataInBound(buffer ,RewardInBound.CreateByBuffer)
            end
            local onSuccess = function()
                InventoryUtils.Sub(ResourceType.Money ,MoneyType.EVENT_PIECE_ADVENTURE_KEY ,1)
                local isKeyItem = openCardData:CheckIsKeyItemCard(index - 1)

                openCardData:AddOpenCardPosition(index - 1 ,idCard)
                local iconData = nil

                if isKeyItem then
                    iconData = self.eventConfig:GetKeyRewardById(idCard)
                else
                    iconData = self.eventConfig:GetRegularRewardById(idCard)
                end

                item:SetIconData(iconData:GetIconData())
                item:ActiveEffectOpenCard(false)
                item:ActiveEffectOpenCard(true)

                if isKeyItem then
                    local itemKey = self.listKeyItem:Get(index - 1)
                    itemKey:ActiveMaskSelect(true)
                    self.canUnlockFloor = true
                    self.listKeyItemClaimed:Add(index - 1 ,item)
                    item.config.button.interactable = false

                    local rewardList = List()
                    rewardList:Add(iconData)
                    PopupUtils.ClaimAndShowRewardList(rewardList)
                else
                    item:ShowEffectOpenCardRegularReward()
                    iconData:AddToInventory()
                end

                self:SetButtonNextFloorVisual()
                self:SetButtonOpenAllVisual()

                if not self:CheckKeyIsClaimed(index - 1) then
                    self.listIdClaimed:Add(index - 1)
                end
                zg.audioMgr:PlaySfxUi(SfxUiType.OPEN_CARD)
            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            NetworkUtils.ExecuteResult(result ,onBufferReading ,onSuccess ,onFailed)
        end
        NetworkUtils.Request(OpCode.EVENT_PIECE_ADVENTURE_OPEN_CARD ,UnknownOutBound.CreateInstance(PutMethod.Int ,index - 1) ,onReceived)
    end
end

function UIEventPieceAdventureOpenCardLayout:OnClickOpenCardAll()
    local openCardData = self.eventModel:GetPieceAdventureOpenCardByFloor(self.eventModel.currentFloor)
    local openCardDataInbound = nil

    local openAllCard = function()
        local onReceived = function(result)
            local rewards = nil
            local onBufferReading = function(buffer)
                rewards = NetworkUtils.GetListDataInBound(buffer ,RewardInBound.CreateByBuffer)
                openCardDataInbound = PieceAdventureOpenCardData(buffer)
            end
            local onSuccess = function()
                openCardData:SetOpenedCardDict(openCardDataInbound.openedCardPositionDict)
                openCardData:SetKeyItemsDict(openCardDataInbound.keyItemDict)
                for k,v in pairs(openCardData.openedCardPositionDict:GetItems()) do
                    for i = 1, countCard do
                        if (i - 1) == k and self:CheckKeyIsClaimed(i - 1) == false then
                            InventoryUtils.Sub(ResourceType.Money ,MoneyType.EVENT_PIECE_ADVENTURE_KEY ,1)

                            local item = self.listCard:Get(i)
                            local isKeyItem = openCardData:CheckIsKeyItemCard(i - 1)

                            local iconData = nil

                            if isKeyItem then
                                iconData = self.eventConfig:GetKeyRewardById(v)
                            else
                                iconData = self.eventConfig:GetRegularRewardById(v)
                            end

                            item:SetIconData(iconData:GetIconData())
                            item:ActiveEffectOpenCard(false)
                            item:ActiveEffectOpenCard(true)

                            if isKeyItem then
                                local itemKey = self.listKeyItem:Get(i - 1)
                                itemKey:ActiveMaskSelect(true)
                                self.canUnlockFloor = true
                                self.listKeyItemClaimed:Add(i - 1 ,item)
                                item.config.button.interactable = false
                            else
                                item:ShowEffectOpenCardRegularReward()
                            end

                            self:SetButtonNextFloorVisual()
                            self:SetButtonOpenAllVisual()
                            if not self:CheckKeyIsClaimed(i - 1) then
                                self.listIdClaimed:Add(i - 1)
                            end
                            zg.audioMgr:PlaySfxUi(SfxUiType.OPEN_CARD)
                        end
                    end
                end
                PopupUtils.ClaimAndShowRewardList(rewards)
            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            NetworkUtils.ExecuteResult(result ,onBufferReading ,onSuccess ,onFailed)
        end
        NetworkUtils.Request(OpCode.EVENT_PIECE_ADVENTURE_OPEN_ALL_CARD ,nil ,onReceived)
    end
    if openCardData.openedCardPositionDict:Count() == countCard then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("claimed_all_card"))
    elseif self.eventModel.isFirstTime == true then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("not_click_start"))
    else
        if openAllCard ~= nil then
            openAllCard()
        end
        --PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_open_all"), nil, openAllCard)
    end
end

function UIEventPieceAdventureOpenCardLayout:OnClickUnlockFloor()
    local unlockFloor = function()
        local onReceived = function(result)
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                self.eventModel.currentFloor = buffer:GetInt()
                --- @type PieceAdventureOpenCardData
                local openCardData = PieceAdventureOpenCardData(buffer)
                self.eventModel.openedCardDict = openCardData
            end
            local onSuccess = function()
                self.coroutine = Coroutine.start(function()
                    self:InitListIDClaimed()
                    self.layoutConfig.bgTouch.gameObject:SetActive(true)
                    self:InitCardReward(true)
                    self:InitCardWish()
                    self:SetButtonNextFloorVisual()
                    self:SetButtonOpenAllVisual()
                    self:SetActiveButtonNextFloor(self.eventModel.isFirstTime)
                    self.uiScroll:Resize(self.eventConfig:GetFloorCount(), math.max(0, self.eventModel.currentFloor - 3))
                    coroutine.waitforseconds(1)
                    self:ShowEffect(false)
                    self:ShowEffect(true)
                    self:InitCardReward(false)
                    self.layoutConfig.bgTouch.gameObject:SetActive(false)
                end)
            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
        end
        NetworkUtils.Request(OpCode.EVENT_PIECE_ADVENTURE_UNLOCK_FLOOR , nil, onReceived)
    end

    if self.canUnlockFloor then
        if self.listKeyItemClaimed:Count() == self.eventModel:GetPieceAdventureOpenCardByFloor(self.eventModel.currentFloor).keyItemDict:Count() then
            if unlockFloor ~= nil then
                unlockFloor()
            end
        else
            --PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_unlock_floor"), nil, unlockFloor)
            if unlockFloor ~= nil then
                unlockFloor()
            end
        end
    elseif self.eventModel.currentFloor == self.eventConfig:GetFloorCount() then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_floor"))
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("cannot_unlock_floor"))
    end
end

function UIEventPieceAdventureOpenCardLayout:SetUpLayout()
    UIEventPieceAdventureLayout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventPieceAdventureOpenCardLayout:ShowMoneyBar()
    ---@type MoneyBarView
    local moneyBarView1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyBarAnchor1)
    moneyBarView1:SetIconData(MoneyType.EVENT_PIECE_ADVENTURE_KEY)
    moneyBarView1.config.buttonInfo.interactable = true
    moneyBarView1.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView1:SetSize(0, 0)
    moneyBarView1.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView1:ShowInfo()
    end)
    ---@type MoneyBarView
    local moneyBarView2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyBarAnchor1)
    moneyBarView2:SetIconData(MoneyType.EVENT_PIECE_ADVENTURE_COIN)
    moneyBarView2.config.buttonInfo.interactable = true
    moneyBarView2.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView2:SetSize(0, 0)
    moneyBarView2.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView2:ShowInfo()
    end)
    self.listMoneyBar:Add(moneyBarView1)
    self.listMoneyBar:Add(moneyBarView2)
end

function UIEventPieceAdventureOpenCardLayout:ReturnPoolMoneyBar()
    ---@param v MoneyBarView
    for _, v in pairs(self.listMoneyBar:GetItems()) do
        v:ReturnPool()
    end
    self.listMoneyBar:Clear()
end

function UIEventPieceAdventureOpenCardLayout:ReturnPoolCard()
    ---@param v PieceAdventureOpenCardItemView
    for i, v in ipairs(self.listCard:GetItems()) do
        v:ReturnPool()
    end
    self.listCard:Clear()
end

function UIEventPieceAdventureOpenCardLayout:ReturnPoolCardWish()
    for i, v in pairs(self.listKeyItem:GetItems()) do
        v:ReturnPool()
    end
    self.listKeyItem:Clear()
end

function UIEventPieceAdventureOpenCardLayout:OnHide()
    UIEventPieceAdventureLayout.OnHide(self)
    self.listIdClaimed:Clear()
    self:ShowEffect(false)
    self:ReturnPoolMoneyBar()
    self:ReturnPoolCard()
    self:ReturnPoolCardWish()
end
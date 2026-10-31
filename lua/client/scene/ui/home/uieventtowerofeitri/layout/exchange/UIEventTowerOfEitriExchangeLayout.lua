--- @class UIEventTowerOfEitriExchangeLayout : UIEventTowerOfEitriLayout
UIEventTowerOfEitriExchangeLayout = Class(UIEventTowerOfEitriExchangeLayout, UIEventTowerOfEitriLayout)

local DEFAULT_POSITION = U_Vector3(0, -3.9, -99)
local TARGET_POSITION = U_Vector3(0, -6.1, -99)

--- @param view UIEventTowerOfEitriView
--- @param anchor UnityEngine_RectTransform
function UIEventTowerOfEitriExchangeLayout:Ctor(view, tab, anchor)
    ---@type UIEventTowerOfEitriView
    self.view = view
    ---@type UIEventTowerOfEitriExchangeLayoutConfig
    self.layoutConfig = nil
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_TOWER_OF_EITRI
    ---@type number
    self.currentHammerInPool = 0
    ---@type List
    self.listMoneyBar = List()
    UIEventTowerOfEitriLayout.Ctor(self, view, tab, anchor)
end

function UIEventTowerOfEitriExchangeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_tower_of_eitri_exchange_layout", self.anchor)
    UIEventTowerOfEitriLayout.InitLayoutConfig(self, inst)
    self:InitLocalization()
    self:InitButtonListener()
    self:InitScroll()
end

function UIEventTowerOfEitriExchangeLayout:SetUpLayout()
    UIEventTowerOfEitriLayout.SetUpLayout(self)
end

function UIEventTowerOfEitriExchangeLayout:InitLocalization()
    UIEventTowerOfEitriLayout.InitLocalization(self)
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("tower_of_eitri_exchange")
    self.layoutConfig.textTitleDetail.text = LanguageUtils.LocalizeCommon("tower_of_eitri_exchange_infor")
    self.layoutConfig.collectHammerButtonText.text = LanguageUtils.LocalizeCommon("collect")
end

function UIEventTowerOfEitriExchangeLayout:InitButtonListener()
    self.layoutConfig.backButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:CloseLayout()
    end)
    self.layoutConfig.buttonInfor.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_tower_of_eitri_exchange_info"))
    end)
    self.layoutConfig.collectHammerButton.onClick:AddListener(function()
        self:CollectHammer()
    end)
end

function UIEventTowerOfEitriExchangeLayout:InitMoneyBar()
    ---@type MoneyBarView
    local moneyBarView1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
    moneyBarView1:SetIconData(MoneyType.EVENT_DRAGON_TOWER_HAMMER)
    moneyBarView1.config.buttonInfo.interactable = true
    moneyBarView1.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView1:SetSize(0, 0)
    moneyBarView1.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView1:ShowInfo()
    end)
    ---@type MoneyBarView
    local moneyBarView2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
    moneyBarView2:SetIconData(MoneyType.EVENT_DRAGON_TOWER_COIN)
    moneyBarView2.config.buttonInfo.interactable = true
    moneyBarView2.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView2:SetSize(0, 0)
    moneyBarView2.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView2:ShowInfo()
    end)
    moneyBarView2:AddListener(function()
        self.view:SelectTab(EventTowerOfEitriTab.TOWER_BUNDLE)
    end)

    ---@type MoneyBarView
    local moneyBarView3 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
    moneyBarView3:SetIconData(MoneyType.EVENT_DRAGON_TOWER_INFINITY_COIN)
    moneyBarView3.config.buttonInfo.interactable = true
    moneyBarView3.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView3:SetSize(0, 0)
    moneyBarView3.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView3:ShowInfo()
    end)

    self.listMoneyBar:Add(moneyBarView1)
    self.listMoneyBar:Add(moneyBarView2)
    self.listMoneyBar:Add(moneyBarView3)
end

function UIEventTowerOfEitriExchangeLayout:ReturnPoolMoneyBar()
    ---@param v MoneyBarView
    for _, v in pairs(self.listMoneyBar:GetItems()) do
        v:ReturnPool()
    end
    self.listMoneyBar:Clear()
end

function UIEventTowerOfEitriExchangeLayout:CollectHammer()
    if self.currentHammerInPool == 0 then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("not_thing_to_claim"))
        return
    end
    local onReceived = function(result)
        --- @type List
        local listReward = List()
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            listReward = NetworkUtils.GetRewardInBoundList(buffer)
        end
        local onSuccess = function()
            self.eventModel:SetHammerInPool(0)
            self:ShowHammerInPool()
            PopupUtils.ClaimAndShowRewardList(listReward)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.EVENT_DRAGON_TOWER_EXCHANGE_BONUS_CLAIM, nil, onReceived)
end

function UIEventTowerOfEitriExchangeLayout:ShowHammerInPool()
    self.currentHammerInPool = self.eventModel:GetCurrentHammerInPool()
    self.layoutConfig.collectHammerTextDetail.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("hammer_in_pool"),
            UIUtils.SetColorString(UIUtils.green_light, self.currentHammerInPool))
    self:PlayAnimation()
end

function UIEventTowerOfEitriExchangeLayout:InitScroll()
    --- @param obj TowerOfEitriExchangeTitleView
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type Dictionary
        local exchangeRewardDict = self.eventConfig:GetExchangeRewardConfig()
        local listExchangeReward = exchangeRewardDict:Get(dataIndex)
        obj:SetData(dataIndex, listExchangeReward, function(stageId, id, price, item)
            self:OnClickOpen(stageId, id, price, item)
        end, self.eventModel)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.UIEventTowerOfEitriExchangeTitle, onCreateItem, onCreateItem)
end

--- @param item TowerOfEitriExchangeItemView
function UIEventTowerOfEitriExchangeLayout:OnClickOpen(stageId, id, price, item)
    --if stageId > self.eventModel:GetCurrentExchangeStage() then
    --    local content = LanguageUtils.LocalizeCommon("need_clear_previous_stage")
    --    SmartPoolUtils.ShowShortNotification(content)
    --    zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    --    return
    --end
    ---@type EventTowerOfEitriExchangeItemData
    local itemData = self.eventConfig:GetExchangeRewardItemById(id)
    if self.eventModel:GetNumberExchange(id) >= itemData.limit then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_exchange"))
        return
    end
    if InventoryUtils.GetMoney(MoneyType.EVENT_DRAGON_TOWER_COIN) + InventoryUtils.GetMoney(MoneyType.EVENT_DRAGON_TOWER_INFINITY_COIN) < price then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        local data = RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.EVENT_DRAGON_TOWER_COIN, price)
        return InventoryUtils.IsEnoughSingleResourceRequirement(data, true)
    end
    zg.audioMgr:PlaySfxUi(SfxUiType.CLAIM)
    local onReceived = function(result)
        --- @type List
        local listReward = List()
        ---@type number
        local numberHammerBonus
        ---@type number
        local exchangeStage
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            listReward = NetworkUtils.GetRewardInBoundList(buffer)
            exchangeStage = buffer:GetInt()
            numberHammerBonus = buffer:GetInt()
        end
        local onSuccess = function()
            PopupUtils.ClaimAndShowRewardList(listReward)

            self.eventModel:AddNumberExchange(id)
            self.eventModel:SetExchangeStage(exchangeStage)
            self.eventModel:AddHammerInPool(numberHammerBonus)

            InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_DRAGON_TOWER_COIN, self.eitriCoinUse)
            InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_DRAGON_TOWER_INFINITY_COIN, self.infinityCoinUse)
            self:ShowHammerInPool()
            self.view:UpdateNotificationByTab(EventTowerOfEitriTab.TOWER_EXCHANGE)
            self.uiScroll:RefreshCells(self.eventConfig:GetExchangeRewardConfig():Count())
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end

    local data = {}
    data.itemPrice = itemData.price
    data.itemData = itemData.itemData
    data.callbackExchange = function(eitriCoinUse, infinityCoinUse, isUseInfinityCoin)
        self.eitriCoinUse = eitriCoinUse
        self.infinityCoinUse = infinityCoinUse
        self.isUseInfinityCoin = isUseInfinityCoin
        NetworkUtils.Request(OpCode.EVENT_DRAGON_TOWER_EXCHANGE,
                UnknownOutBound.CreateInstance(PutMethod.Int, id, PutMethod.Int, 1, PutMethod.Bool, self.isUseInfinityCoin),
                onReceived)
    end

    PopupMgr.ShowPopup(UIPopupName.UIPopupExchangeTowerOfEitri, data)
    --
    --PopupUtils.ShowPopupNotificationUseResource(MoneyType.EVENT_DRAGON_TOWER_COIN, itemData.price, function()
    --    NetworkUtils.Request(OpCode.EVENT_DRAGON_TOWER_EXCHANGE,
    --            UnknownOutBound.CreateInstance(PutMethod.Int, id, PutMethod.Int, 1),
    --            onReceived)
    --end)
end

function UIEventTowerOfEitriExchangeLayout:PlayAnimation()
    local pos = self.layoutConfig.collectHammerPopup.transform.position
    if self.currentHammerInPool <= 0 then
        ---@type UnityEngine_Vector3
        self.coroutine = Coroutine.start(function()
            coroutine.waitforseconds(1)
            while true do
                coroutine.waitforendofframe()
                if pos.y <= -6.1 then
                    self.layoutConfig.collectHammerPopup.transform.position = TARGET_POSITION
                    break
                else
                    pos.y = pos.y - 0.1
                    self.layoutConfig.collectHammerPopup.transform.position = pos
                end
            end
        end)
    elseif self.currentHammerInPool > 0 and self.layoutConfig.collectHammerPopup.transform.position ~= DEFAULT_POSITION then
        self.coroutine = Coroutine.start(function()
            coroutine.waitforseconds(1)
            while true do
                coroutine.waitforendofframe()
                if pos.y >= -3.9 then
                    self.layoutConfig.collectHammerPopup.transform.position = DEFAULT_POSITION
                    break
                else
                    pos.y = pos.y + 0.1
                    self.layoutConfig.collectHammerPopup.transform.position = pos
                end
            end
        end)
    end
end

--- @return void
function UIEventTowerOfEitriExchangeLayout:StopCoroutine()
    if self.coroutine ~= nil then
        Coroutine.stop(self.coroutine)
        self.coroutine = nil
    end
end

function UIEventTowerOfEitriExchangeLayout:ResetTowerPosition()
    self.layoutConfig.collectHammerPopup.transform.position = DEFAULT_POSITION
end

function UIEventTowerOfEitriExchangeLayout:OnShow()
    UIEventTowerOfEitriLayout.OnShow(self)
    self.anchor.gameObject:SetActive(true)
    self:InitLocalization()
    self:InitMoneyBar()
    self.uiScroll:Resize(self.eventConfig:GetExchangeRewardConfig():Count())
    self:ResetTowerPosition()
    self:ShowHammerInPool()
end

function UIEventTowerOfEitriExchangeLayout:OnHide()
    UIEventTowerOfEitriLayout.OnHide(self)
    self:ReturnPoolMoneyBar()
    self:StopCoroutine()
    self.uiScroll:Hide()
end


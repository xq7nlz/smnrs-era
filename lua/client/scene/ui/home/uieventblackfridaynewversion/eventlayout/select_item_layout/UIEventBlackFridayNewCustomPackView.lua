--- @class UIEventBlackFridayNewCustomPackView
UIEventBlackFridayNewCustomPackView = Class(UIEventBlackFridayNewCustomPackView, UIPrefabView)

local MAX_ITEM_SELECT = 5

--- @param transform UnityEngine_Transform
--- @param packId number
--- @param view UIIapShopView
function UIEventBlackFridayNewCustomPackView:Ctor()
    --- @type OpCode
    self.opCode = OpCode.EVENT_BLACK_FRIDAY_SELECT_ITEM
    --- @type List<RootIconView>
    self.listSelectableBox = List()
    --- @type List<RootIconView>
    self.listSelectedBox = List()
    --- @type List
    self.listOfSelectedItem = List()

    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BLACK_FRIDAY_SALE
    UIPrefabView.Ctor(self)
end

function UIEventBlackFridayNewCustomPackView:SetPrefabName()
    self.prefabName = 'black_friday_new_custom_package'
    self.uiPoolType = UIPoolType.UIEventBlackFridayNewCustomPackView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIEventBlackFridayNewCustomPackView:SetConfig(transform)
    --- @type UIBlackFridayNewCustomPackageConfig
    self.config = UIBaseConfig(transform)
    self:InitButtonListener()
    self:GetModelConfig()
end

function UIEventBlackFridayNewCustomPackView:GetModelConfig()
    --- @type EventBlackFridayNewVersionModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end

function UIEventBlackFridayNewCustomPackView:InitLocalization()
    self.config.textWish.text = string.format(LanguageUtils.LocalizeCommon("select_5_reward"))
    self.config.textWillGet.text = LanguageUtils.LocalizeCommon("your_choice_text")
    self.config.textGetBonus.text = LanguageUtils.LocalizeCommon("get_bonus")
end

function UIEventBlackFridayNewCustomPackView:InitButtonListener()
    self.config.buttonGetBonus.onClick:AddListener(function()
        self:OnClickGetBonus()
    end)
end

function UIEventBlackFridayNewCustomPackView:OnClickGetBonus()
    if self.listOfSelectedItem:Count() < MAX_ITEM_SELECT then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_select_5_reward"))
    else
        local getBonus = function()
            require("lua.client.core.network.event.eventBlackFridayNewVersion.EventBlackFridayNewItemSelectOutBound")
            local outBound = EventBlackFridayNewItemSelectOutBound()
            outBound.selectItems = self.listOfSelectedItem
            local onReceived = function(result)
                --- @param buffer UnifiedNetwork_ByteBuf
                local onBufferReading = function(buffer)
                    --require "lua.client.core.network.event.eventBlackFridayNewVersion.EventBlackFridayCustomizePackInBound"
                    --- @type List
                    --local listCustomizePack = NetworkUtils.GetListDataInBound(buffer, EventBlackFridayCustomizePackInBound.CreateByBuffer)
                    --self.eventModel:UpdateListCustomizePack(listCustomizePack)
                    --print("Reading : " .. LogUtils.ToDetail(self.eventModel.listCustomizePack:GetItems()))
                end
                local onSuccess = function()
                    EventInBound.RequestEventDataByType(EventTimeType.EVENT_BLACK_FRIDAY_SALE, function()
                        self.view:SelectTab(self.view.model.listSubEvent:Get(2))
                    end)
                end
                local onFailed = function(logicCode)
                    SmartPoolUtils.LogicCodeNotification(logicCode)
                end
                NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
            end
            NetworkUtils.Request(self.opCode, outBound, onReceived)
        end

        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_get_bonus"), nil, getBonus)
    end
end

--- @return void
--- @param customizeProduct CustomizeProduct
--- @param customizePack CustomizePackStatisticsInBound
function UIEventBlackFridayNewCustomPackView:SetData(customizeProduct, view)
    --- @type CustomizeProduct
    self.data = customizeProduct
    --- @type UIEventBlackFridayNewVersionView
    self.view = view
    self:ShowPack()
end

function UIEventBlackFridayNewCustomPackView:ShowPack()

    self:GetListDailyReward()

    self:InitSelectable()
    self:InitSelected()
    self:UpdateBoxesView()
end

function UIEventBlackFridayNewCustomPackView:InitSelectable()
    if self.listSelectableBox:Count() > 0 then
        return
    end

    --- @param obj RootIconView
    local onCreateItem = function(obj, index)
        index = index + 1
        --- @type RewardInBound
        local rewardInBound = self.listReward:Get(index)
        obj:SetIconData(rewardInBound:GetIconData())
        if self.reachLimit then
            obj:SetActiveColor2(false)
        else
            obj:AddListener(function()
                self:ClickItem(index)
            end)
        end

        self.listSelectableBox:Add(obj)
    end

    self.uiScroll = UILoopScroll(self.config.itemSelectable, UIPoolType.RootIconView, onCreateItem)
    self.uiScroll.scroll.enabled = false
    self.uiScroll:Resize(self.listReward:Count())
end

function UIEventBlackFridayNewCustomPackView:InitSelected()
    if self.listSelectedBox:Count() > 0 then
        return
    end

    for i = 1, MAX_ITEM_SELECT do
        --- @type RootIconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.itemsSelecting)
        self.listSelectedBox:Add(iconView)
    end
end

---@param index number
function UIEventBlackFridayNewCustomPackView:ClickItem(index)
    if self.listOfSelectedItem:IsContainValue(index) then
        -- Deselect
        self:SelectItem(index, false)
    elseif self.listOfSelectedItem:Count() < MAX_ITEM_SELECT then
        -- Select
        self:SelectItem(index, true)
    else
        -- Reach max
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("have_max_items"))
    end
end

---@param index number
function UIEventBlackFridayNewCustomPackView:SelectItem(index, isSelect)
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)

    if isSelect then
        self.listOfSelectedItem:Add(index)
    else
        self.listOfSelectedItem:RemoveOneByReference(index)
    end

    ---@type RootIconView
    local obj = self.listSelectableBox:Get(index)
    obj:ActiveUIPool(UIPoolType.MaskSelected, isSelect)

    self:UpdateBoxesView()
end

function UIEventBlackFridayNewCustomPackView:UpdateBoxesView()
    -- SelectedBox
    local selectedCount = self.listOfSelectedItem:Count()
    --- @param v RootIconView
    for i, v in ipairs(self.listSelectedBox:GetItems()) do
        if (i <= selectedCount) then
            ---@type number
            local objIndex = self.listOfSelectedItem:Get(i)
            ---@type RewardInBound
            local reward = self.listReward:Get(objIndex)
            v:SetIconData(reward:GetIconData())
            v:RegisterShowInfo()
        else
            local itemIconData = ItemIconData()
            itemIconData:SetData(ResourceType.Money,MoneyType.None)
            v:SetIconData(itemIconData)
            v:RemoveAllListeners()
        end
    end
end

function UIEventBlackFridayNewCustomPackView:ReturnItemsToPool()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end

    ---@param v RootIconView
    for _, v in pairs(self.listSelectedBox:GetItems()) do
        v:ReturnPool()
    end

    self.listSelectableBox = List()
    self.listSelectedBox = List()
end

function UIEventBlackFridayNewCustomPackView:CanBuy()
    return not self.reachLimit
end

function UIEventBlackFridayNewCustomPackView:GetListDailyReward()
    self.listReward = List()

    self.listReward = self.data.listRewardWithoutNumber
end

--- @return void
function UIEventBlackFridayNewCustomPackView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    self:ReturnItemsToPool()
end

return UIEventBlackFridayNewCustomPackView
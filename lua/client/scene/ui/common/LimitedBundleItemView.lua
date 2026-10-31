--- @class LimitedBundleItemView : MotionIconView
LimitedBundleItemView = Class(LimitedBundleItemView, MotionIconView)

function LimitedBundleItemView:Ctor()
    --- @type ExchangeEventConfig
    self.exchangeData = nil
    --- @type LimitedBundleItemConfig
    self.config = nil
    --- @type List
    self.listItemSlot = List()
    --- @type List
    self.listItem = List()
    --- @type List
    self.listItemSelect = List()
    MotionIconView.Ctor(self)
end

function LimitedBundleItemView:SetPrefabName()
    self.prefabName = 'item_limited_bundle'
    self.uiPoolType = UIPoolType.LimitedBundleItemView
end

--- @param transform UnityEngine_Transform
function LimitedBundleItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    self.config = UIBaseConfig(transform)
    self.config.buttonBuy.onClick:AddListener(function ()
        self:OnClickBuy()
    end)
    self.config.buttonFree.onClick:AddListener(function ()
        self:OnClickBuy()
    end)
end

function LimitedBundleItemView:InitLocalization()
    self.config.textFree.text = LanguageUtils.LocalizeCommon("free")
    self.config.textBuy.text = LanguageUtils.LocalizeCommon("buy")
    self.localizeLimitX = LanguageUtils.LocalizeCommon("limit_x")
    self.localizeNoLimit = LanguageUtils.LocalizeCommon("no_limit")
end

function LimitedBundleItemView:ReturnPoolItemDefault()
    ---@param v ItemIconView
    for i, v in ipairs(self.listItem:GetItems()) do
        v:ReturnPool()
    end
    self.listItem:Clear()
end

function LimitedBundleItemView:ReturnPoolItemSlot()
    ---@param v ItemIconView
    for i, v in ipairs(self.listItemSlot:GetItems()) do
        v:ReturnPool()
    end
    self.listItemSlot:Clear()
end

function LimitedBundleItemView:ReturnPoolItemSelect()
    ---@param v ItemIconView
    for i, v in ipairs(self.listItemSelect:GetItems()) do
        v:ReturnPool()
    end
    self.listItemSelect:Clear()
end

function LimitedBundleItemView:ReturnPool()
    IconView.ReturnPool(self)
    self:ReturnPoolItemSelect()
    self:ReturnPoolItemDefault()
    self:ReturnPoolItemSlot()
end

function LimitedBundleItemView:SetData(dataId, packId)
    self.dataId = dataId
    self.packId = packId
    --- @type EventMergeServerModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MERGE_SERVER)
    ---@type EventMergeServerProduct
    self.data = ResourceMgr.GetPurchaseConfig():GetMergeServerBundle():GetPack(self.dataId):GetPackBase(self.packId)
    self:UpdateLimit()

    if self.data.isFree == true then
        self.config.buttonFree.gameObject:SetActive(true)
        self.config.buttonBuy.gameObject:SetActive(false)
    else
        self.config.buttonFree.gameObject:SetActive(false)
        self.config.buttonBuy.gameObject:SetActive(true)

        local price = zg.iapMgr:GetLocalPrizeString(ClientConfigUtils.GetPurchaseKey(self.data.opCode, packId, dataId))
        self.config.textValue.text = price
    end

    self:CreateItemSlot()
    self:CreateItemDefault()
    self:CreateItemSelect()
end

function LimitedBundleItemView:CreateItemSlot()
    self:ReturnPoolItemSlot()
    if self.data.numberSelect > 0 then
        for i = 1, self.data.numberSelect do
            ---@type SlotHeroIconView
            local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SlotHeroIconView, self.config.reward)
            local index = i
            iconView:AddListener(function ()
                self:SelectItem()
            end)
            self.listItemSlot:Add(iconView)
        end
    end
end

function LimitedBundleItemView:CreateItemDefault()
    self:ReturnPoolItemDefault()
    ---@param v RewardInBound
    for i, v in ipairs(self.data.rewardList:GetItems()) do
        ---@type ItemIconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.reward)
        iconView:SetIconData(v:GetIconData())
        iconView:RegisterShowInfo()
        self.listItem:Add(iconView)
    end
end

function LimitedBundleItemView:CreateItemSelect()
    self:ReturnPoolItemSelect()
    ---@type List
    local listSelectId = self.eventModel.itemSelectDict:Get(self.packId)
    if listSelectId ~= nil then
        ---@param v RewardInBound
        for i, v in ipairs(listSelectId:GetItems()) do
            ---@type SlotHeroIconView
            local slot = self.listItemSlot:Get(i)
            ---@type ItemIconView
            local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, slot.config.slot_hero)
            iconView:SetIconData(self.data.rewardPool:Get(v):GetIconData())
            --iconView:RegisterShowInfo()
            self.listItemSelect:Add(iconView)
        end
    end
end

function LimitedBundleItemView:SelectItem()
    local listItem = List()
    local listItemSelect = List()
    ---@param v RewardInBound
    for i, v in ipairs(self.data.rewardPool:GetItems()) do
        local item = v:GetIconData()
        item.index = i
        listItem:Add(item)
    end
    local listSelectId = self.eventModel.itemSelectDict:Get(self.packId)
    if listSelectId ~= nil then
        for _, v in ipairs(listSelectId:GetItems()) do
            listItemSelect:Add(listItem:Get(v))
        end
    end
    local data = {}
    data.listItem = listItem
    data.listItemSelect = listItemSelect
    data.minSelect = self.data.numberSelect
    data.maxSelect = self.data.numberSelect
    ---@param list List
    data.callbackSelect = function(list)
        if list:Count() == self.data.numberSelect then
            local listIndex = List()
            ---@param v RewardInBound
            for i, v in ipairs(list:GetItems()) do
                listIndex:Add(v.index)
            end
            require("lua.client.core.network.event.eventMergeServer.SelectItemBundleOutBound")
            local outBound = SelectItemBundleOutBound(self.packId, listIndex)
            NetworkUtils.RequestAndCallback(OpCode.EVENT_SERVER_MERGE_BUNDLE_ITEM_SELECT, outBound, function ()
                self.eventModel.itemSelectDict:Add(self.packId, listIndex)
                self:CreateItemSelect()
                PopupMgr.HidePopup(UIPopupName.UISelectItemPool)
            end)
        else
            SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("select_x_item"), self.data.numberSelect))
        end
    end
    PopupMgr.ShowPopup(UIPopupName.UISelectItemPool, data)
end

function LimitedBundleItemView:UpdateLimit()
    if self.data.isLimited == true then
        local color = UIUtils.green_dark
        local number = self.eventModel:GetNumberBuy(EventActionType.SERVER_MERGE_LIMITED_BUNDLE, self.packId)
        if number >= self.data.stock then
            color = UIUtils.red_dark
        end
        self.config.textLimit.text = string.format(self.localizeLimitX, string.format("<color=#%s>%s/%s</color>", color, self.data.stock - number, self.data.stock))
    else
        self.config.textLimit.text = self.localizeNoLimit
    end
end

function LimitedBundleItemView:CanBuy()
    local numberBought = self.eventModel:GetNumberBuy(EventActionType.SERVER_MERGE_LIMITED_BUNDLE, self.packId)
    return (self.data.stock - numberBought) > 0
end

function LimitedBundleItemView:OnClickBuy()
    if self:CanBuy() then
        self.data = ResourceMgr.GetPurchaseConfig():GetMergeServerBundle():GetPack(self.dataId):GetPackBase(self.packId)
        ---@type List
        local listSelect = self.eventModel.itemSelectDict:Get(self.packId)
        if self.data.numberSelect == nil or self.data.numberSelect == 0
                or (listSelect ~= nil and self.data.numberSelect == listSelect:Count()) then
            local packKey = self.packKey
            if self.data ~= nil then
                packKey = ClientConfigUtils.GetPurchaseKey(self.data.opCode, self.data.id, self.data.dataId)
            end

            self.data.listSelectReward = List()
            local listSelectId = self.eventModel.itemSelectDict:Get(self.packId)
            ---@param v RewardInBound
            for i, v in ipairs(self.data.rewardPool:GetItems()) do
                if listSelectId:IsContainValue(i) then
                    self.data.listSelectReward:Add(v)
                end
            end

            BuyUtils.InitListener(function()
                PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, function()
                    --self.eventModel:AddNumberBuy(EventActionType.SERVER_MERGE_LIMITED_BUNDLE, self.packId, 1)
                    self:UpdateLimit()
                end)
            end)
            RxMgr.purchaseProduct:Next(packKey)
        else
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("select_x_item"), self.data.numberSelect))
        end
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

return LimitedBundleItemView
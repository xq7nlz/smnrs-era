--- @class IdleEffectBundleItemView : MotionIconView
IdleEffectBundleItemView = Class(IdleEffectBundleItemView, MotionIconView)
--- @param transform UnityEngine_Transform
function IdleEffectBundleItemView:Ctor(transform)
    --- @type UnityEngine_Transform
    self.transform = transform
    --- @type ExchangeEventConfig
    self.exchangeData = nil
    --- @type IapIdleEffectBundlePackItemConfig
    self.config = nil
    --- @type List
    self.listItemSlot = List()
    --- @type List
    self.listItem = List()
    --- @type List
    self.listItemSelect = List()
    MotionIconView.Ctor(self,transform)
    self:SetConfig(self.transform)
    self:InitLocalization()
    self.isSoldOut = false
    self.iconSelectView = nil
end

function IdleEffectBundleItemView:SetPrefabName()
    self.prefabName = 'iap_idle_effect_bundle_pack_item'
    self.uiPoolType = UIPoolType.IapIdleEffectBundlePackItem
end

--- @param transform UnityEngine_Transform
function IdleEffectBundleItemView:SetConfig(transform)
    MotionIconView.SetConfig(self,self.transform)
    self.config = UIBaseConfig(self.transform)
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(function ()
        self:OnClickBuy()
    end)
end

function IdleEffectBundleItemView:InitLocalization()
    self.localizeLimitX = LanguageUtils.LocalizeCommon("limit_x")
    self.localizeNoLimit = LanguageUtils.LocalizeCommon("no_limit")
    self.localizeSoldOut = LanguageUtils.LocalizeCommon("sold_out")
    if self.packId ~= nil then
        self.config.textDesc.text = LanguageUtils.LocalizeCommon("idle_effect_bundle_".. self.packId)
    end
end

function IdleEffectBundleItemView:ReturnPoolItemDefault()
    ---@param v ItemIconView
    for i, v in ipairs(self.listItem:GetItems()) do
        v:ReturnPool()
    end
    self.listItem:Clear()
end

function IdleEffectBundleItemView:ReturnPoolItemSlot()
    ---@param v ItemIconView
    for i, v in ipairs(self.listItemSlot:GetItems()) do
        v:ReturnPool()
    end
    self.listItemSlot:Clear()
    self.iconSelectView = nil
end

function IdleEffectBundleItemView:ReturnPoolItemSelect()
    ---@param v ItemIconView
    for i, v in ipairs(self.listItemSelect:GetItems()) do
        v:ReturnPool()
    end
    self.listItemSelect:Clear()
end

function IdleEffectBundleItemView:ReturnPool()
    IconView.ReturnPool(self)
    self:ReturnPoolItemSelect()
    self:ReturnPoolItemDefault()
    self:ReturnPoolItemSlot()
end

function IdleEffectBundleItemView:SetData(dataId, packId)
    self.dataId = dataId
    self.packId = packId
    --- @type EventIdleEffectModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_IDLE_EFFECT_BUNDLE)
    if packId == 4 then
        self.data = ResourceMgr.GetPurchaseConfig():GetRandomIdleEffectBundle():GetPack(self.dataId):GetPackBase(self.packId)
    else
        self.data = ResourceMgr.GetPurchaseConfig():GetIdleEffectBundle():GetPack(self.dataId):GetPackBase(self.packId)
    end
    ---@type EventIdleEffectProduct
    self:UpdateLimit()
    --self.config.bonus1stPurchase.gameObject:SetActive(self.data.isHot == true)
    if self.data.isFree == true then
        self.config.textPrice.text = LanguageUtils.LocalizeCommon("free")

    else
        local purchaseKey = ClientConfigUtils.GetPurchaseKey(self.data.opCode, packId, dataId)

        local number = self.eventModel:GetNumberBuy(self.packId)
        if number >= self.data.stock and  self.data.stock ~= -1 then
            self.config.textPrice.text = self.localizeSoldOut
        else
            local price = zg.iapMgr:GetLocalPrizeString(purchaseKey)
            self.config.textPrice.text =  price
        end
    end
    self:InitLocalization()
    self:CreateItemSlot()
    self:CreateItemDefault()
    self:CreateItemSelect()
    self:CanBuy()
end



function IdleEffectBundleItemView:CreateItemSlot()
    self:ReturnPoolItemSlot()
    if self.data.numberSelect > 0 then
        for i = 1, self.data.numberSelect do
            ---@type SlotHeroIconView
            local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SlotHeroIconView, self.config.rewardAnchor)
            local index = i
            iconView:AddListener(function ()
                self:SelectItem(iconView)
            end)
            self:UpdateIconViewChange(iconView)
            self.listItemSlot:Add(iconView)
        end
    end
end

function IdleEffectBundleItemView:UpdateIconViewChange(iconView)
    self.iconSelectView = iconView
    iconView:ActiveUIPool(UIPoolType.Change,
            not self.isSoldOut and self:SlotSelected() , U_Vector2(130, 130))
end

function IdleEffectBundleItemView:CreateItemDefault()
    self:ReturnPoolItemDefault()
    ---@param v RewardInBound
    for i, v in ipairs(self.data.rewardList:GetItems()) do
        if v.type ~= ResourceType.IDLE_EFFECT and v.id ~= MoneyType.VIP_POINT then
            ---@type ItemIconView
            local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardAnchor)
            iconView:SetIconData(v:GetIconData())
            iconView:RegisterShowInfo()
            self.listItem:Add(iconView)
        end
        if v.id == MoneyType.VIP_POINT then
            self.config.textVip.text = v.number
        end
    end
end


function IdleEffectBundleItemView:SlotSelected()
    local listSelectId = self.eventModel.packSelectedItemDict:Get(self.packId)
    local slotSelected
    if (listSelectId ~= nil and listSelectId:Count() > 0) then
        return true
    end
    return false
end

function IdleEffectBundleItemView:CreateItemSelect()
    -- index in list select id
    self:ReturnPoolItemSelect()
    ---@type List
    local listSelectId = self.eventModel.packSelectedItemDict:Get(self.packId)
    local slotSelected = self:SlotSelected()
    for i = 1, self.listItemSlot:Count() do
        ---@type SlotHeroIconView
        local slot = self.listItemSlot:Get(i)
        ---@type ItemIconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, slot.config.slot_hero)
        if (slotSelected == true) then
            iconView:SetIconData(self.data.rewardPool:Get(listSelectId:Get(1)):GetIconData())
        end
        self.listItemSelect:Add(iconView)
        iconView:ActiveUIPool(UIPoolType.Noti, slotSelected ~= true)
        self:UpdateIconViewChange(iconView)
    end
end

---@param iconView SlotHeroIconView
function IdleEffectBundleItemView:SelectItem(iconView)
    if (self.isSoldOut) then
        local listSelectId = self.eventModel:GetSelectItemID(self.packId)
        local iconData = self.data.rewardPool:Get(listSelectId:Get(1)):GetIconData()
        PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = {["type"] = iconData.type, ["id"] = iconData.itemId}})
    else
        local listItem = List()
        local listItemSelect = List()
        ---@param v RewardInBound
        for i, v in ipairs(self.data.rewardPool:GetItems()) do
            local item = v:GetIconData()
            item.index = i
            listItem:Add(item)
        end
        local listSelectId = self.eventModel.packSelectedItemDict:Get(self.packId)
        if listSelectId ~= nil then
            for _, v in ipairs(listSelectId:GetItems()) do
                listItemSelect:Add(listItem:Get(v))
            end
        end
        local data = {}
        data.packId = self.packId
        data.numberSelect = self.data.numberSelect
        data.onSelectHeroSuccess = function(listIndex)
            self.eventModel:AddSelectItem(self.packId, listIndex)
            self:CreateItemSelect()
        end
        data.rewardSelectionList  = self.data.rewardPool
        data.selectedIndex = -1
        data.selectItems = List()
        if (listItemSelect:Count() > 0) then
            data.selectedIndex = listItemSelect:Get(1).index
            data.selectItems:Add(data.selectedIndex)
        end
        data.opCode = OpCode.EVENT_IDLE_EFFECT_BUNDLE_ITEM_SELECT
        PopupMgr.ShowPopup(UIPopupName.UIPreviewIdleEffectFragment,data)
    end

end

function IdleEffectBundleItemView:UpdateLimit()
    if self.data.isLimited == true then
        local color = UIUtils.green_dark
        local number = self.eventModel:GetNumberBuy(self.packId)
        if (number == nil) then
            print("number buy nil" , self.packId)
        end
        if (self.data.stock == nil) then
            print("stock nil")
        end
        local number = self.eventModel:GetNumberBuy(self.packId)
        if number >= self.data.stock then
            color = UIUtils.red_dark
            self.config.textPrice.text = self.localizeSoldOut
            self.config.button.transform:GetComponent(ComponentName.UnityEngine_UI_Image).color = U_Color(130,130,130,255);
        end
        self.config.textPurchaseLimit.text = string.format(self.localizeLimitX,
                string.format("<color=#%s>%s/%s</color>", color, self.data.stock - number, self.data.stock))
    elseif self.packId > 1 then
        self.config.textDesc.text = LanguageUtils.LocalizeCommon("idle_effect_bundle_".. self.packId)
    else
    end
    self:CanBuy()
end

function IdleEffectBundleItemView:CanBuy()
    local numberBought = self.eventModel:GetNumberBuy(self.packId)
    if self.data.stock == -1 then
        self.isSoldOut = false
        return true
    end
    self.isSoldOut = self.data.stock - numberBought <= 0
    return (not self.isSoldOut)
end

function IdleEffectBundleItemView:OnClickBuy()
    if self:CanBuy() then
        ---@type List
        local listSelect = self.eventModel.packSelectedItemDict:Get(self.packId)
        if self.data.numberSelect == nil or self.data.numberSelect == 0
                or (listSelect ~= nil and self.data.numberSelect == listSelect:Count()) then
            local packKey = self.packKey
            if self.data ~= nil then
                packKey = ClientConfigUtils.GetPurchaseKey(self.data.opCode, self.data.id, self.data.dataId)
            end

            self.data.listSelectReward = List()
            local listSelectId = self.eventModel.packSelectedItemDict:Get(self.packId)
            ---@param v RewardInBound
            for i, v in ipairs(self.data.rewardPool:GetItems()) do
                if listSelectId:IsContainValue(i) then
                    self.data.listSelectReward:Add(v)
                end
            end

            BuyUtils.InitListener(function()
                PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, function()
                    --self.eventModel:AddNumberBuy(self.packId, 1)
                    self:UpdateLimit()
                    if (self.iconSelectView ~= nil) then
                        self:UpdateIconViewChange(self.iconSelectView)
                    end
                    --self:CreateItemSelect()

                end)
            end)
            RxMgr.purchaseProduct:Next(packKey)
        else
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("select_item_idle_effect_bundle"), self.data.numberSelect))
        end
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

return IdleEffectBundleItemView
--- @class ServerWeekBundleItem3View : MotionIconView
ServerWeekBundleItem3View = Class(ServerWeekBundleItem3View, MotionIconView)

function ServerWeekBundleItem3View:Ctor()
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
    self.isSoldOut = false
    self.iconSelectView = nil
end

function ServerWeekBundleItem3View:SetPrefabName()
    self.prefabName = 'item_server_week_bundle3'
    self.uiPoolType = UIPoolType.ServerWeekBundleItem3View
end

--- @param transform UnityEngine_Transform
function ServerWeekBundleItem3View:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    self.config = UIBaseConfig(transform)
    self.config.buttonBuy.onClick:AddListener(function ()
        self:OnClickBuy()
    end)
    --[[    self.config.buttonFree.onClick:AddListener(function ()
            self:OnClickBuy()
        end)]]
end

function ServerWeekBundleItem3View:InitLocalization()
    --self.config.textFree.text = LanguageUtils.LocalizeCommon("free")
    -- self.config.textBuy.text = LanguageUtils.LocalizeCommon("buy")
    self.localizeLimitX = LanguageUtils.LocalizeCommon("limit_x")
    self.localizeNoLimit = LanguageUtils.LocalizeCommon("no_limit")
end

function ServerWeekBundleItem3View:ReturnPoolItemDefault()
    ---@param v ItemIconView
    for i, v in ipairs(self.listItem:GetItems()) do
        v:ReturnPool()
    end
    self.listItem:Clear()
end

function ServerWeekBundleItem3View:ReturnPoolItemSlot()
    ---@param v ItemIconView
    for i, v in ipairs(self.listItemSlot:GetItems()) do
        v:ReturnPool()
    end
    self.listItemSlot:Clear()
    self.iconSelectView = nil
end

function ServerWeekBundleItem3View:ReturnPoolItemSelect()
    ---@param v ItemIconView
    for i, v in ipairs(self.listItemSelect:GetItems()) do
        v:ReturnPool()
    end
    self.listItemSelect:Clear()
end

function ServerWeekBundleItem3View:ReturnPool()
    IconView.ReturnPool(self)
    self:ReturnPoolItemSelect()
    self:ReturnPoolItemDefault()
    self:ReturnPoolItemSlot()
end

function ServerWeekBundleItem3View:SetData(dataId, packId)
    self.dataId = dataId
    --XDebug.Log("data id " .. tostring(dataId))
    self.packId = packId
    --- @type EventNewServerWeekModel3
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK_3)
    ---@type EventServerWeekProduct
    self.data = ResourceMgr.GetPurchaseConfig():GetServerWeekBundle3():GetPack(self.dataId):GetPackBase(self.packId)
    self:UpdateLimit()
    self.config.bonus1stPurchase.gameObject:SetActive(self.data.isHot == true)
    if self.data.isFree == true then
        --self.config.buttonFree.gameObject:SetActive(true)
        -- self.config.buttonBuy.gameObject:SetActive(false)
        self.config.textValue.text = LanguageUtils.LocalizeCommon("free")

    else
        -- self.config.buttonFree.gameObject:SetActive(false)
        --self.config.buttonBuy.gameObject:SetActive(true)
        local purchaseKey = ClientConfigUtils.GetPurchaseKey(self.data.opCode, packId, dataId)

        local price = zg.iapMgr:GetLocalPrizeString(purchaseKey)
        -- print("price is " , price , " purchaseKey " , purchaseKey)
        --self.config.textValue.text = price
        self.config.textValue.text =  price
    end
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconServerWeekBundle, self.packId)
    self.config.packIcon:SetNativeSize()
    self:CreateItemSlot()
    self:CreateItemDefault()
    self:CreateItemSelect()
    self:CanBuy()
end



function ServerWeekBundleItem3View:CreateItemSlot()
    self:ReturnPoolItemSlot()
    --print("hoangpl number item select " , self.data.numberSelect)
    if self.data.numberSelect > 0 then
        for i = 1, self.data.numberSelect do
            ---@type SlotHeroIconView
            local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SlotHeroIconView, self.config.reward)
            local index = i
            iconView:AddListener(function ()
                self:SelectItem(iconView)
            end)

            self:UpdateIconViewChange(iconView)

            self.listItemSlot:Add(iconView)
            -- XDebug.Log("LIST COUNT " .. tostring(self.listItemSlot:Count()))
        end
    end
end

function ServerWeekBundleItem3View:UpdateIconViewChange(iconView)
    self.iconSelectView = iconView
    if (iconView ~= nil) then
        iconView:ActiveUIPool(UIPoolType.Change,
                not self.isSoldOut and self:SlotSelected() , U_Vector2(130, 130))
    end
end

function ServerWeekBundleItem3View:CreateItemDefault()
    self:ReturnPoolItemDefault()
    ---@param v RewardInBound
    for i, v in ipairs(self.data.rewardList:GetItems()) do
        ---@type ItemIconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.reward)
        iconView:SetIconData(v:GetIconData())
        iconView:RegisterShowInfo()
        iconView:SetActiveColor(not self.isSoldOut)
        self.listItem:Add(iconView)
    end
end


function ServerWeekBundleItem3View:SlotSelected()
    local listSelectId = self.eventModel.packSelectedItemDict:Get(self.packId)
    local slotSelected
    if (listSelectId ~= nil and listSelectId:Count() > 0) then
        return true
    end
    return false
end

function ServerWeekBundleItem3View:CreateItemSelect()
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
        iconView:SetActiveColor(not self.isSoldOut)
        self:UpdateIconViewChange(iconView)
        --iconView:RegisterShowInfo()
    end

    --[[    if (listSelectId == nil or listSelectId:Count() == 0) then
            --iconView:ActiveUIPool(UIPoolType.Noti, false)
        else
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
        end]]




    --
end

---@param iconView SlotHeroIconView
function ServerWeekBundleItem3View:SelectItem(iconView)
    if (self.isSoldOut) then
        local listSelectId = self.eventModel.packSelectedItemDict:Get(self.packId)
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
            --PopupMgr.HidePopup(UIPopupName.UIPreviewServerWeekFragment)
        end
        data.rewardSelectionList  = self.data.rewardPool
        data.selectedIndex = -1
        data.selectItems = List()
        if (listItemSelect:Count() > 0) then
            data.selectedIndex = listItemSelect:Get(1).index
            data.selectItems:Add(data.selectedIndex)
        end
        data.opCode = OpCode.EVENT_NEW_SERVER_OPEN_3_BUNDLE_ITEM_SELECT
        PopupMgr.ShowPopup(UIPopupName.UIPreviewServerWeekFragment,data)
    end

end

function ServerWeekBundleItem3View:UpdateLimit()
    if self.data.isLimited == true then
        local color = UIUtils.green_dark
        local number = self.eventModel:GetNumberBuy(self.packId)
        if (number == nil) then
            print("number buy nil" , self.packId)
        end
        if (self.data.stock == nil) then
            print("stock nil")
        end
        if number >= self.data.stock then
            color = UIUtils.red_dark
        end
        --XDebug.Log("limit now hoangpl stock " .. tostring(self.data.stock) .. " Number " .. tostring(number))
        self.config.textLimit.text = string.format(self.localizeLimitX, string.format("<color=#%s>%s/%s</color>", color, self.data.stock - number, self.data.stock))
    else
        self.config.textLimit.text = self.localizeNoLimit
    end
    self:CanBuy()
    self:SetActiveColor(not self.isSoldOut)
    ---@param v ItemIconView
    for i, v in ipairs(self.listItem:GetItems()) do
        v:SetActiveColor(not self.isSoldOut)
    end
    ---@param v ItemIconView
    for i, v in ipairs(self.listItemSelect:GetItems()) do
        v:SetActiveColor(not self.isSoldOut)
    end
end

function ServerWeekBundleItem3View:CanBuy()
    local numberBought = self.eventModel:GetNumberBuy(self.packId)
    self.isSoldOut = self.data.stock - numberBought <= 0
    return (not self.isSoldOut)
end

function ServerWeekBundleItem3View:OnClickBuy()
    --XDebug.Log("CLICK BUY")
    if self:CanBuy() then
        self.data = ResourceMgr.GetPurchaseConfig():GetServerWeekBundle3():GetPack(self.dataId):GetPackBase(self.packId)
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
            SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("select_item_server_week_bundle"), self.data.numberSelect))
        end
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

return ServerWeekBundleItem3View
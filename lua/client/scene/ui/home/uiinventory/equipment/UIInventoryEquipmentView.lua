require "lua.client.scene.ui.utils.uiSelect.UISelectCustomSprite"

--- @class UIInventoryEquipmentView
UIInventoryEquipmentView = Class(UIInventoryEquipmentView)

--- @return void
--- @param transform UnityEngine_Transform
--- @param view UIInventoryView
function UIInventoryEquipmentView:Ctor(view, transform, model)
    --- @type UIInventoryView
    self.view = view
    ---@type UIInventoryModel
    self.model = model
    ---@type List --<id>
    self.itemDic = nil

    -- UI
    ---@type UIInventoryEquipmentConfig
    ---@type UIInventoryEquipmentConfig
    self.config = UIBaseConfig(transform)

    self:SelectFaction()
    self:InitScroll()
end

function UIInventoryEquipmentView:SelectFaction()
    local onChangeSelect = function(indexTab)
        if indexTab == nil then
            self.config.iconSelect.gameObject:SetActive(false)
        else
            self.config.iconSelect.gameObject:SetActive(true)
            self.config.iconSelect.transform.position = self.config.selectType:GetChild(indexTab - 1).position
        end
        self:Sort()
    end
    self.selectType = UISelectRarityFilter(self.config.selectType, nil, nil, onChangeSelect)
    self.selectType:SetSprite()
end

function UIInventoryEquipmentView:InitScroll()
    --- @param obj ItemIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        local type = ResourceType.ItemEquip
        local id = self.itemDic:Get(index + 1)
        local number = InventoryUtils.Get(type, id)
        obj:EnableButton(true)
        obj:SetIconData(ItemIconData.CreateInstance(type, id, number))
        obj:AddListener(function()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            self:OnClickItem(id)
        end)
    end
    ---@type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.ItemIconView, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig(0, 0, 0, 0.02, 5))
end

--- @param canPlayMotion boolean
function UIInventoryEquipmentView:Show(canPlayMotion)
    self.canPlayMotion = canPlayMotion or false
    self.selectType:Select(nil)
end

--- @return void
function UIInventoryEquipmentView:Hide()
    self.uiScroll:Hide()
end

--- @return void
function UIInventoryEquipmentView:Sort()
    if self.selectType.indexTab ~= nil then
        self.itemDic = InventoryUtils.GetEquipment(nil, 1, self.selectType.indexTab)
    else
        self.itemDic = InventoryUtils.GetEquipment(nil, 1)
    end
    local itemCount = self.itemDic:Count()
    self.uiScroll:Resize(itemCount)
    self.view:EnableEmpty(itemCount == 0)
    if self.canPlayMotion == true then
        self.uiScroll:PlayMotion()
        self.canPlayMotion = false
    end
end

--- @return void
function UIInventoryEquipmentView:OnClickItem(id)
    local number = InventoryUtils.Get(ResourceType.ItemEquip, id)
    local numberSell = 0
    local price = 0
    ---@type EquipmentDataEntry
    local dataEquipment = ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:Get(id)
    local callbackSellItem = function()
        PopupMgr.HidePopup(UIPopupName.UIItemPreview)
        InventoryUtils.Sub(ResourceType.ItemEquip, id, numberSell)
        InventoryUtils.Add(ResourceType.Money, MoneyType.GOLD, price)
        SmartPoolUtils.ShowReward1Item(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.GOLD, price))
        if self.model.sellItemDict:IsContainKey(id) then
            self.model.sellItemDict:Add(id, self.model.sellItemDict:Get(id) + numberSell)
        else
            self.model.sellItemDict:Add(id, numberSell)
        end
        self:Sort()
    end
    ---@param moneyBar MoneyBarView
    local onChangeInput = function(value, moneyBar)
        numberSell = value
        price = dataEquipment.price * value
        moneyBar:SetMoneyText(price)
    end

    PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = ResourceType.ItemEquip, ["id"] = id,
                                                                  ["input"] = { ["number"] = 1, ["min"] = 1, ["max"] = number, ["onChangeInput"] = onChangeInput },
                                                                  ["moneyType"] = MoneyType.GOLD,
                                                                  ["button2"] = { ["name"] = LanguageUtils.LocalizeCommon("sell"), ["callback"] = callbackSellItem } } })
end
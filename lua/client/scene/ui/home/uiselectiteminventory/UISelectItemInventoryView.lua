--- @class UISelectItemInventoryView : UIBaseView
UISelectItemInventoryView = Class(UISelectItemInventoryView, UIBaseView)

--- @return void
--- @param model UIInventoryModel
function UISelectItemInventoryView:Ctor(model, ctrl)
    --- @type number
    self.heroFaction = nil

    --- @type UISelect
    self.faction = nil

    ---@type UIInventoryConfig
    self.config = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type table
    self.funcShow = {}
    --- @type ResourceType
    self.type = nil
    --- @type number
    self.slot = nil
    --- @type number
    self.replaceId = nil
    --- @type function
    self.callbackSelectItem = nil

    UIBaseView.Ctor(self, model)
    --- @type UIInventoryModel
    self.model = self.model
    --- @type number
    self.replaceId = nil
end

--- @return void
function UISelectItemInventoryView:SelectFaction()
    local indexFaction = self.faction.indexTab or 1
    self.faction:Select(indexFaction)
end

--- @return void
function UISelectItemInventoryView:GetFaction()
    local faction = self.faction.indexTab
    if faction ~= nil and faction > 1 then
        faction = faction - 1
    else
        faction = nil
    end
    return faction
end

--- @return void
function UISelectItemInventoryView:OnReadyCreate()
    ---@type UISelectItemInventoryConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)

    --- @param obj ItemIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        local id = self.model.itemSort:Get(index + 1)
        local number = InventoryUtils.Get(self.type, id)
        obj:SetIconData(ItemIconData.CreateInstance(self.type, id, number))
        obj:RemoveAllListeners()
        obj:AddListener(function()
            if self.callbackSelectItem ~= nil then
                self.callbackSelectItem(id)
            end
        end)
    end
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.ItemIconView, onCreateItem, onCreateItem)

    --- function show
    self.funcShow[SlotEquipmentType.Weapon] = function()
        self:ShowListEquipment(EquipmentType.Weapon)
    end
    self.funcShow[SlotEquipmentType.Armor] = function()
        self:ShowListEquipment(EquipmentType.Armor)
    end
    self.funcShow[SlotEquipmentType.Helm] = function()
        self:ShowListEquipment(EquipmentType.Helm)
    end
    self.funcShow[SlotEquipmentType.Accessory] = function()
        self:ShowListEquipment(EquipmentType.Accessory)
    end
    self.funcShow[SlotEquipmentType.Artifact] = function()
        self:ShowListArtifact()
    end
end

--- @return void
function UISelectItemInventoryView:SetUpArtifact()
    --self.faction:Select(indexFaction)
    --XDebug.Log("set up artifact")
    self.config.factionFilter.transform.parent.gameObject:SetActive(true)
    local onChangeSelectFaction = function(indexTab, lastTab)

    end

    local onClickSelectFaction = function()
        self:UpdateArtifact()
    end
    --- @param obj UnityEngine_UI_Button
    --- @param isSelect boolean
    local onSelectFaction = function(obj, isSelect)
        if obj ~= nil then
            UIUtils.SetInteractableButton(obj, not isSelect)
            if isSelect then
                self.config.imageSelect.gameObject:SetActive(true)
                self.config.imageSelect.transform:SetParent(obj.transform)
                self.config.imageSelect.transform.localPosition = U_Vector3.zero
            end
        end
    end

    self.faction = UISelectFactionFilter(self.config.factionFilter, nil, onSelectFaction, onChangeSelectFaction, onClickSelectFaction)
    self.faction:SetSprite()
end

--- @return void
function UISelectItemInventoryView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("select_item")
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
end

function UISelectItemInventoryView:OnReadyShow(result)

    --XDebug.Log("disable artifact")
    --self.config.factionFilter.transform.parent.gameObject:SetActive(false)
    --[[
    if (isArtifactTab == true) then
        self:SetArtifact()
        self.faction:Select(1) --hoangpl temp
    end
    -]]

    self:Init(result)
    self:SetFactionFilter()

end

--- @return void
--- @param result EquipmentType
function UISelectItemInventoryView:Init(result)
    self.type = result.type
    self.slot = result.slot
    self.callbackSelectItem = result.callbackSelectItem
    self.funcShow[self.slot]()
    self.replaceId = result.replaceId
    self.heroFaction = result.faction
    if (self.type == ResourceType.ItemArtifact) then
        --self.faction.indexTab = self.heroFaction + 1 -- old
        self.faction.indexTab = 1
        self:UpdateArtifact()
    end

end

--- @return void
function UISelectItemInventoryView:ShowListEquipment(equipmentType)
    self.model.itemSort = InventoryUtils.GetEquipment(equipmentType, 1)
    self:ResizeScroll(self.model.itemSort:Count())
end

--- @return void
function UISelectItemInventoryView:ShowListArtifact()
    self:SetUpArtifact()
    self.model.itemSort = InventoryUtils.GetArtifactByFaction(1, nil, nil)
    self:ResizeScroll(self.model.itemSort:Count())
end

function UISelectItemInventoryView:SetFactionFilter()
    ---@type boolean
    local isArtifactTab = self.slot == SlotEquipmentType.Artifact
    self.config.factionFilter.transform.parent.gameObject:SetActive(isArtifactTab)
end

function UISelectItemInventoryView:UpdateArtifact()
    self:SelectFaction()
    local faction = self:GetFaction()
    self.model.itemSort = InventoryUtils.GetArtifactByFaction(1, nil, faction)
    self:ResizeScroll(self.model.itemSort:Count())
end

function UISelectItemInventoryView:ResizeScroll(count)
    self.uiScroll:Resize(count)
    self.config.empty:SetActive(count == 0)
end

function UISelectItemInventoryView:Hide()
    UIBaseView.Hide(self)
    self.config.empty:SetActive(false)
end
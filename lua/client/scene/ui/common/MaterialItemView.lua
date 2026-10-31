---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.MaterialItemConfig"

--- @class MaterialSelectData
MaterialSelectData = Class(MaterialSelectData)

--- @return void
function MaterialSelectData:Ctor()
    --- @type List
    self.listHeroSelect = List()
    --- @type Dictionary
    self.dictEquipSelect = Dictionary()
    --- @type Dictionary
    self.dictArtifactSelect = Dictionary()
end

--- @return void
function MaterialSelectData:Clear()
    self.listHeroSelect:Clear()
    self.dictEquipSelect:Clear()
    self.dictArtifactSelect:Clear()
end

--- @class MaterialItemView : IconView
MaterialItemView = Class(MaterialItemView, IconView)

--- @return void
function MaterialItemView:Ctor()
    ---@type MaterialExchange
    self.materialExchange = nil
    ---@type IconView
    self.iconView = nil
    ---@type ItemIconData
    self.iconData = nil
    ---@type number
    self.number = nil
    ---@type number
    self.full = nil
    --- @type MaterialSelectData
    self.materialSelectLocal = MaterialSelectData()
    --- @type MaterialSelectData
    self.materialSelectTotal = nil
    self.callbackSelectMaterials = nil
    IconView.Ctor(self)
end

--- @return void
function MaterialItemView:SetPrefabName()
    self.prefabName = 'material_item_view'
    self.uiPoolType = UIPoolType.MaterialItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function MaterialItemView:SetConfig(transform)
    assert(transform)
    --- @type MaterialItemConfig
    ---@type MaterialItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param materialExchange MaterialExchange
function MaterialItemView:SetMaterialExchange(materialExchange, materialSelectTotal, callbackSelectMaterials)
    self.materialSelectTotal = materialSelectTotal
    self.materialExchange = materialExchange
    self.callbackSelectMaterials = callbackSelectMaterials
    self.iconData = materialExchange:GetIconData()
    local quantity = self.iconData.quantity
    if self.iconData.type == ResourceType.Hero then
        self.iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.item)
        self:SetNumberData(0, quantity)
        self.iconData.quantity = nil
        self.iconView:SetIconData(self.iconData)
        self.iconView:SetSizeFragment()
        self.config.add:SetActive(false)
        self.iconView:AddListener(function ()
            self.iconView:ShowInfo()
            --self:OnClickSelectMaterial()
        end)
    else
        self.iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, self.config.item)
        self.config.add:SetActive(false)
        self:SetNumberData(0, quantity)
        self.iconView:AddListener(function ()
            self.iconView:ShowInfo()
            --self:OnClickSelectMaterial()
        end)
        self.iconData.quantity = nil
        self.iconView:SetIconData(self.iconData)
    end
    self.iconData.quantity = quantity
    self:OnClickSelectMaterial()
end

--- @return void
--- @param iconData ItemIconData
function MaterialItemView:SetMoneyItem(iconData)
    self.iconData = iconData
    local quantity = self.iconData.quantity
    self.iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, self.config.item)
    self:SetNumberData(InventoryUtils.Get(self.iconData.type, self.iconData.itemId), quantity)
    self.iconData.quantity = nil
    self.iconView:SetIconData(self.iconData)
    self.config.add:SetActive(false)
    self.iconData.quantity = quantity
end

--- @return void
--- @param number number
--- @param full number
function MaterialItemView:SetNumberData(number, full)
    self.number = number
    self.full = full
    if self.number == nil then
        self.number = 0
    end
    if self.full == nil then
        self.full = 0
    end
    self:UpdateNumberMaterial()
end

--- @return void
function MaterialItemView:OnClickSelectMaterial()
    if self.iconData.type == ResourceType.Hero then
        self:SelectHeroMaterial()
    elseif self.iconData.type == ResourceType.ItemEquip then
        self:SelectEquipmentMaterial()
    elseif self.iconData.type == ResourceType.ItemArtifact then
        self:SelectArtifactMaterial()
    end
end

--- @return void
function MaterialItemView:SelectHeroMaterial()
    local listSelected = List()
    local data = {}
    data.createUIScroll = function(scroll)
        ---@type List
        local heroList = InventoryUtils.Get(ResourceType.Hero)
        ---@type List
        local heroListCanSelect = List()
        for i = heroList:Count(), 1, -1 do
            ---@type HeroResource
            local heroResource = heroList:Get(i)
            if self.materialSelectTotal.listHeroSelect:IsContainValue(heroResource.inventoryId) == false
                    and (self.materialExchange.requirement1 == nil or self.materialExchange.requirement1 == heroResource.heroStar)
                    and (self.materialExchange.requirement2 == nil or self.materialExchange.requirement2 <= heroResource.heroLevel)
                    and (self.materialExchange.requirement3 == nil or self.materialExchange.requirement3 == ResourceMgr.GetHeroClassConfig():GetClass(heroResource.heroId))
                    and (self.materialExchange.requirement4 == nil or self.materialExchange.requirement4 == ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId))
                    and (self.materialExchange.requirement5 == nil or self.materialExchange.requirement5 == heroResource.heroId)
            then
                heroListCanSelect:Add(heroResource)
            end
        end
        for _, v in ipairs(self.materialSelectLocal.listHeroSelect:GetItems()) do
            listSelected:Add(v)
        end

        local onCreateItem = function(obj, index)
            ---@type HeroResource
            local heroResource = heroListCanSelect:Get(index + 1)
            if heroResource then
                ---@type HeroIconData
                local heroData = HeroIconData.CreateByHeroResource(heroResource)
                obj:SetIconData(heroData)
                if listSelected:IsContainValue(heroResource) then
                    obj:ActiveMaskSelect(true, UIUtils.sizeItem)
                else
                    obj:ActiveMaskSelect(false)
                end
            end
            obj:RemoveAllListeners()
            local noti = ClientConfigUtils.GetNotiLockHero(heroResource)
            obj:AddListener(function ()
                if noti ~= nil then
                    SmartPoolUtils.ShowShortNotification(noti)
                else
                    if listSelected:IsContainValue(heroResource) then
                        listSelected:RemoveOneByReference(heroResource)
                        obj:ActiveMaskSelect(false)
                    elseif listSelected:Count() < self.materialExchange.materialCount then
                        listSelected:Add(heroResource)
                        obj:ActiveMaskSelect(true, UIUtils.sizeItem)
                    end
                end
            end)
            if noti ~= nil then
                obj:ActiveMaskLock(true, UIUtils.sizeItem)
            else
                obj:ActiveMaskLock(false)
            end
            obj:EnableButton(true)
            obj:SetSizeHeroView()
        end
        local uiScroll = UILoopScroll(scroll, UIPoolType.HeroIconView, onCreateItem, onCreateItem)
        uiScroll:Resize(heroListCanSelect:Count())
        return uiScroll
    end
    data.callbackSelect = function()
        for _, heroResource in pairs(self.materialSelectLocal.listHeroSelect:GetItems()) do
            self.materialSelectTotal.listHeroSelect:RemoveOneByReference(heroResource)
        end
        self.materialSelectLocal.listHeroSelect:Clear()
        for _, heroResource in pairs(listSelected:GetItems()) do
            self.materialSelectLocal.listHeroSelect:Add(heroResource)
            self.materialSelectTotal.listHeroSelect:Add(heroResource)
        end
        self.number = self.materialSelectLocal.listHeroSelect:Count()
        self:UpdateNumberMaterial()
        if self.callbackSelectMaterials ~= nil then
            self.callbackSelectMaterials()
        end
    end
    PopupMgr.ShowPopup(UIPopupName.UISelectMaterial, data)
end

--- @return void
---@param dictLocal Dictionary
---@param dictTotal Dictionary
---@param itemsDictCanSelect Dictionary
function MaterialItemView:SelectDictMaterial(dictLocal, dictTotal, itemsDictCanSelect, resourceType)
    ---@type List
    local itemsListCanSelect = List()
    ---@type List
    local listIndexSelect = List()
    local data = {}
    data.createUIScroll = function(scroll)
        local index = 1
        local numberItem
        for id, v in pairs(itemsDictCanSelect:GetItems()) do
            numberItem = dictLocal:Get(id)
            for i = 1, v do
                itemsListCanSelect:Add(id)
                if numberItem ~= nil and numberItem > 0 then
                    listIndexSelect:Add(index)
                    numberItem = numberItem - 1
                end
                index = index + 1
            end
        end

        local onCreateItem = function(obj, _index)
            local index = _index + 1
            ---@type ItemIconData
            local iconData = ItemIconData.CreateInstance(resourceType, itemsListCanSelect:Get(index))
            obj:SetIconData(iconData)
            if listIndexSelect:IsContainValue(index) then
                obj:ActiveMaskSelect(true, UIUtils.sizeItem)
            else
                obj:ActiveMaskSelect(false)
            end
            obj:RemoveAllListeners()
            obj:AddListener(function ()
                if listIndexSelect:IsContainValue(index) then
                    listIndexSelect:RemoveOneByReference(index)
                    obj:ActiveMaskSelect(false)
                elseif listIndexSelect:Count() < self.materialExchange.materialCount then
                    listIndexSelect:Add(index)
                    obj:ActiveMaskSelect(true, UIUtils.sizeItem)
                end
            end)
            obj:EnableButton(true)
        end
        local uiScroll = UILoopScroll(scroll, UIPoolType.ItemIconView, onCreateItem, onCreateItem)
        uiScroll:Resize(itemsListCanSelect:Count())
        return uiScroll
    end
    data.callbackSelect = function()
        for id, v in pairs(dictLocal:GetItems()) do
            local number = dictTotal:Get(id)
            if number > v then
                dictTotal:Add(id,number - v)
            else
                dictTotal:RemoveByKey(id)
            end

        end
        dictLocal:Clear()
        for i, index in pairs(listIndexSelect:GetItems()) do
            local id = itemsListCanSelect:Get(index)

            local number = dictLocal:Get(id)
            if number == nil then
                number = 0
            end
            dictLocal:Add(id, number + 1)
        end
        for id, v in pairs(dictLocal:GetItems()) do
            local number = dictTotal:Get(id)
            if number == nil then
                number = 0
            end
            dictTotal:Add(id, number + v)
        end
        self.number = listIndexSelect:Count()
        self:UpdateNumberMaterial()
        if self.callbackSelectMaterials ~= nil then
            self.callbackSelectMaterials()
        end
    end
    PopupMgr.ShowPopup(UIPopupName.UISelectMaterial, data)
end

--- @return void
---@param dictLocal Dictionary
---@param dictTotal Dictionary
---@param itemsDictCanSelect Dictionary
function MaterialItemView:AutoSelectMaterial(dictLocal, dictTotal, itemsDictCanSelect, resourceType)
    ---@type List
    local itemsListCanSelect = List()
    ---@type List
    local listIdSelect = List()
    for id, v in pairs(itemsDictCanSelect:GetItems()) do
        local index = 1
        for i = 1, v do
            itemsListCanSelect:Add(id)
            if listIdSelect:Count() < self.materialExchange.materialCount then
                listIdSelect:Add(index)
                index = index + 1
            end
        end
    end

    dictLocal:Clear()
    for i, index in pairs(listIdSelect:GetItems()) do
        local id = itemsListCanSelect:Get(index)

        local number = dictLocal:Get(id)
        if number == nil then
            number = 0
        end
        dictLocal:Add(id, number + 1)
    end
    for id, v in pairs(dictLocal:GetItems()) do
        local number = dictTotal:Get(id)
        if number == nil then
            number = 0
        end
        dictTotal:Add(id, number + v)
    end
    self.number = listIdSelect:Count()
    self:UpdateNumberMaterial()
    if self.callbackSelectMaterials ~= nil then
        self.callbackSelectMaterials()
    end
end

--- @return void
function MaterialItemView:SelectEquipmentMaterial()
    ---@type Dictionary
    local dictLocal = self.materialSelectLocal.dictEquipSelect
    ---@type Dictionary
    local dictTotal = self.materialSelectTotal.dictEquipSelect
    ---@type Dictionary
    local itemsDictCanSelect = Dictionary()
    ---@type Dictionary
    local items = InventoryUtils.Get(ResourceType.ItemEquip)
    for id, number in pairs(items:GetItems()) do
        ---@type EquipmentDataEntry
        local equipmentDataConfig = ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:Get(id)
        if (self.materialExchange.requirement1 == nil or self.materialExchange.requirement1 == equipmentDataConfig.star )
                and (self.materialExchange.requirement2 == nil or self.materialExchange.requirement2 == equipmentDataConfig.rarity)
                and (self.materialExchange.requirement5 == nil or self.materialExchange.requirement5 == equipmentDataConfig.id)
        then
            local currentLocal = dictLocal:Get(id)
            if currentLocal == nil then
                currentLocal = 0
            end
            local currentTotal = dictTotal:Get(id)
            if currentTotal == nil then
                currentTotal = 0
            end
            local numberCanSelect = number - currentTotal + currentLocal
            if numberCanSelect > 0 then
                itemsDictCanSelect:Add(id, numberCanSelect)
            end
        end
    end
    self:AutoSelectMaterial(dictLocal, dictTotal, itemsDictCanSelect, ResourceType.ItemEquip)
end

--- @return void
function MaterialItemView:SelectArtifactMaterial()
    ---@type Dictionary
    local dictLocal = self.materialSelectLocal.dictArtifactSelect
    ---@type Dictionary
    local dictTotal = self.materialSelectTotal.dictArtifactSelect
    ---@type Dictionary
    local itemsDictCanSelect = Dictionary()
    ---@type Dictionary
    local items = InventoryUtils.Get(ResourceType.ItemArtifact)
    for id, number in pairs(items:GetItems()) do
        ---@type ArtifactDataConfig
        local artifactDataConfig = ResourceMgr.GetServiceConfig():GetItems().artifactDataEntries:Get(id)
        if (self.materialExchange.requirement2 == nil or self.materialExchange.requirement2 == artifactDataConfig.rarity)
                and (self.materialExchange.requirement5 == nil or self.materialExchange.requirement5 == artifactDataConfig.id)
        then
            local currentLocal = dictTotal:Get(id)
            if currentLocal == nil then
                currentLocal = 0
            end
            local currentTotal = dictTotal:Get(id)
            if currentTotal == nil then
                currentTotal = 0
            end
            local numberCanSelect = number - currentTotal + currentLocal
            if numberCanSelect > 0 then
                itemsDictCanSelect:Add(id, numberCanSelect)
            end
        end
    end
    self:AutoSelectMaterial(dictLocal, dictTotal, itemsDictCanSelect, ResourceType.ItemArtifact)
end

--- @return void
function MaterialItemView:IsEnoughMaterial()
    return self.number >= self.full
end

--- @return void
function MaterialItemView:UpdateNumberMaterial()
    local color
    if self:IsEnoughMaterial() then
        self.iconView:SetActiveColor2(true)
        --self.iconView:ActiveMask(false)
        color = UIUtils.color2
    else
        self.iconView:SetActiveColor2(true)
        --self.iconView:ActiveMask(true, UIUtils.sizeItem)
        color = UIUtils.color7
    end
    self.config.textCount.text = string.format("<color=#%s>%s/%s</color>", color, ClientConfigUtils.FormatNumber(self.number), ClientConfigUtils.FormatNumber(self.full))
end

--- @return void
function MaterialItemView:ReturnPool()
    if self.iconView ~= nil then
        self.iconView:SetActiveColor(true)
        self.iconView:ReturnPool()
        self.iconView = nil
    end
    self.materialSelectLocal:Clear()
    self.callbackSelectMaterials = nil
    IconView.ReturnPool(self)
end

return MaterialItemView
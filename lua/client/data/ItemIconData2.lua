
--- @class ItemIconData2
ItemIconData2 = Class(ItemIconData2)

--- @return void
function ItemIconData2:Ctor()
    --- @type ResourceType
    self.type = nil
    --- @type number
    self.itemId = nil
    --- @type number
    self.star = nil
    --- @type string
    self.spriteName = StarsAtlas.starEquipment1
    --- @type number
    self.rarity = nil
    --- @type number
    self.quantity = nil
    --- @type number
    self.faction = nil
end


--- @return void
--- @param type ResourceType
--- @param itemId number
--- @param quantity number
function ItemIconData2:SetData(type, itemId, quantity, faction)
    self.type = type
    self.itemId = itemId
    self.quantity = quantity
    self.faction = faction
    if self.itemId ~= nil then
        self.rarity = ResourceMgr.GetServiceConfig():GetItemRarity(self.type, self.itemId)
        self.star = ResourceMgr.GetServiceConfig():GetItemStar(self.type, self.itemId)
    end
end

--- @return void
function ItemIconData2:AddToInventory()
    InventoryUtils.Add(self.type, self.itemId, self.quantity)
end

--- @return void
function ItemIconData2:SubToInventory()
    InventoryUtils.Sub(self.type, self.itemId, self.quantity)
end

--- @return ItemIconData2
--- @param data ItemIconData2
function ItemIconData2.Clone(data)
    local newItem = ItemIconData2.CreateInstance(data.type, data.itemId, data.quantity)
    newItem.rarity = data.rarity
    newItem.star = data.star
    return newItem
end

--- @return ItemIconData2
--- @param type ResourceType
--- @param itemId number
--- @param quantity number
function ItemIconData2.CreateInstance(type, itemId, quantity, data, faction)
    --- @type ItemIconData2
    local iconData
    if type == ResourceType.EvolveFoodMaterial and data ~= nil then
        iconData = ItemIconData2.CreateBuyHeroFood(itemId, data, quantity)
    else
        iconData = ItemIconData2()
        iconData:SetData(type, itemId, quantity, faction)
    end
    return iconData
end

--- @return ItemIconData2
--- @param selectionId number
--- @param type ResourceType
--- @param itemId number
--- @param quantity number
function ItemIconData2.CreateInSelectionInstance(selectionId,type, itemId, quantity, data)
    --- @type ItemIconData2
    local iconData
    if type == ResourceType.EvolveFoodMaterial and data ~= nil then
        iconData = ItemIconData2.CreateBuyHeroFood(itemId, data, quantity)
    else
        iconData = ItemIconData2()
        iconData:SetData(type, itemId, quantity)
        iconData.selectionId = selectionId
    end
    return iconData
end

--- @return RewardInBound
--- @param type ResourceType
--- @param itemId number
--- @param quantity number
function ItemIconData2:GetRewardInbound()
    return RewardInBound.CreateBySingleParam(self.type, self.itemId, self.quantity)
end

--- @return ItemIconData2
---@param heroFoodType HeroFoodType
---@param star number
---@param number number
function ItemIconData2.CreateBuyHeroFood(heroFoodType, star, number)
    local inst = ItemIconData2()
    inst:SetData(ResourceType.EvolveFoodMaterial, heroFoodType * 100 + star, number)
    return inst
end
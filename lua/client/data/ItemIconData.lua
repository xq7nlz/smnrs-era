
--- @class ItemIconData
ItemIconData = Class(ItemIconData)

--- @return void
function ItemIconData:Ctor()
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
end


--- @return void
--- @param type ResourceType
--- @param itemId number
--- @param quantity number
function ItemIconData:SetData(type, itemId, quantity)
    self.type = type
    self.itemId = itemId
    self.quantity = quantity
    if self.itemId ~= nil then
        self.rarity = ResourceMgr.GetServiceConfig():GetItemRarity(self.type, self.itemId)
        self.star = ResourceMgr.GetServiceConfig():GetItemStar(self.type, self.itemId)
    end
end

--- @return void
function ItemIconData:AddToInventory()
    InventoryUtils.Add(self.type, self.itemId, self.quantity)
end

--- @return void
function ItemIconData:SubToInventory()
    InventoryUtils.Sub(self.type, self.itemId, self.quantity)
end

--- @return ItemIconData
--- @param data ItemIconData
function ItemIconData.Clone(data)
    local newItem = ItemIconData.CreateInstance(data.type, data.itemId, data.quantity)
    newItem.rarity = data.rarity
    newItem.star = data.star
    return newItem
end

--- @return ItemIconData
--- @param type ResourceType
--- @param itemId number
--- @param quantity number
function ItemIconData.CreateInstance(type, itemId, quantity, data)
    --- @type ItemIconData
    local iconData
    if type == ResourceType.EvolveFoodMaterial and data ~= nil then
        iconData = ItemIconData.CreateBuyHeroFood(itemId, data, quantity)
    else
        iconData = ItemIconData()
        iconData:SetData(type, itemId, quantity)
    end
    return iconData
end

--- @return ItemIconData
--- @param selectionId number
--- @param type ResourceType
--- @param itemId number
--- @param quantity number
function ItemIconData.CreateInSelectionInstance(selectionId,type, itemId, quantity, data)
    --- @type ItemIconData
    local iconData
    if type == ResourceType.EvolveFoodMaterial and data ~= nil then
        iconData = ItemIconData.CreateBuyHeroFood(itemId, data, quantity)
    else
        iconData = ItemIconData()
        iconData:SetData(type, itemId, quantity)
        iconData.selectionId = selectionId
    end
    return iconData
end

--- @return RewardInBound
--- @param type ResourceType
--- @param itemId number
--- @param quantity number
function ItemIconData:GetRewardInbound()
    return RewardInBound.CreateBySingleParam(self.type, self.itemId, self.quantity)
end

--- @return ItemIconData
---@param heroFoodType HeroFoodType
---@param star number
---@param number number
function ItemIconData.CreateBuyHeroFood(heroFoodType, star, number)
    local inst = ItemIconData()
    inst:SetData(ResourceType.EvolveFoodMaterial, heroFoodType * 100 + star, number)
    return inst
end
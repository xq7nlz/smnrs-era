--- @class HeroEvolveMaterialOutBound : OutBound
HeroEvolveMaterialOutBound = Class(HeroEvolveMaterialOutBound, OutBound)

--- @return void
function HeroEvolveMaterialOutBound:Ctor(slotId, heroInventoryId, heroFoodType, heroFoodStar)
    --- @type number
    self.slotId = slotId
    --- @type boolean
    self.isHeroInventory = (heroInventoryId ~= nil)
    --- @type number
    self.heroInventoryId = heroInventoryId
    --- @type HeroFoodType
    self.heroFoodType = heroFoodType
    --- @type number
    self.heroFoodStar = heroFoodStar
    --- @type number
    self.index = nil
    --- @type number
    self.indexFood = nil
end

--- @return HeroIconData
function HeroEvolveMaterialOutBound:GetHeroIconData()
    if self.isHeroInventory then
        local heroResource = InventoryUtils.GetHeroResourceByInventoryId(self.heroInventoryId)
        if heroResource then
            return HeroIconData.CreateByHeroResource(heroResource)
        else
            return nil
        end
    else
        return ItemIconData.CreateBuyHeroFood(self.heroFoodType, self.heroFoodStar)
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function HeroEvolveMaterialOutBound:Serialize(buffer)
    buffer:PutByte(self.slotId)
    buffer:PutBool(self.isHeroInventory)
    if self.isHeroInventory then
        buffer:PutLong(self.heroInventoryId)
    else
        buffer:PutByte(self.heroFoodType)
        buffer:PutByte(self.heroFoodStar)
    end
end
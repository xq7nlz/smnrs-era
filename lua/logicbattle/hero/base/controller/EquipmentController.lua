--- @class EquipmentController
EquipmentController = Class(EquipmentController)

--- @return void
--- @param hero BaseHero
function EquipmentController:Ctor(hero)
    --- @type BaseHero
    self.myHero = hero

    --- @type Dictionary<HeroItemSlot, number>
    self.equipments = Dictionary()

    --- @type boolean
    self.isHideSkin = false
--[[    --- @type boolean
    self.isHideEffect = false]]
end

--- @return number itemId
--- @param heroItemSlot HeroItemSlot
--- @param itemId number
function EquipmentController:AddItem(heroItemSlot, itemId)
    self.equipments:Add(heroItemSlot, itemId)
end

--- @return number itemId
--- @param heroItemSlot HeroItemSlot
function EquipmentController:GetItem(heroItemSlot)
    return self.equipments:GetOrDefault(heroItemSlot, ItemConstants.NO_EQUIPMENT)
end

--- @return void
--- @param data string Csv line to parse
function EquipmentController:ParseCsv(data)
    for i = 1, ItemConstants.NUMBER_EQUIPMENT_SLOT do
        local itemId
        if data[ItemConstants.ITEM_TAG .. i] ~= nil then
            itemId = tonumber(data[ItemConstants.ITEM_TAG .. i])
        else
            itemId = ItemConstants.NO_EQUIPMENT
        end
        self:AddItem(i, itemId)
    end
end
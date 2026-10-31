--- @class StatChangerItemHelper
StatChangerItemHelper = Class(StatChangerItemHelper)

--- @return void
--- @param hero BaseHero
function StatChangerItemHelper:Ctor(hero)
    ---@type BaseHero
    self.myHero = hero

    ---@type ItemDataService
    self.itemDataService = nil
end

---------------------------------------- ITEM ----------------------------------------
--- @return void
--- @param itemDataService ItemDataService
function StatChangerItemHelper:InitItemBuff(itemDataService)
    self.itemDataService = itemDataService
    if self.myHero.equipmentController.equipments:Count() > 0 then
        for slot, itemId in pairs(self.myHero.equipmentController.equipments:GetItems()) do
            self:AddItemEffect(slot, itemId)
        end
        self:AddEquipmentSetEffect()
    end
end

--- @return void
function StatChangerItemHelper:AddEquipmentSetEffect()
    local equipmentSetCountMap = self.itemDataService:CountEquipmentSet(self.myHero.equipmentController.equipments)
    if equipmentSetCountMap:Count() > 0 then
        for setId, pieceCount in pairs(equipmentSetCountMap:GetItems()) do
            local equipmentSet = self.itemDataService:GetEquipmentSetData(setId)
            if equipmentSet ~= nil then
                equipmentSet:ApplyToHero(self.myHero, pieceCount)
            end
        end
    end
end

--- @return void
--- @param slot number
--- @param itemId number
function StatChangerItemHelper:AddItemEffect(slot, itemId)
    if slot == HeroItemSlot.ARTIFACT then
        local artifact = self.itemDataService:GetArtifactData(itemId)
        if artifact ~= nil then
            artifact:ApplyToHero(self.myHero)
        end
    elseif slot == HeroItemSlot.STONE then
        local stone = self.itemDataService:GetStoneData(itemId)
        if stone ~= nil then
            stone:ApplyToHero(self.myHero)
        end
    elseif slot == HeroItemSlot.SKIN then
        local skin = self.itemDataService:GetSkinData(itemId)
        if skin then
            skin:ApplyToHero(self.myHero)
        end
    elseif slot == HeroItemSlot.IDLE_EFFECT then
        local idleEffect = self.itemDataService:GetIdleEffectData(itemId)
        if idleEffect then
            idleEffect:ApplyToHero(self.myHero)
        end
    elseif slot == HeroItemSlot.TALENT_1
            or slot == HeroItemSlot.TALENT_2 then
        local talent = self.itemDataService:GetTalentData(itemId)
        if talent then
            talent:ApplyToHero(self.myHero)
        end
    else
        local equipment = self.itemDataService:GetEquipmentData(itemId)
        if equipment ~= nil then
            equipment:ApplyToHero(self.myHero)
        end
    end
end
require "lua.client.core.network.hero.HeroEvolveMaterialOutBound"
require "lua.client.core.network.hero.HeroEvolveOrbOutBound"

--- @class HeroEvolveOutBound : OutBound
HeroEvolveOutBound = Class(HeroEvolveOutBound, OutBound)

--- @return void
function HeroEvolveOutBound:Ctor(heroInventoryId)
    --- @type number
    self.heroInventoryId = heroInventoryId
    --- @type List
    self.heroMaterials = List()
    --- @type List
    self.heroOrbs = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function HeroEvolveOutBound:Serialize(buffer)
    buffer:PutLong(self.heroInventoryId)
    buffer:PutByte(self.heroMaterials:Count())
    for i = 1, self.heroMaterials:Count() do
        ---@type HeroEvolveMaterialOutBound
        local item = self.heroMaterials:Get(i)
        --XDebug.Log(LogUtils.ToDetail(item))
        item:Serialize(buffer)
    end
    buffer:PutByte(self.heroOrbs:Count())
    for i = 1, self.heroOrbs:Count() do
        ---@type HeroEvolveOrbOutBound
        local item = self.heroOrbs:Get(i)
        --XDebug.Log(LogUtils.ToDetail(item))
        item:Serialize(buffer)
    end
end

--- @return void
function HeroEvolveOutBound:GetCountSlot(slot)
    local count = 0
    ---@param v HeroEvolveMaterialOutBound
    for i, v in ipairs(self.heroMaterials:GetItems()) do
        if v.slotId == slot then
            count = count + 1
        end
    end
    return count
end

--- @return void
function HeroEvolveOutBound:GetDictSlot()
    local dictSlot = Dictionary()
    ---@param v HeroEvolveMaterialOutBound
    for i, v in ipairs(self.heroMaterials:GetItems()) do
        local current = dictSlot:Get(v.slotId)
        if current == nil then
            current = 0
        end
        dictSlot:Add(v.slotId, current + 1)
    end
    return dictSlot
end

--- @return void
function HeroEvolveOutBound:GetDictIndex()
    local dict = Dictionary()
    ---@param v HeroEvolveMaterialOutBound
    for i, v in ipairs(self.heroMaterials:GetItems()) do
        dict:Add(v.index, v)
    end
    return dict
end

--- @return void
function HeroEvolveOutBound:GetListIndexFood()
    ---@type List
    local list = List()
    ---@param v HeroEvolveMaterialOutBound
    for i, v in ipairs(self.heroMaterials:GetItems()) do
        if v.indexFood ~= nil then
            list:Add(v.indexFood)
        end
    end
    return list
end

--- @return void
function HeroEvolveOutBound:GetListHeroMaterial(list)
    ---@type List
    local listHero = list
    if listHero == nil then
        listHero = List()
    end
    ---@param v HeroEvolveMaterialOutBound
    for i, v in ipairs(self.heroMaterials:GetItems()) do
        if v.heroInventoryId ~= nil then
            listHero:Add(v.heroInventoryId)
        end
    end
    return listHero
end

--- @return List --<HeroFood>
function HeroEvolveOutBound:GetListHeroFood(list)
    ---@type List
    local listHero = list
    if listHero == nil then
        listHero = List()
    end
    ---@param v HeroEvolveMaterialOutBound
    for i, v in ipairs(self.heroMaterials:GetItems()) do
        if v.heroInventoryId == nil then
            ---@type ItemIconData
            local itemIconData = nil
            ---@param item ItemIconData
            for i, item in ipairs(listHero:GetItems()) do
                if item.type == v.heroFoodType and item.star == v.heroFoodStar then
                    itemIconData = item
                end
            end
            if itemIconData == nil then
                listHero:Add(HeroFood(v.heroFoodType, v.heroFoodStar, 1))
            else
                itemIconData.quantity = itemIconData.quantity + 1
            end
        end
    end
    return listHero
end

--- @return void
function HeroEvolveOutBound:ToString()
    local log = "HeroEvolveOutBound: "..LogUtils.ToDetail(self)
    for _, v in ipairs(self.heroMaterials:GetItems()) do
        log = log .. "\nHeroEvolveMaterialOutBound: "..LogUtils.ToDetail(v)
    end
    return log
end

--- @return void
function HeroEvolveOutBound:IsInPentagram()
    local raiseInbound = zg.playerData:GetRaiseLevelHero()
    if raiseInbound:IsInPentaGram(self.heroInventoryId) then
        return true
    end
    for i = 1, self.heroMaterials:Count() do
        ---@type HeroEvolveMaterialOutBound
        local data = self.heroMaterials:Get(i)
        if data.isHeroInventory and raiseInbound:IsInPentaGram(data.heroInventoryId) then
            return true
        end
    end
    return false
end
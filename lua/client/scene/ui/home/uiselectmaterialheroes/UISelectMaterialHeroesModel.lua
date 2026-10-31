--- @class UISelectMaterialHeroesModel : UIBaseModel
UISelectMaterialHeroesModel = Class(UISelectMaterialHeroesModel, UIBaseModel)

--- @return void
function UISelectMaterialHeroesModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UISelectMaterialHeroes, "select_material_heroes")
    ---@type List --HeroResource || HeroFood
    self.listCurrentFoodSelect = List()
    ---@type List --HeroResource[]
    self.listCurrentSlotSelect = List()
    ---@type List --HeroFood[]   -- input
    self.listCurrentHeroFoodSelect = List()
    ---@type number
    self.maxSelect = nil
    ---@type number
    self.heroId = nil
    ---@type number
    self.sortStar = nil
    ---@type number
    self.sortFaction = nil
    ---@type List
    self.listMaterial = nil
    ---@type List
    self.listHeroFoodSelect = nil
    ---@type HeroList
    self.heroList = nil
    --- @type List -- HeroResource[]
    self.heroListSort = List()
    ---@type List --<HeroResource>
    self.listAllSlotSelect = nil
    ---@type List --<HeroFood>
    self.listAllHeroFoodSelect = nil
    ---@type HeroResource
    self.heroResourceIgnor = nil
    ---@type HeroFood
    self.moonHeroFood = HeroFood()
    ---@type List
    self.listMoonHeroFoodSelect = List()
    ---@type HeroFood
    self.sunHeroFood = HeroFood()
    ---@type List
    self.listSunHeroFoodSelect = List()
    ---@type HeroFood
    self.heroFoodFaction = HeroFood()
    ---@type List
    self.listHeroFoodFactionSelect = List()

    self.bgDark = true
end

--- @return void
function UISelectMaterialHeroesModel:Sort()
    if self.listMaterial == nil then
        self.listMaterial = List()
    end
    self.listMaterial:Clear()

    self.listCurrentFoodSelect = List()

    self.heroList = InventoryUtils.Get(ResourceType.Hero)
    self.heroListSort = List()
    for i = 1, self.heroList:Count() do
        ---@type HeroResource
        local heroResource = self.heroList:Get(i)
        ---@type number
        local faction = ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId)
        if heroResource ~= self.heroResourceIgnor and
                (self.listAllSlotSelect:IsContainValue(heroResource) == false or self.listCurrentSlotSelect:IsContainValue(heroResource) == true) and
                (self.heroId == nil or self.heroId == heroResource.heroId) and
                (self.sortStar == nil or self.sortStar == 0 or heroResource.heroStar == self.sortStar) and
                (self.sortFaction == nil or self.sortFaction == 0 or faction == self.sortFaction) then
            self.heroListSort:Add(heroResource)
        end
    end

    self.moonHeroFood.star = self.sortStar
    self.sunHeroFood.star = self.sortStar
    self.heroFoodFaction.star = self.sortStar
    self.moonHeroFood.number = 0
    self.sunHeroFood.number = 0
    self.heroFoodFaction.number = 0
    self.listMoonHeroFoodSelect:Clear()
    self.listSunHeroFoodSelect:Clear()
    self.listHeroFoodFactionSelect:Clear()

    local listFoodMaterial = List()
    ---@type Dictionary
    local dictFood = Dictionary()

    if self.heroId == nil then
        ---@param v HeroFood
        for _, v in pairs(zg.playerData:GetMethod(PlayerDataMethod.HERO_EVOLVE_FOOD).listHeroFood:GetItems()) do
            if v.star == self.sortStar then
                if (self.sortFaction == nil or self.sortFaction == 0
                        or ClientConfigUtils.GetFoodFactionByFaction(self.sortFaction) == v.heroFoodType
                        or ClientConfigUtils.GetFoodMoonSunByFaction(self.sortFaction) == v.heroFoodType) then
                    dictFood:Add(v.heroFoodType, v.number)
                end
            end
        end

        local addFood = function(heroFoodType)
            local number = dictFood:Get(heroFoodType) or 0
            ---@param v HeroFood
            for _, v in pairs(self.listAllHeroFoodSelect:GetItems()) do
                if v.heroFoodType == heroFoodType then
                    number = number - v.number
                end
            end

            if number > 0 then
                local numberSelect = 0
                if self.listCurrentHeroFoodSelect ~= nil then
                    ---@param v HeroFood
                    for _, v in pairs(self.listCurrentHeroFoodSelect:GetItems()) do
                        if v.heroFoodType == heroFoodType then
                            numberSelect = numberSelect + v.number
                        end
                    end
                end

                for i = 1, number do
                    local heroFood = HeroFood(heroFoodType, self.sortStar, 1)
                    listFoodMaterial:Add(heroFood)
                    if numberSelect ~= nil and i <= numberSelect then
                        self.listCurrentFoodSelect:Add(heroFood)
                    end
                end
                dictFood:RemoveByKey(heroFoodType)
            end
        end

        if (self.sortFaction == nil or self.sortFaction == 0) then
            addFood(HeroFoodType.WATER)
            addFood(HeroFoodType.FIRE)
            addFood(HeroFoodType.ABYSS)
            addFood(HeroFoodType.NATURE)
            addFood(HeroFoodType.LIGHT)
            addFood(HeroFoodType.DARK)
            addFood(HeroFoodType.MOON)
            addFood(HeroFoodType.SUN)
        else
            addFood(ClientConfigUtils.GetFoodFactionByFaction(self.sortFaction))
            addFood(ClientConfigUtils.GetFoodMoonSunByFaction(self.sortFaction))
        end
    end

    table.sort(listFoodMaterial, function(a, b)
        return a.heroFoodType > b.heroFoodType
    end)
    for i, v in ipairs(self.heroListSort:GetItems()) do
        self.listMaterial:Add(v)
    end
    for i, v in ipairs(listFoodMaterial:GetItems()) do
        self.listMaterial:Add(v)
    end
end
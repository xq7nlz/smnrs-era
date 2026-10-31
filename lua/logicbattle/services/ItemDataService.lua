--- @class ItemDataService
ItemDataService = Class(ItemDataService)

--- @return void
function ItemDataService:Ctor()
    --- key: equipmentId, value: EquipmentDataEntry
    --- @type Dictionary<number, EquipmentDataEntry>
    self.equipmentDataEntries = Dictionary()

    --- key: setId, value: EquipmentSetDataEntry
    --- @type Dictionary<number, EquipmentSetDataEntry>
    self.equipmentSetDataEntries = Dictionary()

    --- key: set Passive Id, value: ItemPassiveData
    --- @type Dictionary<number, ItemPassiveData>
    self.itemPassiveDataEntries = Dictionary()

    --- key: artifact id, value: ArtifactDataEntry
    --- @type Dictionary<number, ArtifactDataEntry>
    self.artifactDataEntries = Dictionary()

    --- key: stone id, value: StoneDataEntry
    --- @type Dictionary<number, StoneDataEntry>
    self.stoneDataEntries = Dictionary()

    --- key: skin id, value: SkinDataEntry
    --- @type Dictionary<number, SkinDataEntry>
    self.skinDataEntries = Dictionary()

    --- key: skin id, value: IdleEffectDataEntry
    --- @type Dictionary<number, IdleEffectDataEntry>
    self.idleEffectDataEntries = Dictionary()

    --- key: talent stat id, value: TalentDataEntry
    --- @type Dictionary<number, TalentDataEntry>
    self.talentStatDataEntries = Dictionary()
end

--------------------------------------- Getter ---------------------------------------------
--- @return EquipmentDataEntry
--- @param equipmentId number
function ItemDataService:GetEquipmentData(equipmentId)
    return self.equipmentDataEntries:Get(equipmentId)
end

--- @return EquipmentSetDataEntry
--- @param setId number
function ItemDataService:GetEquipmentSetData(setId)
    return self.equipmentSetDataEntries:Get(setId)
end

--- @return ItemPassiveData
--- @param itemPassiveId number
function ItemDataService:GetItemPassiveData(itemPassiveId)
    return self.itemPassiveDataEntries:Get(itemPassiveId)
end

--- @return ArtifactDataEntry
--- @param artifactId number
function ItemDataService:GetArtifactData(artifactId)
    return self.artifactDataEntries:Get(artifactId)
end

--- @return StoneDataEntry
--- @param stoneId number
function ItemDataService:GetStoneData(stoneId)
    return self.stoneDataEntries:Get(stoneId)
end

--- @return SkinDataEntry
--- @param skinId number
function ItemDataService:GetSkinData(skinId)
    return self.skinDataEntries:Get(skinId)
end

--- @return IdleEffectDataEntry
--- @param idleEffectId number
function ItemDataService:GetIdleEffectData(idleEffectId)
    return self.idleEffectDataEntries:Get(idleEffectId)
end

--- @return TalentDataEntry
--- @param talentStatId number
function ItemDataService:GetTalentData(talentStatId)
    return self.talentStatDataEntries:Get(talentStatId)
end

--- @return List<StatBonus>
--- @param equipments Dictionary<number, number>
function ItemDataService:CountEquipmentSet(equipments)
    --- key: setId, value: number of set
    local result = Dictionary()
    for slot, itemId in pairs(equipments:GetItems()) do
        if itemId ~= ItemConstants.NO_EQUIPMENT and
                (slot == HeroItemSlot.WEAPON or slot == HeroItemSlot.ARMOR or
                        slot == HeroItemSlot.HELM or slot == HeroItemSlot.ACCESSORY) then
            local equipment = self:GetEquipmentData(itemId)
            if equipment ~= nil and equipment.setId ~= ItemConstants.NO_EQUIPMENT_SET then
                local numberItemOfSet = result:GetOrDefault(equipment.setId, 0)
                result:Add(equipment.setId, numberItemOfSet + 1)
            end
        end
    end

    return result
end

--------------------------------------- Setter --------------------------------------------
--- @return void
--- @param csv string
--- @param heroDataService HeroDataService
function ItemDataService:AddEquipmentData(csv, heroDataService)
    local parsedData = CsvReader.ReadContent(csv)
    --- @type EquipmentDataEntry
    local equipment
    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.id ~= nil then
            equipment = EquipmentDataEntry(data)
            --print(LogUtils.ToDetail(equipment))
            equipment:Validate()

            self.equipmentDataEntries:Add(equipment.id, equipment)
        end

        if equipment ~= nil then
            local itemOption = ItemUtils.CreateItemOption(data, heroDataService, self)
            equipment:AddOption(itemOption)
        else
            assert(false)
        end
    end
end

--- @return void
--- @param csv string
--- @param heroDataService HeroDataService
function ItemDataService:AddEquipmentSetData(csv, heroDataService)
    local parsedData = CsvReader.ReadContent(csv)
    ---@type EquipmentSetDataEntry
    local equipmentSet
    local pieceCount

    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.id ~= nil then
            equipmentSet = EquipmentSetDataEntry(data)
            --print(LogUtils.ToDetail(equipmentSet))
            equipmentSet:Validate()

            self.equipmentSetDataEntries:Add(equipmentSet.id, equipmentSet)
        end

        if equipmentSet ~= nil then
            if data.set_piece_count ~= nil then
                pieceCount = tonumber(data.set_piece_count)
            end

            if pieceCount ~= nil then
                local itemOption = ItemUtils.CreateItemOption(data, heroDataService, self)
                equipmentSet:AddOption(pieceCount, itemOption)
            else
                assert(false)
            end
        else
            assert(false)
        end
    end
end

--- @return void
--- @param csv string
--- @param heroDataService HeroDataService
function ItemDataService:AddArtifactData(csv, heroDataService)
    local parsedData = CsvReader.ReadContent(csv)
    ---@type ArtifactDataEntry
    local artifact
    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.id ~= nil then
            artifact = ArtifactDataEntry(data)
            --print(LogUtils.ToDetail(artifact))
            artifact:Validate()

            self.artifactDataEntries:Add(artifact.id, artifact)
        end

        if artifact ~= nil then
            local itemOption = ItemUtils.CreateItemOption(data, heroDataService, self)
            artifact:AddOption(itemOption)
        else
            assert(false)
        end
    end
end

--- @return void
--- @param csv string
--- @param heroDataService HeroDataService
function ItemDataService:AddStoneData(csv, heroDataService)
    local parsedData = CsvReader.ReadContent(csv)
    ---@type List
    local listGroup = List()
    ---@type StoneDataEntry
    local stone
    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.id ~= nil then
            stone = StoneDataEntry(data)
            stone:Validate()

            self.stoneDataEntries:Add(stone.id, stone)
            if listGroup:IsContainValue(stone.group) == false then
                listGroup:Add(stone.group)
            end
        end

        if stone ~= nil then
            local itemOption = ItemUtils.CreateItemOption(data, heroDataService, self)
            stone:AddOption(itemOption)
        else
            assert(false)
        end
    end

    for _, g in pairs(listGroup:GetItems()) do
        local totalRate = 0
        ---@param v StoneDataEntry
        for _, v in pairs(self.stoneDataEntries:GetItems()) do
            if v.group == g then
                totalRate = totalRate + v.rate
            end
        end
        local currentRate = 0
        ---@param v StoneDataEntry
        for _, v in pairs(self.stoneDataEntries:GetItems()) do
            if v.group == g then
                currentRate = currentRate + v.rate
                v.rate = 100 * currentRate / totalRate
            end
        end
    end
end

--- @return void
--- @param csv string
--- @param heroDataService HeroDataService
function ItemDataService:AddSkinData(csv, heroDataService)
    local parsedData = CsvReader.ReadContent(csv)

    --- @type SkinDataEntry
    local skin
    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.id ~= nil then
            skin = SkinDataEntry(data)
            skin:Validate()

            self.skinDataEntries:Add(skin.id, skin)
        end

        if skin ~= nil then
            local itemOption = ItemUtils.CreateItemOption(data, heroDataService, self)
            skin:AddOption(itemOption)
        else
            assert(false)
        end
    end
end

--- @return void
--- @param csv string
--- @param heroDataService HeroDataService
function ItemDataService:AddIdleEffectData(csv, heroDataService)
    local parsedData = CsvReader.ReadContent(csv)

    --- @type IdleEffectDataEntry
    local idleEffect
    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.id ~= nil then
            idleEffect = IdleEffectDataEntry(data)
            idleEffect:Validate()

            self.idleEffectDataEntries:Add(idleEffect.id, idleEffect)
        end

        if idleEffect ~= nil then
            if data.option_type ~= nil then
                local itemOption = ItemUtils.CreateItemOption(data, heroDataService, self)
                idleEffect:AddOption(itemOption)
            end
        else
            assert(false)
        end
    end
end

--- @return void
--- @param csv string
--- @param heroDataService HeroDataService
function ItemDataService:AddTalentStatData(csv, heroDataService)
    local parsedData = CsvReader.ReadContent(csv)

    --- @type TalentDataEntry
    local talentDataEntry
    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.id ~= nil then
            talentDataEntry = TalentDataEntry(data)
            talentDataEntry:Validate()

            self.talentStatDataEntries:Add(talentDataEntry.id, talentDataEntry)
        end

        if talentDataEntry ~= nil then
            local itemOption = ItemUtils.CreateItemOption(data, heroDataService, self)
            talentDataEntry:AddOption(itemOption)
        else
            assert(false)
        end
    end
end

--- @return void
--- @param id number
--- @param csv string
function ItemDataService:AddItemPassiveData(id, csv)
    local parsedData = CsvReader.ReadContent(csv)

    --- @type ItemPassiveData
    local data = parsedData[1]
    local itemPassiveData = ItemPassiveData()
    itemPassiveData:ParseCsv(data)

    self.itemPassiveDataEntries:Add(id, itemPassiveData)
end
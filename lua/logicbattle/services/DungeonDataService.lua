--- @class DungeonDataService
DungeonDataService = Class(DungeonDataService)

--- @return void
function DungeonDataService:Ctor()

    --- @type <formation_attacker, is_front, position>
    self.attackerConfig = nil

    --- @type List <number>
    self.stageList = nil

    --- key: active buff id, value: ActiveBuffDataEntry
    --- @type Dictionary<number, ActiveBuffDataEntry>
    self.activeBuffDataEntry = Dictionary()

    --- key: passive buff id, value: PassiveBuffDataEntry
    --- @type Dictionary<number, PassiveBuffDataEntry>
    self.passiveBuffDataEntry = Dictionary()
end

--------------------------------------- Getter --------------------------------------------

--- @return PassiveBuffDataEntry
--- @param idBuff number
function DungeonDataService:GetPassiveBuff(idBuff)
    return self.passiveBuffDataEntry:Get(idBuff)
end

--- @return ActiveBuffDataEntry
--- @param idBuff number
function DungeonDataService:GetActiveBuff(idBuff)
    return self.activeBuffDataEntry:Get(idBuff)
end

--- @return {first, second, third}
function DungeonDataService:GetSavePoint(currentLevel)
    local index = 1
    for i, level in pairs(self.stageList:GetItems()) do
        if currentLevel <= level then
            index = i
            break
        end
    end

    if index == 1 then
        return self.stageList:Get(1), self.stageList:Get(2), self.stageList:Get(3)
    else
        return self.stageList:Get(index - 1), self.stageList:Get(index), self.stageList:Get(index + 1)
    end
end

--------------------------------------- Setter --------------------------------------------
--- @return void
--- @param csv string
--- @param heroDataService HeroDataService
--- @param itemDataService ItemDataService
function DungeonDataService:LoadPassiveBuffData(csv, heroDataService, itemDataService)
    local parsedData = CsvReader.ReadContent(csv)
    ---@type PassiveBuffDataEntry
    local buff
    for i = 1, #parsedData do
        local csvRow = parsedData[i]
        if csvRow.id ~= nil then
            buff = PassiveBuffDataEntry(csvRow)
            buff:Validate()

            self.passiveBuffDataEntry:Add(buff.id, buff)
        end

        if buff ~= nil then
            local buffOption = ItemUtils.CreateItemOption(csvRow, heroDataService, itemDataService)
            buff:AddOption(buffOption)
        else
            assert(false)
        end
    end
end

--- @return void
--- @param csv string
function DungeonDataService:LoadAttackerData(csv)
    local data = CsvReader.ReadContent(csv)
    self.stageList = List()
    self.stageList:Add(1)
    for _, attacker in pairs(data) do
        if self.attackerConfig == nil then
            self.attackerConfig = {}
            self.attackerConfig.formationId = tonumber(attacker['formation_attacker'])
            self.attackerConfig.isFront = MathUtils.ToBoolean(attacker['is_front'])
            self.attackerConfig.position = tonumber(attacker['position'])
        end
        self.stageList:Add(tonumber(attacker['stage']))
    end
end

--- @return void
--- @param csv string
function DungeonDataService:LoadActiveBuffData(csv)
    local parsedData = CsvReader.ReadContent(csv)
    ---@type ActiveBuffDataEntry
    local buff

    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.id ~= nil then
            buff = ActiveBuffDataEntry(data)
            buff:Validate()
            self.activeBuffDataEntry:Add(buff.id, buff)
        end
    end
end

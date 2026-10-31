--- @class HeroDataEntry
HeroDataEntry = Class(HeroDataEntry)

--- @return void
function HeroDataEntry:Ctor()
    --- @type number
    self.id = 0

    --- @type Dictionary<number, HeroData>
    --- key: star, value: HeroData
    self.baseStats = Dictionary()

    --- @type Dictionary<number, HeroData>
    --- key: star, value: HeroData, contains stats gain when level up
    self.levelStats = Dictionary()

    --- @type Dictionary<number, HeroSkillDataCollection>
    --- key: skillId (1-4), value: HeroSkillDataCollection
    self.allSkillDataDict = Dictionary()

    --- @type TargetPositionType
    self.basicAttackTargetPosition = TargetPositionType.ORDERED
    --- @type number
    self.basicAttackTargetNumber = 1
    --- @type number
    self.basicAttackMultiplier = BattleConstants.BASIC_ATTACK_MULTIPLIER
end

--- @return HeroData
--- @param star number
function HeroDataEntry:GetBaseStats(star)
    return self.baseStats:Get(star)
end

--- @return HeroSkillDataCollection
--- @param skillId number
function HeroDataEntry:GetSkillData(skillId)
    return self.allSkillDataDict:Get(skillId)
end

--- @return void
--- @param skillId number
--- @param skillData HeroSkillDataCollection
function HeroDataEntry:AddSkillData(skillId, skillData)
    self.allSkillDataDict:Add(skillId, skillData)
end

--- @return HeroClassType
function HeroDataEntry:GetHeroClass()
    local heroData = self.baseStats:Get(1)
    return heroData.class
end

--- @return void
--- @param csv string
--- @param id number
function HeroDataEntry:ParseCsv(csv, id)
    local parsedData = CsvReader.ReadContent(csv)

    local basicInfo = parsedData[1]
    self:ValidateBeforeParseCsv(basicInfo)

    self.id = id
    local name = basicInfo.name

    local faction = math.floor(self.id / HeroConstants.FACTION_HERO_ID_DELTA)
    local class = tonumber(basicInfo.class)

    if basicInfo.target_position ~= nil then
        self.basicAttackTargetPosition = tonumber(basicInfo.target_position)
    end

    if basicInfo.target_number ~= nil then
        self.basicAttackTargetNumber = tonumber(basicInfo.target_number)
    end

    if basicInfo.basic_attack_damage ~= nil then
        self.basicAttackMultiplier = tonumber(basicInfo.basic_attack_damage)
    end

    local tempLevelStats = Dictionary()
    local lastStar = 0
    for i = 1, #parsedData do
        local data = parsedData[i]

        local star = tonumber(data.star)
        lastStar = star
        local type = tonumber(data.type)
        if MathUtils.IsInteger(type) == false or type < 0 then
            assert(false)
        end

        local heroData = HeroData()
        heroData:SetId(self.id, name)
        heroData:SetOriginInfo(star, class, faction)
        heroData:ParseCsv(data)
        heroData:Validate()

        if type == OriginStatChangerType.BASE_STAT then
            self.baseStats:Add(star, heroData)
        elseif type == OriginStatChangerType.LEVEL_UP_STAT then
            tempLevelStats:Add(star, heroData)
        end
    end

    if lastStar < HeroConstants.MAX_STAR then
        local heroData = self.baseStats:Get(lastStar)
        for star = lastStar + 1, HeroConstants.MAX_STAR do
            self.baseStats:Add(star, heroData)
        end

        heroData = tempLevelStats:Get(lastStar)
        for star = lastStar + 1, HeroConstants.MAX_STAR do
            tempLevelStats:Add(star, heroData)
        end
    end

    local beforeAwakenStats = tempLevelStats:Get(HeroConstants.AWAKENING_STAR)
    local afterAwakenStats = tempLevelStats:Get(HeroConstants.MAX_STAR)

    for i = 1, HeroConstants.MAX_STAR do
        local heroData = tempLevelStats:Get(i)
        if heroData == nil then
            if i <= HeroConstants.AWAKENING_STAR then
                self.levelStats:Add(i, beforeAwakenStats)
            else
                self.levelStats:Add(i, afterAwakenStats)
            end
        else
            self.levelStats:Add(i, heroData)
        end
    end
end

--- @return void
--- @param data table
function HeroDataEntry:ValidateBeforeParseCsv(data)
    if data.name == nil then
        assert(false)
    end

    if data.class == nil then
        assert(false)
    end
end

--- @return void
function HeroDataEntry:ValidateAfterParseCsv()
    if self.baseStats:Count() ~= HeroConstants.MAX_STAR then
        assert(false)
    end

    if self.levelStats:Count() ~= HeroConstants.MAX_STAR then
        assert(false)
    end
end
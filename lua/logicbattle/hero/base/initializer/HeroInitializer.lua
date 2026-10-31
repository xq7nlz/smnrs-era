--- @class HeroInitializer
HeroInitializer = Class(HeroInitializer)

--- @return void
--- @param hero BaseHero
function HeroInitializer:Ctor(hero)
    --- @type BaseHero
    self.myHero = hero

    self:CreateHeroStats()
    self:CreateControllers()
    self:CreateListeners()
    self:CreateHelpers()
end

---------------------------------------- Create components ----------------------------------------
--- @return void
function HeroInitializer:CreateHeroStats()
    self.myHero.attack = AttackStat(self.myHero)
    self.myHero.defense = DefenseStat(self.myHero)
    self.myHero.hp = HpStat(self.myHero)
    self.myHero.speed = SpeedStat(self.myHero)

    self.myHero.critRate = CritRateStat(self.myHero)
    self.myHero.critDamage = CritDamageStat(self.myHero)

    self.myHero.accuracy = AccuracyStat(self.myHero)
    self.myHero.dodge = DodgeStat(self.myHero)

    self.myHero.pureDamage = PureDamageStat(self.myHero)
    self.myHero.skillDamage = SkillDamageStat(self.myHero)
    self.myHero.armorBreak = ArmorBreakStat(self.myHero)

    self.myHero.reduceDamageReduction = ReduceDamageReductionStat(self.myHero)

    self.myHero.ccResistance = CCResistanceStat(self.myHero)
    self.myHero.damageReduction = DamageReductionStat(self.myHero)

    self.myHero.power = PowerStat(self.myHero)
end

--- @return void
function HeroInitializer:CreateControllers()
    self.myHero.attackController = AttackController(self.myHero)
    self.myHero.skillController = SkillController(self.myHero)
    self.myHero.effectController = EffectController(self.myHero)
end

--- @return void
function HeroInitializer:CreateListeners()
    self.myHero.attackListener = AttackListener(self.myHero)
    self.myHero.battleListener = BattleListener(self.myHero)
    self.myHero.skillListener = SkillListener(self.myHero)
end

--- @return void
function HeroInitializer:CreateHelpers()
    self.myHero.battleHelper = BattleHelper(self.myHero)
    self.myHero.statChangerItemHelper = StatChangerItemHelper(self.myHero)
end

---------------------------------------- Set data ----------------------------------------
--- @return void
--- @param battle Battle
--- @param heroDataService HeroDataService
--- @param itemDataService ItemDataService
--- @param predefineTeamDataService PredefineTeamDataService
function HeroInitializer:SetData(battle, heroDataService, itemDataService, predefineTeamDataService)
    self.myHero.battle = battle
    self.myHero.randomHelper = battle:GetRandomHelper()

    if self.myHero.isBoss == true and self.myHero.bossStat == nil then
        -- only in case of parse data from csv
        self.myHero.bossStat = predefineTeamDataService:GetBossStatById(self.myHero.bossId)
    end

    local heroDataEntry = self:GetHeroDataEntry(heroDataService)
    local skillLevels = self:GetSkillLevels(heroDataService)

    self:SetPowerGainData(heroDataService.powerGainEntries)
    self:SetSkillData(skillLevels, heroDataEntry.allSkillDataDict)

    self.myHero.attackController:CreateTargetSelector(heroDataEntry)
    self.myHero.battleHelper:SetBasicAttackMultiplier(heroDataEntry.basicAttackMultiplier)

    self:InitHeroStats(heroDataService)
    self:InitMastery(heroDataService)
    self:InitItems(itemDataService)
end

--- @return HeroDataEntry
--- @param heroDataService HeroDataService
function HeroInitializer:GetHeroDataEntry(heroDataService)
    return heroDataService:GetHeroDataEntry(self.myHero.id)
end

--- @return List<number>
--- @param heroDataService HeroDataService
function HeroInitializer:GetSkillLevels(heroDataService)
    local heroSkillLevelData = heroDataService:GetHeroSkillLevelData(self.myHero.star)
    return heroSkillLevelData.skillLevels
end

--- @return void
--- @param powerGainEntries Dictionary<number, number>
function HeroInitializer:SetPowerGainData(powerGainEntries)
    self.myHero.power:SetPowerGainData(powerGainEntries)
    self.myHero.power:Calculate()
end

--- @return void
--- @param selectedSkillLevels List<number>
--- @param allSkillDataDict List<HeroSkillDataCollection>
function HeroInitializer:SetSkillData(selectedSkillLevels, allSkillDataDict)
    for i = 1, SkillConstants.NUMBER_SKILL do
        local skillLevel = selectedSkillLevels:Get(i)
        local skillDataByLevels = allSkillDataDict:Get(i)

        if skillDataByLevels ~= nil then
            local skillDataList = skillDataByLevels.skillLevels

            assert(MathUtils.IsInteger(skillLevel) and skillLevel >= 0)
            local skillData = skillDataList:Get(skillLevel)
            if i == 1 and skillData == nil then
                assert(false, string.format("heroId = %s, skillLevel = %s",
                        self.myHero.id, skillLevel))
            end

            if skillData ~= nil then
                local skillClass = self:GetSkillLuaFile(self.myHero.id, i, skillLevel)
                ---@type BaseSkill
                local skill = skillClass:CreateInstance(i, self.myHero)
                skill:SetData(skillLevel, skillData)

                self.myHero.skillController:AddSkill(i, skill)
            end
        end
    end
end

--- @return table
--- @param heroId number
--- @param skillId number
--- @param skillLevel number
function HeroInitializer:GetSkillLuaFile(heroId, skillId, skillLevel)
    local path = string.format(LuaPathConstants.HERO_SKILL_PATH, heroId, heroId, skillId)
    return require(path)
end

--- @return void
--- @param bonuses List<StatBonus>
function HeroInitializer:SetCompanionBuff(bonuses)
    local effect = StatChangerEffect(self.myHero, self.myHero, true)
    effect:SetPersistentType(EffectPersistentType.PERMANENT)
    effect:SetDuration(EffectConstants.INFINITY_DURATION)
    effect:SetEffectSource(StatChangerEffectSource.COMPANION_BUFF)

    local i = 1
    while i <= bonuses:Count() do
        local statChanger = StatChanger(true)
        local bonus = bonuses:Get(i)
        statChanger:SetInfo(bonus.statType, bonus.calculationType, bonus.amount)

        effect:AddStatChanger(statChanger)
        i = i + 1
    end

    self.myHero.effectController:AddEffect(effect)
end

---------------------------------------- Init ----------------------------------------
--- @return void
function HeroInitializer:InitSkill()
    self.myHero.skillController:Init()
end

--- @return void
--- @param heroDataService HeroDataService
function HeroInitializer:InitHeroStats(heroDataService)
    self.myHero.heroStats:Add(StatType.ATTACK, self.myHero.attack)
    self.myHero.heroStats:Add(StatType.DEFENSE, self.myHero.defense)
    self.myHero.heroStats:Add(StatType.HP, self.myHero.hp)
    self.myHero.heroStats:Add(StatType.SPEED, self.myHero.speed)

    self.myHero.heroStats:Add(StatType.CRIT_RATE, self.myHero.critRate)
    self.myHero.heroStats:Add(StatType.CRIT_DAMAGE, self.myHero.critDamage)

    self.myHero.heroStats:Add(StatType.ACCURACY, self.myHero.accuracy)
    self.myHero.heroStats:Add(StatType.DODGE, self.myHero.dodge)

    self.myHero.heroStats:Add(StatType.PURE_DAMAGE, self.myHero.pureDamage)
    self.myHero.heroStats:Add(StatType.SKILL_DAMAGE, self.myHero.skillDamage)
    self.myHero.heroStats:Add(StatType.ARMOR_BREAK, self.myHero.armorBreak)
    self.myHero.heroStats:Add(StatType.REDUCE_DAMAGE_REDUCTION, self.myHero.reduceDamageReduction)

    self.myHero.heroStats:Add(StatType.CC_RESISTANCE, self.myHero.ccResistance)
    self.myHero.heroStats:Add(StatType.DAMAGE_REDUCTION, self.myHero.damageReduction)

    self.myHero.heroStats:Add(StatType.POWER, self.myHero.power)

    local baseStat = self.myHero.baseStat
    local levelStats = self.myHero.levelStats
    local heroLevelCapEntries = heroDataService.heroLevelCapEntries

    for _, heroStat in pairs(self.myHero.heroStats:GetItems()) do
        heroStat:CalculateStatByLevel(baseStat, levelStats, heroLevelCapEntries)
        heroStat:Calculate()
    end
end

--- @return void
--- @param heroDataService HeroDataService
function HeroInitializer:InitMastery(heroDataService)
    local summonerMasteryData = heroDataService:GetSummonerDataEntry(self.myHero.originInfo.class).summonerMasteries
    local masteryLevels = self.myHero.masteryLevels

    if masteryLevels ~= nil then
        local i = 1
        while i <= masteryLevels:Count() do
            local level = masteryLevels:Get(i)

            if level > 0 then
                local summonerMastery = summonerMasteryData:Get(i)
                local statBonus = summonerMastery:GetStatBonus(level)

                local effect = StatChangerEffect(self.myHero, self.myHero, true)
                effect:SetPersistentType(EffectPersistentType.PERMANENT)
                effect:SetDuration(EffectConstants.INFINITY_DURATION)

                local statChanger = StatChanger(true)
                statChanger:SetInfo(statBonus.statType, statBonus.calculationType, statBonus.amount)
                effect:AddStatChanger(statChanger)

                self.myHero.effectController:AddEffect(effect)

                effect:SetEffectSource(StatChangerEffectSource.MASTERY)
            end
            i = i + 1
        end
    end
end

--- @return void
--- @param itemDataService ItemDataService
function HeroInitializer:InitItems(itemDataService)
    self.myHero.statChangerItemHelper:InitItemBuff(itemDataService)
end

---------------------------------------- Formation ----------------------------------------
--- @return void
--- @param heroDataService HeroDataService
--- @param formationId number
--- @param numberFrontLine number
--- @param numberBackLine number
function HeroInitializer:SetFormation(heroDataService, formationId, numberFrontLine, numberBackLine)
    self.myHero.positionInfo:SetFormationId(formationId)

    if self.myHero.battle:GetGameMode() == GameMode.DUNGEON then
        return
    end

    local formationBuffData = heroDataService:GetFormationBuffData(formationId, self.myHero.positionInfo.isFrontLine)
    if formationBuffData == nil then
        return
    end

    if self.myHero.positionInfo.isFrontLine then
        if numberFrontLine > 0 then
            local effect = self:AddFormationBuffEffect(self.myHero, self.myHero,
                    formationBuffData.bonuses, numberFrontLine)
            effect:SetEffectSource(StatChangerEffectSource.POSITION)
        end
    else
        if numberBackLine > 0 then
            local effect = self:AddFormationBuffEffect(self.myHero, self.myHero,
                    formationBuffData.bonuses, numberBackLine)
            effect:SetEffectSource(StatChangerEffectSource.POSITION)
        end
    end
end

--- @return StatChangerEffect
--- @param initiator BaseHero
--- @param target BaseHero
--- @param bonuses List<StatBonus>
--- @param numberHeroesByLine number
function HeroInitializer:AddFormationBuffEffect(initiator, target, bonuses, numberHeroesByLine)
    local effect = StatChangerEffect(initiator, target, true)
    effect:SetPersistentType(EffectPersistentType.PERMANENT)
    effect:SetDuration(EffectConstants.INFINITY_DURATION)

    local i = 1
    while i <= bonuses:Count() do
        local statChanger = StatChanger(true)
        local bonus = bonuses:Get(i)
        statChanger:SetInfo(bonus.statType, bonus.calculationType, bonus.amount / numberHeroesByLine)

        effect:AddStatChanger(statChanger)
        i = i + 1
    end

    target.effectController:AddEffect(effect)
    return effect
end
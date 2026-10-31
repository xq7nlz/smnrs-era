--- @class BaseHero
BaseHero = Class(BaseHero)

--- @return void
function BaseHero:Ctor()
    --- @type number
    self.id = -1
    --- @type string
    self.name = nil

    --- @type number
    self.teamId = -1

    --- @type PositionInfo
    self.positionInfo = PositionInfo(self)
    --- @type OriginInfo
    self.originInfo = nil

    --- @type HeroData
    self.baseStat = nil
    --- @type HeroData
    self.levelStats = nil
    --- @type HeroData
    self.awakenLevelStat = nil

    --- @type number
    self.level = -1
    --- @type number
    self.star = -1

    --- @type Dictionary<StatType, BaseHeroStat>
    self.heroStats = Dictionary()

    --- @type AttackStat
    self.attack = nil
    --- @type DefenseStat
    self.defense = nil
    --- @type HpStat
    self.hp = nil
    --- @type SpeedStat
    self.speed = nil

    --- @type CritRateStat
    self.critRate = nil
    --- @type CritDamageStat
    self.critDamage = nil

    --- @type AccuracyStat
    self.accuracy = nil
    --- @type DodgeStat
    self.dodge = nil

    --- @type PureDamageStat
    self.pureDamage = nil
    --- @type SkillDamageStat
    self.skillDamage = nil
    --- @type ArmorBreakStat
    self.armorBreak = nil

    --- @type ReduceDamageReductionStat
    self.reduceDamageReduction = nil

    --- @type CCResistanceStat
    self.ccResistance = nil
    --- @type DamageReductionStat
    self.damageReduction = nil

    --- @type PowerStat
    self.power = nil

    --- @type AttackController
    self.attackController = nil
    --- @type SkillController
    self.skillController = nil
    --- @type EffectController
    self.effectController = nil

    --- @type AttackListener
    self.attackListener = nil
    --- @type BattleListener
    self.battleListener = nil
    --- @type SkillListener
    self.skillListener = nil

    --- @type BattleHelper
    self.battleHelper = nil

    --- @type StatChangerItemHelper
    self.statChangerItemHelper = nil

    --- @type RandomHelper
    self.randomHelper = nil

    --- @type EquipmentController
    self.equipmentController = EquipmentController()

    --- @type List<number>
    self.masteryLevels = nil

    --- @type Dictionary<number, List<number>>
    self.masteryDataList = nil

    --- @type Battle
    self.battle = nil

    --- @type boolean
    self.isBoss = false
    --- @type number
    self.bossId = nil
    --- @type BossStatPredefine
    self.bossStat = nil

    --- @type boolean
    self.isSummoner = false

    --- @type HeroState
    self.startState = HeroState()

    --- @type boolean
    self.isDummy = false
end

--- @return HeroInitializer
function BaseHero:CreateInitializer()
    return HeroInitializer(self)
end

--- @return BaseHero
function BaseHero:CreateInstance()
    assert(false, "this method should be overridden by child class")
end

--- @return void
--- @param heroDataEntry HeroDataEntry
function BaseHero:SetHeroDataEntry(heroDataEntry)
    local baseStat = heroDataEntry:GetBaseStats(self.star)

    self.name = baseStat.name
    self.baseStat = TableUtils.Clone(baseStat)
    self.levelStats = TableUtils.Clone(heroDataEntry.levelStats)
    self.originInfo = OriginInfo(self, baseStat.class, baseStat.faction)

    if self.isSummoner == false then
        self.masteryLevels = self.masteryDataList:Get(baseStat.class)
    end
end

--- @return number
--- @param statType StatType
function BaseHero:GetStatMultiForBossBase(statType)
    if self.isBoss == true then
        return self.bossStat.statBaseMultiplier:GetOrDefault(statType, 1)
    else
        return 1
    end
end

--- @return number
--- @param statType StatType
function BaseHero:GetStatMultiForBossGrow(statType)
    if self.isBoss == true then
        return self.bossStat.statGrowMultiplier:GetOrDefault(statType, 1)
    else
        return 1
    end
end

--- @return number
--- @param statType StatType
function BaseHero:GetStatAddForBoss(statType)
    if self.isBoss == true then
        return self.bossStat.statBaseAdder:GetOrDefault(statType, 0)
    else
        return 0
    end
end

--- @return number
function BaseHero:GetHeroUnique()
    if self.teamId <= 0 then
        XDebug.Log("WHY TEAM ID IS NEGATIVE: " .. self.teamId)
    end

    local id = self.teamId * HeroConstants.UNIQUE_HERO_ID_DELTA + self.positionInfo:GetPositionUnique()

    if self:IsSummoner() or self:IsDummy() then
        id = id + 1000
    end

    return id
end

---------------------------------------- Battle actions ----------------------------------------
--- @return List<BaseActionResult>, boolean
--- @param actionType ActionType
function BaseHero:DoAction(actionType)
    local actionResults, isEndTurn
    if actionType == ActionType.BASIC_ATTACK then
        actionResults, isEndTurn = self.attackController:DoBasicAttack()
    elseif actionType == ActionType.USE_SKILL then
        actionResults, isEndTurn = self.skillController:UseActiveSkill()
    end
    return actionResults, isEndTurn
end

---------------------------------------- Update actions ----------------------------------------
--- @return void
function BaseHero:UpdateBeforeRound()
    self.effectController:UpdateBeforeRound()
end

--- @return void
function BaseHero:UpdateAfterRound()
    self.effectController:UpdateAfterRound()
end

---------------------------------------- Getters ----------------------------------------
--- @return boolean
function BaseHero:GetActionType()
    if self.skillController:CanUseActiveSkill() then
        return ActionType.USE_SKILL
    else
        return ActionType.BASIC_ATTACK
    end
end

--- @return boolean
function BaseHero:CanBeTargetedByAlly()
    if self:IsDead() then
        return false
    end

    return true
end

--- @return boolean
function BaseHero:CanBeTargetedByEnemy()
    if self:IsDead() then
        return false
    end

    return true
end

--- @return boolean
function BaseHero:CanPlay()
    if self:IsDead() then
        return false
    end

    if self.effectController:IsContainCCEffect() then
        return false
    end

    return true
end

--- @return boolean
function BaseHero:IsDead()
    return self.hp:IsDead()
end

--- @return boolean
--- @param teamId number
function BaseHero:IsSameTeam(teamId)
    return self.teamId == teamId
end

--- @return boolean
--- @param target BaseHero
function BaseHero:IsAlly(target)
    return self.teamId == target.teamId
end

--- @return BaseHeroStat
--- @param statType StatType
function BaseHero:GetStat(statType)
    return self.heroStats:Get(statType)
end

--- @return boolean
function BaseHero:IsBoss()
    return self.isBoss
end

--- @return boolean
function BaseHero:IsSummoner()
    return self.isSummoner
end

--- @return boolean
function BaseHero:IsDummy()
    return self.isDummy
end

--- @return number
function BaseHero:CalculateBattlePower()
    local result = 0

    local critRateCoef = 1 + self.critRate:GetValue() * (self.critDamage:GetValue() - 1) + 0.7 * self.skillDamage:GetValue()
    local levelCoef = 20 * self.level * (1 - self.armorBreak:GetValue()) + 1
    result = result + 3 * self.attack:GetValue() * (critRateCoef / levelCoef + self.pureDamage:GetValue())

    local defenseCoef = 0.0001 * self.defense:GetValue() + 1
    local damageReductionCoef = 1 - self.damageReduction:GetValue()
    result = result + 0.23 * self.hp:GetValue() * defenseCoef / damageReductionCoef

    result = result + 50 * self.speed:GetValue() + 3 * self.accuracy:GetValue() + 3 * self.dodge:GetValue()

    return result
end

---------------------------------------- ToString ----------------------------------------
--- @return string
function BaseHero:ToString()
    return string.format("[%s %s (TEAM %s, %s)]", self.name, self.id, self.teamId, self.positionInfo:ToString())
end

--- @return string
function BaseHero:ToDetailString()
    local result = self:ToString() .. "\n"

    result = result .. string.format("star = %s\n", self.star)
    result = result .. string.format("level = %s\n", self.level)

    result = result .. string.format("isBoss = %s\n", tostring(self.isBoss))
    if self.isBoss then
        result = result .. string.format("bossId = %s\n", tostring(self.bossId))
    end

    result = result .. string.format("isSummoner = %s\n", tostring(self.isSummoner))
    result = result .. string.format("isDummy = %s\n", tostring(self.isDummy))

    result = result .. self.originInfo:ToString()

    result = result .. self.attack:ToString()
    result = result .. self.defense:ToString()
    result = result .. self.hp:ToString()
    result = result .. self.speed:ToString()

    result = result .. self.critRate:ToString()
    result = result .. self.critDamage:ToString()

    result = result .. self.accuracy:ToString()
    result = result .. self.dodge:ToString()

    result = result .. self.pureDamage:ToString()
    result = result .. self.skillDamage:ToString()
    result = result .. self.armorBreak:ToString()
    result = result .. self.reduceDamageReduction:ToString()

    result = result .. self.ccResistance:ToString()
    result = result .. self.damageReduction:ToString()

    result = result .. self.power:ToString()

    return result
end
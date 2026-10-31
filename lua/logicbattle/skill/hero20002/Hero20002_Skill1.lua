--- @class Hero20002_Skill1 Arien
Hero20002_Skill1 = Class(Hero20002_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20002_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type number
    self.statDebuffEnemyChance = nil
    --- @type number
    self.statDebuffEnemyType = nil
    --- @type number
    self.statDebuffEnemyDuration = nil
    --- @type number
    self.statDebuffEnemyAmount = nil

    --- @type BaseTargetSelector
    self.powerBuffTargetSelector = nil
    --- @type number
    self.powerBuffChance = nil
    --- @type number
    self.powerBuffAmount = nil

    --- @type BaseTargetSelector
    self.effectBuffTargetSelector = nil
    --- @type EffectType
    self.statBuffType = nil
    --- @type number
    self.statBuffChance = nil
    --- @type number
    self.statBuffDuration = nil
    --- @type number
    self.statBuffAmount = nil
end

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20002_Skill1:CreateInstance(id, hero)
    return Hero20002_Skill1(id, hero)
end

--- @return void
function Hero20002_Skill1:Init()
    self.statDebuffEnemyChance = self.data.statDebuffEnemyChance
    self.statDebuffEnemyType = self.data.statDebuffEnemyType
    self.statDebuffEnemyDuration = self.data.statDebuffEnemyDuration
    self.statDebuffEnemyAmount = self.data.statDebuffEnemyAmount

    self.powerBuffChance = self.data.powerBuffChance
    self.powerBuffAmount = self.data.powerBuffAmount

    self.statBuffType = self.data.statBuffType
    self.statBuffChance = self.data.statBuffChance
    self.statBuffDuration = self.data.statBuffDuration
    self.statBuffAmount = self.data.statBuffAmount

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.powerBuffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.powerBuffTargetPosition,
            TargetTeamType.ALLY, self.data.powerBuffTargetNumber)
    --self.powerBuffTargetSelector:SetIncludeSelf(false)

    self.effectBuffTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.statBuffTargetPosition,
            TargetTeamType.ALLY, self.data.statBuffTargetNumber)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero20002_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
    local result = self.damageSkillHelper:UseDamageSkill(targetList)

    self:PowerBuff()
    self:BuffStat()

    local isEndTurn = true

    return result, isEndTurn
end

--- @return void
function Hero20002_Skill1:PowerBuff()
    --- buff power
    local targetList = self.powerBuffTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        PowerUtils.GainPower(self.myHero, target, self.powerBuffAmount, false)
        i = i + 1
    end
end

--- @return void
function Hero20002_Skill1:BuffStat()
    --- buff attack
    local targetList = self.effectBuffTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        local statChangerEffectBuff = StatChanger(true)
        statChangerEffectBuff:SetInfo(self.statBuffType, StatChangerCalculationType.PERCENT_ADD, self.statBuffAmount)

        local effectBuff = StatChangerEffect(self.myHero, target, true)
        effectBuff:SetDuration(self.statBuffDuration)
        effectBuff:AddStatChanger(statChangerEffectBuff)

        target.effectController:AddEffect(effectBuff)
        i = i + 1
    end
end

--- @return void
--- @param target BaseHero
function Hero20002_Skill1:InflictEffect(target)
    local statChangerDebuffEnemy = StatChanger(false)
    statChangerDebuffEnemy:SetInfo(self.statDebuffEnemyType, StatChangerCalculationType.PERCENT_ADD, self.statDebuffEnemyAmount)

    local statDebuffEffect = StatChangerEffect(self.myHero, target, false)
    statDebuffEffect:SetDuration(self.statDebuffEnemyDuration)
    statDebuffEffect:AddStatChanger(statChangerDebuffEnemy)
    target.effectController:AddEffect(statDebuffEffect)
end

return Hero20002_Skill1
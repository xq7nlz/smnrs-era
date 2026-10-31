--- @class Hero40003_Skill1 Arryl
Hero40003_Skill1 = Class(Hero40003_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40003_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type number
    self.damage = 0

    --- @type number
    self.effectChance = 0

    --- @type EffectType
    self.effectType = 0

    --- @type number
    self.effectDuration = 0

    --- @type number
    self.effectAmount = 0

    --- @type number
    self.effectDryadDuration = 0

    --- @type number
    self.effectDryadAmount = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40003_Skill1:CreateInstance(id, hero)
    return Hero40003_Skill1(id, hero)
end

--- @return void
function Hero40003_Skill1:Init()
    self.effectChance = self.data.effectChance
    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration
    self.effectAmount = self.data.effectAmount
    self.effectDryadDuration = self.data.effectDryadDuration
    self.effectDryadAmount = self.data.effectDryadAmount

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.DryadPoisonTarget)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

----------------------------------- Battle -------------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero40003_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.damageTargetPosition,
            TargetTeamType.ENEMY, self.data.damageTargetNumber)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param enemyDefender BaseHero
function Hero40003_Skill1:DryadPoisonTarget(enemyDefender)
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyDefender, self.effectType, self.effectDuration, self.effectAmount)
        enemyDefender.effectController:AddEffect(dotEffect)

        self:MarkDryadToTarget(enemyDefender)
    end
end

--- @return void
--- @param enemyDefender BaseHero
function Hero40003_Skill1:MarkDryadToTarget(enemyDefender)
    local markEffect = DryadMark(self.myHero, enemyDefender)
    markEffect:SetDuration(self.effectDryadDuration)
    markEffect:SetReduceHeal(self.effectDryadAmount)
    enemyDefender.effectController:AddEffect(markEffect)
end

return Hero40003_Skill1
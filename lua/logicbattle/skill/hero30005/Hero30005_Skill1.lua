--- @class Hero30005_Skill1 Jormungand
Hero30005_Skill1 = Class(Hero30005_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30005_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    ---@type number
    self.venomStackDamage = nil

    --- @type number
    self.venomStackDuration = nil

    --- @type number
    self.numberStack = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30005_Skill1:CreateInstance(id, hero)
    return Hero30005_Skill1(id, hero)
end

--- @return void
function Hero30005_Skill1:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.venomStackDamage = self.data.venomStackDamage
    self.venomStackDuration = self.data.venomStackDuration
    self.numberStack = self.data.numberStack
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero30005_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero30005_Skill1:InflictEffect(target)
    Hero30005_Utils.InflictVenomStack(self.myHero, target,
            self.venomStackDamage, self.venomStackDuration, self.numberStack)
end

return Hero30005_Skill1
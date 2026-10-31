--- @class Hero60009_Skill1 Khann
Hero60009_Skill1 = Class(Hero60009_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60009_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type number
    self.damageBonusAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60009_Skill1:CreateInstance(id, hero)
    return Hero60009_Skill1(id, hero)
end

--- @return void
function Hero60009_Skill1:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
    self.targetSelector:SetEffectType(EffectType.DISEASE_MARK)

    self.damageSkillHelper = Hero60009_DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)
    self.damageSkillHelper:SetBonusSkillDamage(EffectType.DISEASE_MARK, self.data.damageBonusAmount)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero60009_Skill1:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

return Hero60009_Skill1
--- @class Hero50009_Skill1 Aris
Hero50009_Skill1 = Class(Hero50009_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50009_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type HeroFactionType
    self.bonusDamageFactionType = nil
    --- @type number
    self.bonusDamageFactionAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50009_Skill1:CreateInstance(id, hero)
    return Hero50009_Skill1(id, hero)
end

--- @return void
function Hero50009_Skill1:Init()
    self.bonusDamageFactionType = self.data.bonusDamageFactionType
    self.bonusDamageFactionAmount = self.data.bonusDamageFactionAmount

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = FactionBonus_DamageSkillHelper(self)
    self.damageSkillHelper:SetBonusSkillDamage(self.bonusDamageFactionType, self.bonusDamageFactionAmount)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero50009_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

return Hero50009_Skill1
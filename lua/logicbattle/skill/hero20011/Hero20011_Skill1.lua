--- @class Hero20011_Skill1 Labord
Hero20011_Skill1 = Class(Hero20011_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20011_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type HeroClassType
    self.bonusClassHero = nil

    --- @type number
    self.bonusDamageWithClass = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20011_Skill1:CreateInstance(id, hero)
    return Hero20011_Skill1(id, hero)
end

--- @return void
function Hero20011_Skill1:Init()
    self.bonusClassHero = self.data.bonusClassHero
    self.bonusDamageWithClass = self.data.bonusDamageWithClass

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = ClassBonus_DamageSkillHelper(self)
    self.damageSkillHelper:SetBonusSkillDamage(self.bonusClassHero, self.bonusDamageWithClass)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero20011_Skill1:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

return Hero20011_Skill1
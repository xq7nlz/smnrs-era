--- @class Hero40001_Skill2 Tilion
Hero40001_Skill2 = Class(Hero40001_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40001_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type HealSkillHelper
    self.healSkillHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40001_Skill2:CreateInstance(id, hero)
    return Hero40001_Skill2(id, hero)
end

--- @return void
function Hero40001_Skill2:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ALLY, self.data.targetNumber)

    self.healChance = self.data.healChance

    self.healSkillHelper = HealSkillHelper(self)
    self.healSkillHelper:SetHealData(self.data.healPercent, self.data.healDuration)

    self.myHero.attackListener:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero40001_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    --- check can heal
    if self.myHero.randomHelper:RandomRate(self.healChance) then
        local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
        self.healSkillHelper:UseHealSkill(targetList)
    end
end

return Hero40001_Skill2
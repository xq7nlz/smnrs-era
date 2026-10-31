--- @class Hero10018_Skill4 Sabertusk
Hero10018_Skill4 = Class(Hero10018_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10018_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type number
    self.healAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10018_Skill4:CreateInstance(id, hero)
    return Hero10018_Skill4(id, hero)
end

--- @return void
function Hero10018_Skill4:Init()
    self.healAmount = self.data.healAmount
    self.myHero.attackListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero10018_Skill4:OnDealCritDamage(enemyDefender, totalDamage)
    local amount = self.healAmount * self.myHero.attack:GetValue()
    HealUtils.Heal(self.myHero, self.myHero, amount, HealReason.HEAL_SKILL)
end

return Hero10018_Skill4
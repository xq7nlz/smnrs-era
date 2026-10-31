--- @class Hero60008_Skill2 Renaks
Hero60008_Skill2 = Class(Hero60008_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60008_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.effectChance = 0

    --- @type number
    self.healPercentWithDamage = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60008_Skill2:CreateInstance(id, hero)
    return Hero60008_Skill2(id, hero)
end

--- @return void
function Hero60008_Skill2:Init()
    self.effectChance = self.data.effectChance
    self.healPercentWithDamage = self.data.healPercentWithDamage

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.skillListener:BindingWithSkill_2(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero60008_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if self.myHero.randomHelper:RandomRate(self.effectChance) then
            enemyDefender.effectController:DispelBuff()
        end

        local healAmount = self.healPercentWithDamage * totalDamage
        HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
    end
end

return Hero60008_Skill2
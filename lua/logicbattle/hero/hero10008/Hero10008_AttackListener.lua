--- @class Hero10008_AttackListener
Hero10008_AttackListener = Class(Hero10008_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero10008_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero10008_AttackListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return number
--- @param skill BaseSkill
function Hero10008_AttackListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero10008_AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.skill_2 ~= nil then
        self.skill_2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end

    if self.skill_4 ~= nil then
        self.skill_4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end
end
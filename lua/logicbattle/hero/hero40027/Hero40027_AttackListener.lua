--- @class Hero40027_AttackListener : AttackListener Airyuu
Hero40027_AttackListener = Class(Hero40027_AttackListener, AttackListener)

function Hero40027_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    ---@type Hero40027_Skill2
    self.skill_2 = nil

    ---@type Hero40027_Skill3
    self.skill_3 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero40027_AttackListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param skill BaseSkill
function Hero40027_AttackListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero40027_AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.skill_3 ~= nil then
        self.skill_3:AddPoisonEffect(enemyDefender)
    end

    if (self.skill_2 ~= nil) then
        self.skill_2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero40027_AttackListener:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.skill_3 ~= nil then
        self.skill_3:AddPoisonEffect(enemyAttacker)
    end
end
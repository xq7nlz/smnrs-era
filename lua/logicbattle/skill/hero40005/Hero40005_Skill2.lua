--- @class Hero40005_Skill2 Yang
Hero40005_Skill2 = Class(Hero40005_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40005_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.powerGainPerBasicAttack = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40005_Skill2:CreateInstance(id, hero)
    return Hero40005_Skill2(id, hero)
end

--- @return void
function Hero40005_Skill2:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)

    self.powerGainPerBasicAttack = self.data.powerGainPerBasicAttack

    self.myHero.attackListener:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero40005_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    PowerUtils.GainPower(self.myHero, self.myHero, self.powerGainPerBasicAttack, false)
end

return Hero40005_Skill2
--- @class Hero30006_Skill2 Thanatos
Hero30006_Skill2 = Class(Hero30006_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30006_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.bonusAttack = nil

    --- @type number
    self.hpPercentLostPerBonus = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30006_Skill2:CreateInstance(id, hero)
    return Hero30006_Skill2(id, hero)
end

--- @return void
function Hero30006_Skill2:Init()
    self.bonusAttack = self.data.bonusAttack
    self.hpPercentLostPerBonus = self.data.hpPercentLostPerBonus

    self.myHero.battleHelper:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param target BaseHero
function Hero30006_Skill2:GetBonus(target)
    local numberBonus = math.floor((1 - target.hp:GetStatPercent()) / self.hpPercentLostPerBonus)
    return 1 + numberBonus * self.bonusAttack
end

return Hero30006_Skill2
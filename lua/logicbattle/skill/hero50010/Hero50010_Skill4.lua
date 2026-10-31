--- @class Hero50010_Skill4 Sephion
Hero50010_Skill4 = Class(Hero50010_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50010_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.healthBonusTrigger = 0
    --- @type number
    self.bonusDamage = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50010_Skill4:CreateInstance(id, hero)
    return Hero50010_Skill4(id, hero)
end

--- @return void
function Hero50010_Skill4:Init()
    self.healthBonusTrigger = self.data.healthBonusTrigger
    self.bonusDamage = self.data.bonusDamage

    self.myHero.battleHelper:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param target BaseHero
--- @param originMultiDamage number
function Hero50010_Skill4:GetDamageBonusBasicAttack(target, originMultiDamage)
    if target.hp:GetStatPercent() > self.healthBonusTrigger then
        return originMultiDamage * (1 + self.bonusDamage)
    end
    return originMultiDamage
end

return Hero50010_Skill4
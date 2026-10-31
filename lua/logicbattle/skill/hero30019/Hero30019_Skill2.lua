--- @class Hero30019_Skill2 Elne
Hero30019_Skill2 = Class(Hero30019_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30019_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.bonusDamage = nil

    --- @type number
    self.healTrigger = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30019_Skill2:CreateInstance(id, hero)
    return Hero30019_Skill2(id, hero)
end

--- @return void
function Hero30019_Skill2:Init()
    self.healTrigger = self.data.healTrigger
    self.bonusDamage = self.data.bonusDamage

    self.myHero.battleHelper:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number damage
--- @param target BaseHero
--- @param originMulti number
function Hero30019_Skill2:GetMultiplierDamage(target, originMulti)
    local result = originMulti
    if target.hp:GetStatPercent() < self.healTrigger then
        result = originMulti * (1 + self.bonusDamage)
    end
    return result
end

return Hero30019_Skill2
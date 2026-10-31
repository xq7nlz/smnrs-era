--- @class Hero30012_Skill3 Dzuteh
Hero30012_Skill3 = Class(Hero30012_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30012_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.effectTypeTrigger = 0
    --- @type number
    self.bonusDamage = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30012_Skill3:CreateInstance(id, hero)
    return Hero30012_Skill3(id, hero)
end

--- @return void
function Hero30012_Skill3:Init()
    self.effectTypeTrigger = self.data.effectTypeTrigger
    self.bonusDamage = self.data.bonusDamage

    self.myHero.battleHelper:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param target BaseHero
--- @param originMultiDamage number
function Hero30012_Skill3:GetMultiDamage(target, originMultiDamage)
    if target.effectController:IsContainEffectType(self.effectTypeTrigger) then
        return originMultiDamage * (1 + self.bonusDamage)
    end
    return originMultiDamage
end

return Hero30012_Skill3
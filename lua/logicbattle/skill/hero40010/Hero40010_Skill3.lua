--- @class Hero40010_Skill3 Yome
Hero40010_Skill3 = Class(Hero40010_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40010_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.bonusDamageWithEffect = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40010_Skill3:CreateInstance(id, hero)
    return Hero40010_Skill3(id, hero)
end

--- @return void
function Hero40010_Skill3:Init()
    self.effectType = self.data.effectType
    self.bonusDamageWithEffect = self.data.bonusDamageWithEffect

    self.myHero.attack:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param target BaseHero
--- @param baseMulti number
function Hero40010_Skill3:GetMultiAddByTarget(target, baseMulti)
    if target.effectController:IsContainEffectType(self.effectType) then
        return baseMulti * (1 + self.bonusDamageWithEffect)
    end

    return baseMulti
end

return Hero40010_Skill3
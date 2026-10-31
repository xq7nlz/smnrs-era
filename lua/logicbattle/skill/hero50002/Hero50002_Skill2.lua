--- @class Hero50002_Skill2 HolyKnight
Hero50002_Skill2 = Class(Hero50002_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50002_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.bonusDamage = nil

    --- @type number
    self.effectType = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50002_Skill2:CreateInstance(id, hero)
    return Hero50002_Skill2(id, hero)
end

--- @return void
function Hero50002_Skill2:Init()
    self.effectType = self.data.effectType
    self.bonusDamage = self.data.bonusDamage

    self.myHero.battleHelper:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param target BaseHero
function Hero50002_Skill2:CalculateAttackResult(target)
    if target.effectController:IsContainEffectType(self.effectType) then
        return self.bonusDamage
    else
        return 0
    end
end

return Hero50002_Skill2
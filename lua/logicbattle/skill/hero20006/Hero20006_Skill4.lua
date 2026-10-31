--- @class Hero20006_Skill4 Finde
Hero20006_Skill4 = Class(Hero20006_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20006_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.resistanceDotDamage = 0
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero20006_Skill4:CreateInstance(id, hero)
    return Hero20006_Skill4(id, hero)
end

--- @return void
function Hero20006_Skill4:Init()
    self.resistanceDotDamage = self.data.resistanceDotDamage

    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)

    self.myHero.effectController:BindingWithSkill_4(self)
    self.myHero.hp:BindingWithSkill_4(self)
end

-----------------------------------------Battle---------------------------------------
--- @return EffectPersistentType
function Hero20006_Skill4:PersistentType()
    return EffectPersistentType.NON_PERSISTENT_NOT_DISPELLABLE
end

--- @return number
--- @param dotAmount number
function Hero20006_Skill4:GetDotAmount(dotAmount)
    return dotAmount * (1 - self.resistanceDotDamage)
end

return Hero20006_Skill4
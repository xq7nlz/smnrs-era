--- @class Hero20001_Skill3 Icarus
Hero20001_Skill3 = Class(Hero20001_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20001_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.effectPercent = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20001_Skill3:CreateInstance(id, hero)
    return Hero20001_Skill3(id, hero)
end

--- @return void
function Hero20001_Skill3:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)

    self.effectType = self.data.effectType
    self.effectPercent = self.data.effectPercent

    self.myHero.attack:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param target BaseHero
--- @param baseMulti number
function Hero20001_Skill3:GetMultiAddByTarget(target, baseMulti)
    if target.effectController:IsContainEffectType(self.effectType) then
        return baseMulti * (1 + self.effectPercent)
    end

    return baseMulti
end

return Hero20001_Skill3
--- @class Hero40012_Skill4 Lothiriel
Hero40012_Skill4 = Class(Hero40012_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40012_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type EffectType
    self.effectCheckType = nil
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40012_Skill4:CreateInstance(id, hero)
    return Hero40012_Skill4(id, hero)
end

--- @return void
function Hero40012_Skill4:Init()
    self.multiBonusDamage = self.data.multiBonusDamage
    self.effectCheckType = self.data.effectCheckType

    self.myHero.battleHelper:BindingWithSkill_4(self)
end

-----------------------------------------Battle---------------------------------------
--- @return number
--- @param enemyDefender BaseHero
--- @param originMulti number
function Hero40012_Skill4:GetBonusMultiDamageAdd(enemyDefender, originMulti)
    if enemyDefender.effectController:IsContainEffectType(self.effectCheckType) then
        return originMulti * (1 + self.multiBonusDamage)
    end
    return originMulti
end

return Hero40012_Skill4
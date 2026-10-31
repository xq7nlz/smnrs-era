--- @class Hero10001_Skill2 ColdAxe
Hero10001_Skill2 = Class(Hero10001_Skill2, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10001_Skill2:CreateInstance(id, hero)
    return Hero10001_Skill2(id, hero)
end

--- @return void
function Hero10001_Skill2:Init()
    self.myHero.battleHelper:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number damage
--- @param target BaseHero
--- @param originMulti number
function Hero10001_Skill2:GetMultiplierDamage(target, originMulti)
    local result = originMulti
    if target.effectController:IsContainEffectType(self.data.effectType) then
        result = originMulti * (1 + self.data.bonusDamage)
    end
    return result
end

return Hero10001_Skill2
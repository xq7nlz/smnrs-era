--- @class Hero30010_Skill2 Erde
Hero30010_Skill2 = Class(Hero30010_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30010_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.addPowerChance = nil
    --- @type number
    self.addPowerAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30010_Skill2:CreateInstance(id, hero)
    return Hero30010_Skill2(id, hero)
end

--- @return void
function Hero30010_Skill2:Init()
    self.addPowerChance = self.data.addPowerChance
    self.addPowerAmount = self.data.addPowerAmount

    self.myHero.skillController.activeSkill:BindingWithSkill_2(self)

    local skill_3 = self.myHero.skillController:GetPassiveSkill(3)
    if skill_3 ~= nil then
        skill_3:BindingWithSkill_2(self)
    end
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param target BaseHero
function Hero30010_Skill2:OnHeal(target)
    if target ~= self.myHero then
        if self.myHero.randomHelper:RandomRate(self.addPowerChance) then
            PowerUtils.GainPower(self.myHero, target, self.addPowerAmount, false)
        end
    end
end

return Hero30010_Skill2
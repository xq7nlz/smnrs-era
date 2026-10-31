--- @class Hero10003_Skill2 Glacious_Fairy
Hero10003_Skill2 = Class(Hero10003_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10003_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type EffectType
    self.effect1_type = nil

    --- @type number
    self.effect1_duration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10003_Skill2:CreateInstance(id, hero)
    return Hero10003_Skill2(id, hero)
end

--- @return void
function Hero10003_Skill2:Init()
    self.effect1_type = self.data.effect1_type
    self.effect1_duration = self.data.effect1_duration

    self.myHero.skillController.activeSkill:BindingWithSkill_2(self)

    local skill_3 = self.myHero.skillController:GetPassiveSkill(3)
    if skill_3 ~= nil then
        skill_3:BindingWithSkill_2(self)
    end
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param target BaseHero
function Hero10003_Skill2:AddMarkToTarget(target)
    if self.myHero ~= target then
        --- @type WaterFriendly
        local mark = WaterFriendly(self.myHero, target)
        mark:SetDuration(self.effect1_duration)
        target.effectController:AddEffect(mark)
    end
end

return Hero10003_Skill2
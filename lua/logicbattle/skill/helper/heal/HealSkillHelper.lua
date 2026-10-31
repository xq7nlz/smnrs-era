--- @class HealSkillHelper : BaseSkillHelper
HealSkillHelper = Class(HealSkillHelper, BaseSkillHelper)

--- @return void
--- @param skill BaseSkill
function HealSkillHelper:Ctor(skill)
    BaseSkillHelper.Ctor(self, skill)

    --- @type BaseHero
    self.actionPerTarget = nil

    --- @type number percent of attack that will be converted to heal amount
    self.healPercent = nil

    --- @type number
    self.healEffectDuration = nil
end

--- @return void
--- @param action function this will be executed per target
--- Signature of function must have the following format
--- --- @param target BaseHero
--- function DummyFunctionCallback(target)
function HealSkillHelper:SetActionPerTarget(action)
    self.actionPerTarget = action
end

--- @return void
--- @param healPercent number
--- @param healEffectDuration number
function HealSkillHelper:SetHealData(healPercent, healEffectDuration)
    self.healPercent = healPercent
    self.healEffectDuration = healEffectDuration
end

---------------------------------------- Use Heal skill ----------------------------------------
--- @return void
--- @param targetList List<BaseHero>
function HealSkillHelper:UseHealSkill(targetList)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        self:OnUseHealSkill(target)
        i = i + 1
    end
end

--- @return void
--- @param target BaseHero
function HealSkillHelper:OnUseHealSkill(target)
    if target:IsDead() == false then
        local healAmount = self:GetHealAmount(target)

        HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)
        if self.healEffectDuration > 1 then
            local healEffect = HealEffect(self.myHero, target, healAmount)
            healEffect:SetDuration(self.healEffectDuration)
            target.effectController:AddEffect(healEffect)
        end

        if self.actionPerTarget ~= nil then
            self.actionPerTarget(self.skill, target)
        end
    end
end

--- @return number
--- @param target BaseHero
function HealSkillHelper:GetHealAmount(target)
    return self.healPercent * self.myHero.attack:GetValue()
end
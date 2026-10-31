--- @class RebornSkillHelper : BaseSkillHelper
RegenerateSkillHelper = Class(RegenerateSkillHelper, BaseSkillHelper)

--- @return void
--- @param skill BaseSkill
function RegenerateSkillHelper:Ctor(skill)
    BaseSkillHelper.Ctor(self, skill)

    --- @type BaseHero
    self.actionPerTarget = nil

    --- @type number
    self.timeReborn = nil

    --- @type BaseSkill
    self.skill = skill

    --- @type number
    self.timeReborn = skill.data.time_reborn
end

--- @return void
--- @param action function this will be executed per target
--- Signature of function must have the following format
--- --- @param target BaseHero
--- function DummyFunctionCallback(target)
function RegenerateSkillHelper:SetActionPerTarget(action)
    self.actionPerTarget = action
end

---------------------------------------- Use skill ----------------------------------------
--- @return boolean can use reborn skill or not
function RegenerateSkillHelper:UseRebornSkill(reason)
    if self.timeReborn > 0 then
        self.timeReborn = self.timeReborn - 1
        self:Reborn(reason)

        if self.actionPerTarget ~= nil then
            self.actionPerTarget(self.skill, self.myHero)
        end
    end
end

--- @return void
--- @param reason TakeDamageReason
function RegenerateSkillHelper:Reborn(reason)
    self.myHero.hp:RebornToEgg()
    ---@type Hero20001_RegenerateEffect
    local regenerateEffect = Hero20001_RegenerateEffect(self.myHero, self.myHero)
    regenerateEffect:SetInfo(self.skill)
    regenerateEffect:SetPersistentType(EffectPersistentType.MANUAL_REMOVE)

    local result = self.myHero.effectController:AddEffect(regenerateEffect)
    if result then
        self:CreateResult(regenerateEffect, reason)
    end
end

--- @return void
--- @param regenerateEffect BaseEffect
--- @param reason TakeDamageReason
function RegenerateSkillHelper:CreateResult(regenerateEffect, reason)
    local result = regenerateEffect:CreateEffectResult(true)
    ActionLogUtils.AddLog(self.myHero.battle, result)
end
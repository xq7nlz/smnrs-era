--- @class SubActiveSkillHelper : BaseSkillHelper
SubActiveSkillHelper = Class(SubActiveSkillHelper, BaseSkillHelper)

--- @return void
--- @param skill BaseSkill
function SubActiveSkillHelper:Ctor(skill)
    BaseSkillHelper.Ctor(self, skill)

    --- @type BaseHero
    self.actionPerTarget = nil

    --- @type number
    self.damageMultiplier = nil
end

--- @return void
--- @param damageMultiplier number
function SubActiveSkillHelper:SetInfo(damageMultiplier)
    self.damageMultiplier = damageMultiplier
end

--- @return void
--- @param action function this will be executed per target
--- Signature of function must have the following format
--- --- @param target BaseHero
--- function DummyFunctionCallback(target)
function SubActiveSkillHelper:SetActionPerTarget(action)
    self.actionPerTarget = action
end

---------------------------------------- Use skill ----------------------------------------
--- @return void
--- @param targetList List<BaseHero>
function SubActiveSkillHelper:UseSubActiveSkill(targetList)
    local triggerResult = TriggerSubActiveResult(self.myHero)
    ActionLogUtils.AddLog(self.myHero.battle, triggerResult)

    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        self:OnUseSubActiveSkill(target)
        i = i + 1
    end
end

--- @return void
--- @param target BaseHero
function SubActiveSkillHelper:UseSubActiveSkillOnTarget(target)
    self:OnUseSubActiveSkill(target)
end

--- @return UseDamageSkillResult
--- @param target BaseHero
function SubActiveSkillHelper:OnUseSubActiveSkill(target)
    if target:IsDead() == false then
        local result = SubActiveSkillResult(self.myHero, target, self.skillName)
        ActionLogUtils.AddLog(self.myHero.battle, result)

        local totalDamage, isCrit, dodgeType, isBlock = self.myHero.battleHelper:CalculateSubActiveResult(target, self.damageMultiplier)
        totalDamage = target.hp:TakeDamage(self.myHero, TakeDamageReason.SUB_ACTIVE_DAMAGE, totalDamage)

        result:SetDamage(totalDamage, isBlock)
        result:RefreshHeroStatus()

        if self.actionPerTarget ~= nil then
            self.actionPerTarget(self.skill, target)
        end
    end
end
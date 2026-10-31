--- @class MainSubActiveSkillHelper : BaseSkillHelper
MainSubActiveSkillHelper = Class(MainSubActiveSkillHelper, BaseSkillHelper)

--- @return void
--- @param skill BaseSkill
function MainSubActiveSkillHelper:Ctor(skill)
    BaseSkillHelper.Ctor(self, skill)

    --- @type BaseHero
    self.actionPerTarget = nil

    --- @type number
    self.damageMultiplier = nil
end

--- @return void
--- @param damageMultiplier number
function MainSubActiveSkillHelper:SetInfo(damageMultiplier)
    self.damageMultiplier = damageMultiplier
end

--- @return void
--- @param action function this will be executed per target
--- Signature of function must have the following format
--- --- @param target BaseHero
--- function DummyFunctionCallback(target)
function MainSubActiveSkillHelper:SetActionPerTarget(action)
    self.actionPerTarget = action
end

---------------------------------------- Use skill ----------------------------------------
--- @return void
--- @param targetList List<BaseHero>
function MainSubActiveSkillHelper:UseMainSubActiveSkill(targetList)
    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        self:OnUseMainSubActiveSkill(target)i = i + 1

    end
end

--- @return void
--- @param target BaseHero
function MainSubActiveSkillHelper:UseMainSubActiveSkillOnTarget(target)
    self:OnUseMainSubActiveSkill(target)
end

--- @return UseDamageSkillResult
--- @param target BaseHero
function MainSubActiveSkillHelper:OnUseMainSubActiveSkill(target)
    if target:IsDead() == false then
        local result = MainSubActiveSkillResult(self.myHero, target, self.skillName)
        ActionLogUtils.AddLog(self.myHero.battle, result)

        local totalDamage, isCrit, dodgeType, isBlock = self.myHero.battleHelper:CalculateSubActiveResult(target, self.damageMultiplier)
        totalDamage = target.hp:TakeDamage(self.myHero, TakeDamageReason.MAIN_SUB_ACTIVE_DAMAGE, totalDamage)

        result:SetDamage(totalDamage, isBlock)
        result:RefreshHeroStatus()

        if self.actionPerTarget ~= nil then
            self.actionPerTarget(self.skill, target)
        end
    end
end
--- @class DamageSkillHelper : BaseSkillHelper
DamageSkillHelper = Class(DamageSkillHelper, BaseSkillHelper)

--- @return void
--- @param skill BaseSkill
function DamageSkillHelper:Ctor(skill)
    BaseSkillHelper.Ctor(self, skill)

    --- @type BaseHero
    self.actionPerTarget = nil

    --- @type BaseHero
    self.damageMultiplier = nil
end

--- @return void
--- @param action function this will be executed per target
--- Signature of function must have the following format
--- function DummyFunctionCallback(target)
function DamageSkillHelper:SetActionPerTarget(action)
    self.actionPerTarget = action
end

--- @return void
--- @param damageMultiplier number
function DamageSkillHelper:SetDamage(damageMultiplier)
    self.damageMultiplier = damageMultiplier
end

---------------------------------------- Use Damage skill ----------------------------------------
--- @return List<UseDamageSkillResult>
--- @param targetList List<BaseHero>
function DamageSkillHelper:UseDamageSkill(targetList)
    local results = List()

    local i = 1
    while i <= targetList:Count() do
        ---@type BaseHero
        local target = targetList:Get(i)
        if target:IsDead() == false then
            local result = self:OnUseDamageSkill(target, self.damageMultiplier)
            results:Add(result)
        end
        i = i + 1
    end

    i = 1
    while i <= results:Count() do
        local result = results:Get(i)
        self:TriggerUseSkillListener(result)
        self:TriggerCritListener(result)
        i = i + 1
    end

    return results
end

--- @return BaseActionResult
--- @param target BaseHero
--- @param multiplier number
function DamageSkillHelper:OnUseDamageSkill(target, multiplier)
    local totalDamage, isCrit, dodgeType, isBlock = self.myHero.battleHelper:CalculateActiveSkillResult(target, multiplier)

    local result = self:CreateResult(target, isCrit, isBlock)
    ActionLogUtils.AddLog(self.myHero.battle, result)

    totalDamage = self:CalculateHeroStatus(target, totalDamage)
    result:SetDamage(totalDamage)

    return result
end

---------------------------------------- Calculate result ----------------------------------------
--- @return UseDamageSkillResult
--- @param target BaseHero
--- @param isCrit boolean
--- @param isBlock boolean
function DamageSkillHelper:CreateResult(target, isCrit, isBlock)
    local result = UseDamageSkillResult(self.myHero, target)
    result:SetInfo(isCrit, isBlock)

    return result
end

--- @return number
--- @param target BaseHero
--- @param totalDamage number
function DamageSkillHelper:CalculateHeroStatus(target, totalDamage)
    target.power:Regen(PowerGainActionType.BE_ATTACKED)

    totalDamage = target.hp:TakeDamage(self.myHero, TakeDamageReason.SKILL_DAMAGE, totalDamage)
    totalDamage = target.effectController.effectListener:OnTakeSkillDamage(self.myHero, totalDamage)

    return totalDamage
end

---------------------------------------- Trigger listeners ----------------------------------------
--- @return number
--- @param result UseDamageSkillResult
function DamageSkillHelper:TriggerCritListener(result)
    if result.isCrit == true then
        self.myHero.skillListener:OnDealCritDamage(result.target, result.damage)
        result.target.skillListener:OnTakeCritDamage(self.myHero, result.damage)
    end
end

--- @return void
--- @param result UseDamageSkillResult
function DamageSkillHelper:TriggerUseSkillListener(result)
    if self.actionPerTarget ~= nil then
        self.actionPerTarget(self.skill, result.target)
    end

    self.myHero.skillListener:OnDealSkillDamageToEnemy(result.target, result.damage)
    result.target.skillListener:OnTakeSkillDamageFromEnemy(self.myHero, result.damage)
    EventUtils.TriggerEventDealSkillDamage(result)
end


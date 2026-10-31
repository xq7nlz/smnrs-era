--- @class CounterAttackSkillHelper : BaseSkillHelper
CounterAttackSkillHelper = Class(CounterAttackSkillHelper, BaseSkillHelper)

--- @return void
--- @param skill BaseSkill
function CounterAttackSkillHelper:Ctor(skill)
    BaseSkillHelper.Ctor(self, skill)

    --- @type BaseHero
    self.actionPerTarget = nil

    --- @type number
    self.damageMultiplier = nil

    --- @type number
    self.counterChance = nil
end

--- @return void
--- @param damageMultiplier number
--- @param counterChance number
function CounterAttackSkillHelper:SetInfo(damageMultiplier, counterChance)
    self.damageMultiplier = damageMultiplier
    self.counterChance = counterChance
end

--- @return void
--- @param action function this will be executed per target
--- Signature of function must have the following format
--- --- @param target BaseHero
--- function DummyFunctionCallback(target)
function CounterAttackSkillHelper:SetActionPerTarget(action)
    self.actionPerTarget = action
end

---------------------------------------- Use skill ----------------------------------------
--- @return void
--- @param targetList List<BaseHero>
function CounterAttackSkillHelper:UseCounterAttack(targetList)
    if self.myHero.randomHelper:RandomRate(self.counterChance) and self.myHero:CanPlay() then
        local i = 1
        while i <= targetList:Count() do
            ---@type BaseHero
            local target = targetList:Get(i)
            self:OnUseCounterAttack(target)
            i = i + 1
        end
    end
end

--- @return void
--- @param target BaseHero
function CounterAttackSkillHelper:UseCounterAttackOnTarget(target)
    if self.myHero.randomHelper:RandomRate(self.counterChance) and self.myHero:CanPlay() then
        self:OnUseCounterAttack(target)
    end
end

--- @return UseDamageSkillResult
--- @param target BaseHero
function CounterAttackSkillHelper:OnUseCounterAttack(target)
    if target:IsDead() == false and target.skillController:CanBeCounterAttack(self.myHero) then
        local result = CounterAttackResult(self.myHero, target)
        ActionLogUtils.AddLog(self.myHero.battle, result)

        local totalDamage, isCrit, dodgeType, isBlock = self.myHero.battleHelper:CalculateCounterAttackResult(target, self.damageMultiplier)
        totalDamage = target.hp:TakeDamage(self.myHero, TakeDamageReason.COUNTER_ATTACK_DAMAGE, totalDamage)

        result:SetInfo(totalDamage, isBlock, dodgeType)
        result:RefreshHeroStatus()

        if self.actionPerTarget ~= nil then
            self.actionPerTarget(self.skill, target)
        end
    end
end
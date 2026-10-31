--- @class StealStatAndReturnSkillHelper : BaseSkillHelper
StealStatAndReturnSkillHelper = Class(StealStatAndReturnSkillHelper, BaseSkillHelper)

--- @return void
--- @param skill BaseSkill
function StealStatAndReturnSkillHelper:Ctor(skill)
    BaseSkillHelper.Ctor(self, skill)

    self.duration = 0

    --- @type Dictionary<StatType, number>
    self.stealTypeAndAmount = Dictionary()

    --- @type List<StealHistory>
    self.stolenStats = List()
end

--- @return void
--- @param duration number
function StealStatAndReturnSkillHelper:SetDuration(duration)
    self.duration = duration
end

--- @return void
--- @param statType StatType
--- @param amount number
function StealStatAndReturnSkillHelper:AddSteal(statType, amount)
    self.stealTypeAndAmount:Add(statType, amount)
end

---------------------------------------- Use skill ----------------------------------------
--- @return void
--- @param target BaseHero
--- @param targetList List<BaseHero>
function StealStatAndReturnSkillHelper:StealStat(target, targetList)
    if target:IsDead() == false and target:IsBoss() == false and self.stealTypeAndAmount:Count() > 0 then
        for statType, amount in pairs(self.stealTypeAndAmount:GetItems()) do
            local statToSteal = target:GetStat(statType)
            local stealAmount = statToSteal:GetMax() * amount
            if statType == StatType.HP then
                stealAmount = MathUtils.Clamp(stealAmount, 0, statToSteal:GetValue() - 1)
            end

            local statChanger = StatChanger(false)
            statChanger:SetInfo(statType, StatChangerCalculationType.RAW_ADD_IN_GAME, stealAmount)

            local statDebuffEffect = StatChangerEffect(self.myHero, target, false)
            statDebuffEffect:SetDuration(self.duration)
            statDebuffEffect:AddStatChanger(statChanger)
            statDebuffEffect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)

            target.effectController:AddEffect(statDebuffEffect)

            local stealStatResult = StealStatResult(self.myHero, target, statType, stealAmount)
            ActionLogUtils.AddLog(self.myHero.battle, stealStatResult)

            local amountForThief = stealAmount / targetList:Count()
            if stealAmount > 0 then
                for j = 1, targetList:Count() do
                    local thief = targetList:Get(j)
                    local statBuffEffect = self:BuffForThief(thief, statType, amountForThief)

                    local history = StealHistory(thief, target, statChanger, statDebuffEffect, statBuffEffect, amountForThief)
                    self.stolenStats:Add(history)
                end
            end
        end
    end
end

--- @return StatChangerEffect
--- @param target BaseHero
--- @param statType StatType
--- @param amount number
function StealStatAndReturnSkillHelper:BuffForThief(target, statType, amount)
    local statChangerBuff = StatChanger(true)
    statChangerBuff:SetInfo(statType, StatChangerCalculationType.RAW_ADD_IN_GAME, amount)

    local statBuffEffect = StatChangerEffect(self.myHero, target, true)
    statBuffEffect:SetDuration(self.duration)
    statBuffEffect:AddStatChanger(statChangerBuff)
    statBuffEffect:SetPersistentType(EffectPersistentType.NON_PERSISTENT_NOT_DISPELLABLE)

    target.effectController:AddEffect(statBuffEffect)

    local result = AddStolenStatResult(self.myHero, target, statType, amount)
    ActionLogUtils.AddLog(self.myHero.battle, result)

    return statBuffEffect
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param eventData table
function StealStatAndReturnSkillHelper:OnDead(eventData)
    local target = eventData.target
    local indexRemove = List()
    local i = 1
    while i <= self.stolenStats:Count() do
        local stolenHistory = self.stolenStats:Get(i)
        if stolenHistory.thief == target then
            stolenHistory.statChanger.amount = stolenHistory.statChanger.amount - stolenHistory.amountStolen
            stolenHistory.amountStolen = 0
            stolenHistory.statDebuffEffect:Recalculate()
            indexRemove:Add(i)
            if stolenHistory.statChanger.amount <= 0 and stolenHistory.statDebuffEffect.duration > 0 then
                stolenHistory.victim.effectController:ForceRemove(stolenHistory.statDebuffEffect)
            end
        elseif stolenHistory.victim == target then
            indexRemove:Add(i)

            stolenHistory.thief.effectController:ForceRemove(stolenHistory.statBuffEffect)
        end
        i = i + 1
    end

    for j = 1, indexRemove:Count() do
        self.stolenStats:RemoveByIndex(indexRemove:Get(j))
    end
end

--- @return void
function StealStatAndReturnSkillHelper:OnEndBattleRound()
    local indexRemove = List()
    local i = 1
    while i <= self.stolenStats:Count() do
        local stolenHistory = self.stolenStats:Get(i)
        if stolenHistory.statDebuffEffect.duration <= 0 then
            indexRemove:Add(i)
        end
        i = i + 1
    end

    for j = 1, indexRemove:Count() do
        self.stolenStats:RemoveByIndex(indexRemove:Get(j))
    end
end
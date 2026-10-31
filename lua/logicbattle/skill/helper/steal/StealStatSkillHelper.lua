--- @class StealStatSkillHelper : BaseSkillHelper
StealStatSkillHelper = Class(StealStatSkillHelper, BaseSkillHelper)

--- @return void
--- @param skill BaseSkill
function StealStatSkillHelper:Ctor(skill)
    BaseSkillHelper.Ctor(self, skill)

    --- @type StatType
    self.statType = nil

    --- @type StatChangerCalculationType
    self.statCalculationType = nil
end

--- @return void
--- @param statType StatType
function StealStatSkillHelper:SetInfo(statType)
    self.statType = statType
    self.statCalculationType = StatChangerCalculationType.RAW_ADD_IN_GAME
end

---------------------------------------- Use skill ----------------------------------------
--- @return void
--- @param target BaseHero
--- @param stealAmount number
function StealStatSkillHelper:StealStat(target, stealAmount)
    if stealAmount > 0 and target:IsDead() == false and target:IsBoss() == false then
        if self.statType == StatType.HP then
            local statToSteal = target:GetStat(self.statType)
            stealAmount = MathUtils.Clamp(stealAmount, 0, statToSteal:GetValue() - 1)
        end

        local amount = self:_ChangeStat(target, stealAmount, false)

        local result = StealStatResult(self.myHero, target, self.statType, amount)
        ActionLogUtils.AddLog(self.myHero.battle, result)
    end
end

--- @return void
--- @param target BaseHero
--- @param stealAmount number
function StealStatSkillHelper:AddStolenStat(target, stealAmount)
    if stealAmount > 0 and target:IsDead() == false then
        local amount = self:_ChangeStat(target, stealAmount, true)

        local result = AddStolenStatResult(self.myHero, target, self.statType, amount)
        ActionLogUtils.AddLog(self.myHero.battle, result)
    end
end

---------------------------------------- Helpers ----------------------------------------
--- @return number
--- @param target BaseHero
--- @param amount number
--- @param isBuff boolean
function StealStatSkillHelper:_ChangeStat(target, amount, isBuff)
    local statChanger = StatChanger(isBuff)
    statChanger:SetInfo(self.statType, self.statCalculationType, amount)

    local effect = StatChangerEffect(self.myHero, target, isBuff)
    effect:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL)
    effect:AddStatChanger(statChanger)

    target.effectController:AddEffect(effect)

    return statChanger:GetAmount()
end
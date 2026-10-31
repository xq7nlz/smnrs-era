--- @class DrowningMark : BaseEffect
DrowningMark = Class(DrowningMark, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param duration number
function DrowningMark:Ctor(initiator, target, duration)
    BaseEffect.Ctor(self, initiator, target, EffectType.DROWNING_MARK, false)
    self:SetDuration(duration)
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param target BaseHero
function DrowningMark:OnEffectAdd(target)
    local result = DrowningMarkResult(self.initiator, self.myHero, self.duration, DrowningMarkChangeType.ADD)
    ActionLogUtils.AddLog(self.myHero.battle, result)
end

--- @return boolean this effect is expired or not
function DrowningMark:DecreaseDuration()
    BaseEffect.DecreaseDuration(self)

    local result = DrowningMarkResult(self.initiator, self.myHero, self.duration, DrowningMarkChangeType.CHANGE_DURATION)
    ActionLogUtils.AddLog(self.myHero.battle, result)

    if self.duration == 0 then
        self.myHero.hp:Dead(self.myHero, TakeDamageReason.DROWNING_KILL)
    end
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function DrowningMark:OnEffectRemove(target)
    local result = DrowningMarkResult(self.initiator, self.myHero, self.duration, DrowningMarkChangeType.REMOVE)
    ActionLogUtils.AddLog(self.myHero.battle, result)
end

--- @return string
function DrowningMark:ToDetailString()
    return string.format("%s, DROWNING_MARK = %s", self:ToString(), self.duration)
end

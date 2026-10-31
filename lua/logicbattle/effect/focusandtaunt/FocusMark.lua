--- @class FocusMark : BaseEffect
FocusMark = Class(FocusMark, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function FocusMark:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.FOCUS_MARK, true)
    self:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)
    self.focusTarget = nil

    self.tauntMark = nil;
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param duration number remaining turn
--- @param tauntMark TauntMark
function FocusMark:UpdateDurationAndTauntMark(duration, tauntMark)
    if self.duration <= duration then
        self.duration = duration
        self.tauntMark = tauntMark
    end
end

--- @return void
--- @param target BaseHero
function FocusMark:SetFocusTarget(target)
    self.focusTarget = target
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param target BaseHero
--- call right before add effect to hero
function FocusMark:OnEffectAdd(target)
    target.effectController.effectListener:Register(EffectListenerType.SELECT_TARGET_FOR_BASIC_ATTACK, self)
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function FocusMark:OnEffectRemove(target)
    target.effectController.effectListener:Unregister(EffectListenerType.SELECT_TARGET_FOR_BASIC_ATTACK, self)
end

--- @return void
--- @param initiator BaseHero
--- @param selectedTargets List<BaseHero>
function FocusMark:OnSelectTargetForBasicAttack(initiator, selectedTargets)
    if self.focusTarget == nil or self.focusTarget:CanBeTargetedByEnemy() == false then
        return
    end

    if selectedTargets ~= nil and selectedTargets:IsContainValue(self.focusTarget) == false then
        selectedTargets:RemoveByIndex(selectedTargets:Count())
        selectedTargets:Add(self.focusTarget)
    end
end

--- @return string
function FocusMark:ToDetailString()
    return string.format("%s, TAUNT MARK %s - %s", self:ToString(), self.focusTarget:ToString(), self.tauntMark:ToDetailString())
end

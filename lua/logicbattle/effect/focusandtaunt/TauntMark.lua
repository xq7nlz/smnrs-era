--- @class TauntMark : BaseEffect
TauntMark = Class(TauntMark, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param duration number
function TauntMark:Ctor(initiator, target, duration)
    BaseEffect.Ctor(self, initiator, target, EffectType.TAUNT_MARK, false)

    self.duration = duration

    self:SetPersistentType(EffectPersistentType.NON_PERSISTENT_NOT_DISPELLABLE)
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function TauntMark:OnEffectRemove(target)
    local attackerTeam, defenderTeam = self.initiator.battle:GetTeam()

    local focusTeam = TargetSelectorUtils.GetAllyTeam(attackerTeam, defenderTeam, self.initiator.teamId)
    local focusList = focusTeam:GetHeroList()

    local i = 1
    while i <= focusList:Count() do
        local hero = focusList:Get(i)

        local effectList = hero.effectController:GetEffectWithType(EffectType.FOCUS_MARK)
        for j = 1, effectList:Count() do
            local effect = effectList:Get(j)
            if effect.tauntMark == nil or effect.tauntMark == self then
                hero.effectController:ForceRemove(effect)
            end
        end
        i = i + 1
    end
end

--- @return string
function TauntMark:ToDetailString()
    return string.format("%s, TAUNT MARK %s", self:ToString(), self.myHero:ToString())
end

--- @return string
function TauntMark:InitToOtherAndMyTeam()
    local attackerTeam, defenderTeam = self.initiator.battle:GetTeam()

    ---------------Remove Old Taunt -----------------
    local tauntTeam = TargetSelectorUtils.GetAllyTeam(attackerTeam, defenderTeam, self.myHero.teamId)
    local targetList = tauntTeam:GetHeroList()

    for i = 1, targetList:Count() do
        local target = targetList:Get(i)
        if target ~= self.myHero then
            local tauntOther = target.effectController:GetEffectWithType(EffectType.TAUNT_MARK)

            local j = 1
            while j <= tauntOther:Count() do
                local taunt = tauntOther:Get(j)
                target.effectController:ForceRemove(taunt)
                j = j + 1
            end
        end
    end

    ---------------Add-----------------
    local focusTeam = TargetSelectorUtils.GetAllyTeam(attackerTeam, defenderTeam, self.initiator.teamId)
    local focusList = focusTeam:GetHeroList()

    local i = 1
    while i <= focusList:Count() do
        local focusTeamHero = focusList:Get(i)
        if focusTeamHero ~= self.myHero then
            local focusEffect = focusTeamHero.effectController:GetEffectWithType(EffectType.FOCUS_MARK)
            if focusEffect ~= nil and focusEffect:Count() > 0 then
                local focus = focusEffect:Get(1)
                focus:SetFocusTarget(self.myHero)
                focus:UpdateDurationAndTauntMark(self.duration, self)
            else
                local focusMark = FocusMark(self.initiator, focusTeamHero)
                focusMark:SetFocusTarget(self.myHero)
                focusMark:UpdateDurationAndTauntMark(self.duration, self)
                focusTeamHero.effectController:AddEffect(focusMark)
            end
        end
        i = i + 1
    end
end
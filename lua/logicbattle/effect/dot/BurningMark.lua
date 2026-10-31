--- @class BurningMark : DotEffect
BurningMark = Class(BurningMark, DotEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function BurningMark:Ctor(initiator, target)
    DotEffect.Ctor(self, initiator, target, EffectType.BURNING_MARK)

    --- @type List<StatChanger>
    self.statChangerList = List()
end

--- @return BurningEffectResult
function BurningMark:CreateEffectResult()
    return BurningMarkResult(self.initiator, self.myHero, self.duration)
end

--- @return TakeDamageReason
function BurningMark:GetTakeDamageReason()
    return TakeDamageReason.BURNING
end

--- @return void
--- @param statChanger StatChanger
function BurningMark:AddStatChanger(statChanger)
    self.statChangerList:Add(statChanger)
end

--- @return void
--- @param target BaseHero
function BurningMark:OnEffectAdd(target)
    DotEffect.OnEffectAdd(self, target)
    local i = 1
    while i <= self.statChangerList:Count() do
        local statChanger = self.statChangerList:Get(i)
        local heroStat = self.myHero.heroStats:Get(statChanger.statAffectedType)

        heroStat:AddChanger(statChanger)
        heroStat:Calculate()
        i = i + 1
    end
end

--- @return void
--- @param target BaseHero
function BurningMark:OnEffectRemove(target)
    DotEffect.OnEffectRemove(self, target)
    local i = 1
    while i <= self.statChangerList:Count() do
        local statChanger = self.statChangerList:Get(i)
        local heroStat = self.myHero.heroStats:Get(statChanger.statAffectedType)

        heroStat:RemoveStatChanger(statChanger)
        heroStat:Calculate()
        i = i + 1
    end
end

--- @return void
function BurningMark:Recalculate()
    local i = 1
    while i <= self.statChangerList:Count() do
        local statChanger = self.statChangerList:Get(i)
        local heroStat = self.myHero.heroStats:Get(statChanger.statAffectedType)

        heroStat:Calculate()
        i = i + 1
    end
end
--- @class StatTransferEffect : BaseEffect
StatTransferEffect = Class(StatTransferEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param isBuff boolean
function StatTransferEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.STAT_TRANSFER, true)

    --- @type List<StatChanger>
    self.statChangerList = List()

    --- @type number
    self.amountMultiplier = 1

    --- @type StatChangerEffectSource
    self.effectSource = StatChangerEffectSource.PASSIVE

    --- @type EffectPersistentType
    self.persistentType = EffectPersistentType.EFFECT_SPECIAL

end

--- @return void
--- @param statChanger StatChanger
function StatTransferEffect:AddStatChanger(statChanger)
    self.statChangerList:Add(statChanger)
end

--- @return void
--- @param multiplier number
function StatTransferEffect:SetMultiplier(multiplier)
    self.amountMultiplier = multiplier
    local i = 1
    while i <= self.statChangerList:Count() do
        ---@type StatChanger
        local statChanger = self.statChangerList:Get(i)
        statChanger:SetMultiplier(self.amountMultiplier)

        local heroStat = self.myHero.heroStats:Get(statChanger.statAffectedType)
        heroStat:Calculate()
        i = i + 1
    end
end

--- @return void
--- @param effectSource StatChangerEffectSource
function StatTransferEffect:SetEffectSource(effectSource)
    self.effectSource = effectSource
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param target BaseHero
function StatTransferEffect:OnEffectAdd(target)
    if self.persistentType == EffectPersistentType.NON_PERSISTENT then
        if self.isBuff == true then
            --- Only affect to buff
            if target.effectController:IsContainEffectType(EffectType.PETRIFY) then
                self.amountMultiplier = 1 - EffectConstants.PETRIFY_BUFF_REDUCTION
            end
        else
            --- Only affect to debuff
            if target.effectController:IsContainEffectType(EffectType.SLEEP) then
                self.amountMultiplier = 1 + EffectConstants.SLEEP_DEBUFF_BONUS
            end
        end
    end

    local i = 1
    while i <= self.statChangerList:Count() do
        ---@type StatChanger
        local statChanger = self.statChangerList:Get(i)
        statChanger:SetMultiplier(self.amountMultiplier)
        ---@type BaseHeroStat
        local heroStat = self.myHero.heroStats:Get(statChanger.statAffectedType)

        local beforeValue = heroStat:GetValue()

        heroStat:AddChanger(statChanger)
        heroStat:Calculate()

        if self.persistentType ~= EffectPersistentType.PERMANENT then
            local valueChanged = math.abs(heroStat:GetValue() - beforeValue) * self.duration
            self.initiator.battle.statisticsController:OnStatChangerAdd(self.initiator,
                    statChanger.statAffectedType, valueChanged, statChanger.isBuff)
        end
        i = i + 1
    end
end

--- @return void
--- @param target BaseHero
function StatTransferEffect:OnEffectRemove(target)
    local i = 1
    while i <= self.statChangerList:Count() do
        ---@type StatChanger
        local statChanger = self.statChangerList:Get(i)
        ---@type BaseHeroStat
        local heroStat = self.myHero.heroStats:Get(statChanger.statAffectedType)
        heroStat:RemoveStatChanger(statChanger)
        heroStat:Calculate()
        i = i + 1
    end
end

--- @return void
function StatTransferEffect:Recalculate()
    local i = 1
    while i <= self.statChangerList:Count() do
        ---@type StatChanger
        local statChanger = self.statChangerList:Get(i)
        statChanger:SetMultiplier(self.amountMultiplier)
        ---@type BaseHeroStat
        local heroStat = self.myHero.heroStats:Get(statChanger.statAffectedType)
        heroStat:Calculate()
        i = i + 1
    end
end
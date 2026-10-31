--- @class EffectLog
EffectLog = Class(EffectLog)

--- @return void
--- @param duration number
function EffectLog:Ctor(duration)
    --- @type number
    self.remainingRound = duration
    --- @type EffectLogType
    self.type = nil
    --- @type EffectPersistentType
    self.persistentType = nil
    --- @type boolean
    self.isBuff = nil

    --- @type string
    --self.effectString = nil
end

--- @return void
--- @param effect BaseEffect
function EffectLog:SetEffect(effect)
    self.isBuff = effect.isBuff
    self.type = effect.type
    self.persistentType = effect.persistentType

    --self.effectString = effect:ToDetailString()
end

--- @return void
--- @param initiator BaseHero
--- @param statChanger StatChanger
function EffectLog:SetStatChanger(initiator, statChanger, persistentType)
    self.isBuff = statChanger.isBuff
    self.type = EffectConstants.STAT_CHANGER_EFFECT_START_ID + statChanger.statAffectedType
    self.persistentType = persistentType

    --self.effectString = string.format("id = %s, type = %s, initiator = %s, isBuff = %s, duration = %s, persistentType = %s",
    --        tostring(statChanger), self.type, initiator:ToString(), tostring(self.isBuff), self.remainingRound, self.persistentType)
    --
    --self.effectString = string.format("%s, calculationType = %s, amount = %s, changerType = %s, multiplier = %s",
    --        self.effectString, statChanger.calculationType, statChanger:GetAmount(), statChanger.type, statChanger.amountMultiplier)
end

--- @return EffectLog
function EffectLog:GetData()
    local data = {}
    data.remainingRound = self.remainingRound
    data.isBuff = self.isBuff
    data.type = self.type
    data.persistentType = self.persistentType

    return data
end

--- @return string
function EffectLog:ToString()
    return self.effectString
end
--- @class PowerUtils
PowerUtils = {}

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param amount number
--- @param isPassThroughCurse boolean
function PowerUtils.GainPower(initiator, target, amount, isPassThroughCurse)
    if target:IsDead() == false then
        amount = math.floor(amount)

        if isPassThroughCurse == true then
            target.power:Gain(initiator, amount)
        else
            if target.effectController:IsTriggerMarkEffect(EffectType.CURSE_MARK, EffectType.POWER_GAIN) == false then
                target.power:Gain(initiator, amount)
            else
                ActionLogUtils.CreateResistEffectResult(initiator, target, EffectType.POWER_GAIN)
            end
        end
    end
end

return PowerUtils
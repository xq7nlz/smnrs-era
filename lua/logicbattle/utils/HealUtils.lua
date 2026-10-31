--- @class HealUtils
HealUtils = {}

--- @return boolean, number
--- @param initiator BaseHero
--- @param target BaseHero
--- @param healAmount number
--- @param healReason HealReason
function HealUtils.Heal(initiator, target, healAmount, healReason)
    local canHeal = false

    if target:IsDead() == false then

        healAmount = math.floor(healAmount)

        if healReason == HealReason.HEAL_SKILL
                or healReason == HealReason.THANATOS_HEAL_SKILL
                or healReason == HealReason.DIADORA_HEAL_SKILL then
            if target.effectController:IsTriggerMarkEffect(EffectType.CURSE_MARK, EffectType.HEAL) == false then
                canHeal, healAmount = target.hp:Heal(initiator, healReason, healAmount)
                if canHeal == true then
                    ActionLogUtils.CreateHealResult(initiator, target, healAmount, healReason)
                end
            end

            if canHeal == false then
                ActionLogUtils.CreateResistEffectResult(initiator, target, EffectType.HEAL)
            else
                EventUtils.TriggerEventHeal(initiator, target, healReason, healAmount)
            end
        else
            canHeal, healAmount = target.hp:Heal(initiator, healReason, healAmount)
            if canHeal == true then
                ActionLogUtils.CreateHealResult(initiator, target, healAmount, healReason)

                EventUtils.TriggerEventHeal(initiator, target, healReason, healAmount)
            end
        end
    else
        healAmount = 0
    end

    return canHeal, healAmount
end

return HealUtils
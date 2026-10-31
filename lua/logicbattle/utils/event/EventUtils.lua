--- @class EventUtils
EventUtils = {}

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function EventUtils.TriggerEventTakeDamage(initiator, target, reason, damage)
    local eventData = {
        ["initiator"] = initiator,
        ["target"] = target,
        ["reason"] = reason,
        ["damage"] = damage
    }

    if reason == TakeDamageReason.ATTACK_DAMAGE or reason == TakeDamageReason.SKILL_DAMAGE
            or reason == TakeDamageReason.COUNTER_ATTACK_DAMAGE or reason == TakeDamageReason.SUB_ACTIVE_DAMAGE then
        target.battle.eventManager:AddQueuedEvent(EventType.HERO_TAKE_DAMAGE, eventData)
    else
        target.battle.eventManager:TriggerEvent(EventType.HERO_TAKE_DAMAGE, eventData)
    end
    initiator.battle.statisticsController:AddDamageDeal(initiator, damage, reason)
end

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param reason HealReason
--- @param healAmount number
function EventUtils.TriggerEventHeal(initiator, target, reason, healAmount)
    local eventData = {
        ["initiator"] = initiator,
        ["target"] = target,
        ["reason"] = reason,
        ["healAmount"] = healAmount
    }

    target.battle.eventManager:AddQueuedEvent(EventType.HERO_HEAL, eventData)
    target.battle.statisticsController:AddHpHeal(initiator, target, healAmount, reason)
end

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param reason TakeDamageReason
function EventUtils.TriggerEventDead(initiator, target, reason)
    local eventData = {
        ["initiator"] = initiator,
        ["target"] = target,
        ["reason"] = reason
    }

    target.battle.eventManager:AddQueuedEvent(EventType.HERO_DEAD, eventData)
    target.battle.statisticsController:AddHeroDead(initiator, target)

    ActionLogUtils.CreateDeadForDisplayResult(initiator.battle, eventData)
end

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function EventUtils.TriggerEventRevive(initiator, target)
    local eventData = {
        ["initiator"] = initiator,
        ["target"] = target
    }

    target.battle.eventManager:AddQueuedEvent(EventType.HERO_REVIVE, eventData)
    target.battle.statisticsController:AddHeroRevived(initiator, target)
end

--- @return void
--- @param initiator BaseHero
function EventUtils.TriggerEventBasicAttack(initiator)
    local eventData = {
        ["initiator"] = initiator
    }

    initiator.battle.eventManager:TriggerEvent(EventType.DO_BASIC_ATTACK, eventData)
end

--- @return void
--- @param initiator BaseHero
--- @param results List<UseDamageSkillResult>
function EventUtils.TriggerEventUseActiveSkill(initiator, results)

    --- @type List<BaseHero>
    local targets = List()
    local i = 1
    while i <= results:Count() do
        local result = results:Get(i)
        targets:Add(result.target)

        i = i + 1
    end

    local eventData = {
        ["initiator"] = initiator,
        ["targets"] = targets
    }

    initiator.battle.eventManager:TriggerEvent(EventType.USE_ACTIVE_SKILL, eventData)
end

--- @return void
--- @param attackResult AttackResult
function EventUtils.TriggerEventDealBasicAttackDamage(attackResult)
    local eventData = {
        ["initiator"] = attackResult.initiator,
        ["target"] = attackResult.target,
        ["damage"] = attackResult.damage,
        ["dodgeType"] = attackResult.dodgeType,
        ["isCrit"] = attackResult.isCrit
    }

    attackResult.initiator.battle.eventManager:TriggerEvent(EventType.DEAL_BASIC_ATTACK_DAMAGE, eventData)
end

--- @return void
--- @param skillResult UseDamageSkillResult
function EventUtils.TriggerEventDealSkillDamage(skillResult)
    local eventData = {
        ["initiator"] = skillResult.initiator,
        ["target"] = skillResult.target,
        ["damage"] = skillResult.damage,
        ["dodgeType"] = skillResult.dodgeType,
        ["isCrit"] = skillResult.isCrit,
        ["round"] = skillResult.round
    }

    skillResult.initiator.battle.eventManager:TriggerEvent(EventType.DEAL_SKILL_DAMAGE, eventData)
end

--- @return void
--- @param initiator BaseHero
--- @param round BattleRound
function EventUtils.TriggerEventRoundStart(initiator, round)
    local eventData = {
        ["initiator"] = initiator,
        ["round"] = round
    }

    initiator.battle.eventManager:TriggerEvent(EventType.START_ROUND, eventData)
end

return EventUtils
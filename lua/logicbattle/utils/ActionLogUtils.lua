--- @class ActionLogUtils
ActionLogUtils = {}

--- @return void
--- @param battle Battle
--- @param result BaseActionResult
function ActionLogUtils.AddLog(battle, result)
    if battle:CanRun(RunMode.FASTEST) then
        if battle.battlePhase == BattlePhase.PREPARE_BATTLE then
            battle.battleResult:AddStartBattleLog(result)
        elseif battle.battlePhase == BattlePhase.RESOLVE_ROUND then
            battle.battleRound.battleTurn.battleTurnLog:AddResult(result)
        elseif battle.battlePhase == BattlePhase.BEFORE_ROUND then
            battle.battleRound.battleRoundLog:AddBeforeRoundResult(result)
        elseif battle.battlePhase == BattlePhase.AFTER_ROUND then
            battle.battleRound.battleRoundLog:AddAfterRoundResult(result)
        end
    end
end

---------------------------------------- Dead result ----------------------------------------
--- @return void
--- @param battle Battle
--- @param eventData table
function ActionLogUtils.CreateDeadResult(battle, eventData)
    if battle:CanRun(RunMode.FASTEST) then
        local result = DeadActionResult(eventData)
        ActionLogUtils.AddLog(battle, result)
    end
end

--- @return void
--- @param battle Battle
--- @param eventData table
function ActionLogUtils.CreateDeadForDisplayResult(battle, eventData)
    if battle:CanRun(RunMode.FASTEST) then
        local result = DeadForDisplayActionResult(eventData)
        ActionLogUtils.AddLog(battle, result)
    end
end

---------------------------------------- Effect result ----------------------------------------
--- @return void
--- @param hero BaseHero
--- @param effect BaseEffect
--- @param changeType EffectChangeType
function ActionLogUtils.CreateEffectChangeResult(hero, effect, changeType)
    if hero.battle:CanRun(RunMode.FASTEST) then
        if hero:IsDead() == false then
            if effect.type == EffectType.STAT_CHANGER then
                for i = 1, effect.statChangerList:Count() do
                    local statChanger = effect.statChangerList:Get(i)

                    local effectLogType = EffectConstants.STAT_CHANGER_EFFECT_START_ID + statChanger.statAffectedType

                    local result = EffectChangeResult(effect, effectLogType, effect.persistentType, effect.isBuff, changeType)
                    ActionLogUtils.AddLog(hero.battle, result)
                end
            else
                local result = EffectChangeResult(effect, effect.type, effect.persistentType, effect.isBuff, changeType)
                ActionLogUtils.AddLog(hero.battle, result)
            end
        end
    end
end

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param healAmount number
--- @param healReason HealReason
function ActionLogUtils.CreateHealResult(initiator, target, healAmount, healReason)
    if initiator.battle:CanRun(RunMode.FASTEST) then
        local result = HealResult(initiator, target, healAmount, healReason)
        ActionLogUtils.AddLog(initiator.battle, result)
    end
end

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function ActionLogUtils.CreatePowerChangeResult(initiator, target)
    if initiator.battle:CanRun(RunMode.FASTEST) then
        local result = ChangePowerActionResult(initiator, target)
        ActionLogUtils.AddLog(initiator.battle, result)
    end
end

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param effectType EffectType
function ActionLogUtils.CreateResistEffectResult(initiator, target, effectType)
    if initiator.battle:CanRun(RunMode.FASTEST) then
        -- target is resisted effect from initiator
        local result = ResistEffectResult(target, initiator, effectType)
        ActionLogUtils.AddLog(initiator.battle, result)
    end
end

return ActionLogUtils
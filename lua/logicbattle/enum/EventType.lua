--- @class EventType
EventType = {
    --- initiator: BaseHero
    --- target: BaseHero
    HERO_REVIVE = 1,

    --- initiator: BaseHero
    --- target: BaseHero
    --- reason: TakeDamageReason
    HERO_DEAD = 2,

    --- initiator: BaseHero
    --- target: BaseHero
    --- reason: TakeDamageReason
    --- damage: number
    HERO_TAKE_DAMAGE = 3,

    --- initiator: BaseHero
    --- target: BaseHero
    --- reason: HealReason
    --- healAmount: number
    HERO_HEAL = 4,

    --- initiator: BaseHero
    DO_BASIC_ATTACK = 11,

    --- initiator: BaseHero
    USE_ACTIVE_SKILL = 12,

    --- initiator: BaseHero
    --- target: BaseHero
    --- damage: number
    --- dodgeType: DodgeType
    --- isCrit: boolean
    DEAL_BASIC_ATTACK_DAMAGE = 21,

    --- initiator: BaseHero
    --- target: BaseHero
    --- damage: number
    --- dodgeType: DodgeType
    --- isCrit: boolean
    DEAL_SKILL_DAMAGE = 22,

    --- initiator: BaseHero
    --- round: BattleRound
    START_ROUND = 30,
}

return EventType
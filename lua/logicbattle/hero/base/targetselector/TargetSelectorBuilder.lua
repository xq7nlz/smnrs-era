--- @class TargetSelectorBuilder
TargetSelectorBuilder = {}

--- @return BaseTargetSelector
--- @param hero BaseHero
--- @param targetPosition TargetPositionType
--- @param targetTeam TargetTeamType
--- @param targetNumber number
function TargetSelectorBuilder.Create(hero, targetPosition, targetTeam, targetNumber)
    local selector

    if targetPosition == TargetPositionType.SELF then
        selector = SelfSelector(hero)
    elseif targetPosition == TargetPositionType.RANDOM then
        selector = RandomSelector(hero)

    elseif targetPosition == TargetPositionType.PREFER_FRONT_LINE then
        selector = PreferFrontLineSelector(hero)
    elseif targetPosition == TargetPositionType.PREFER_BACK_LINE then
        selector = PreferBackLineSelector(hero)

    elseif targetPosition == TargetPositionType.LOWEST_HP then
        selector = LowestHpSelector(hero)
    elseif targetPosition == TargetPositionType.HIGHEST_ATK then
        selector = HighestAttackSelector(hero)
    elseif targetPosition == TargetPositionType.LOWEST_DEF then
        selector = LowestDefenseSelector(hero)
    elseif targetPosition == TargetPositionType.HIGHEST_DEF then
        selector = HighestDefenseSelector(hero)

    elseif targetPosition == TargetPositionType.HIGHEST_HP then
        selector = HighestHpSelector(hero)
    elseif targetPosition == TargetPositionType.HIGHEST_HP_PERCENT then
        selector = HighestHpPercentSelector(hero)
    elseif targetPosition == TargetPositionType.LOWEST_HP_PERCENT then
        selector = LowestHpPercentSelector(hero)

    elseif targetPosition == TargetPositionType.ORDERED then
        selector = OrderedTargetSelector(hero)
    elseif targetPosition == TargetPositionType.INDEX_POSITION then
        selector = IndexPositionSelector(hero)

    elseif targetPosition == TargetPositionType.PREFER_HERO_CLASS then
        selector = PreferHeroClassSelector(hero)
    elseif targetPosition == TargetPositionType.PREFER_EFFECT then
        selector = PreferHeroWithEffectSelector(hero)

    elseif targetPosition == TargetPositionType.SAME_LINE then
        selector = SameLineTargetSelector(hero)
    elseif targetPosition == TargetPositionType.NOT_SAME_LINE then
        selector = NotSameLineTargetSelector(hero)
    elseif targetPosition == TargetPositionType.PREFER_HIGH_POSITION then
        selector = PreferHighPositionSelector(hero)
    end

    if selector ~= nil then
        selector:SetInfo(targetPosition, targetTeam, targetNumber)
    else
        assert(false)
    end

    return selector
end

return TargetSelectorBuilder
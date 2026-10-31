--- @class SummonerUtils
SummonerUtils = {}

--- @return void
--- @param skillLevel number
function SummonerUtils.GetSkillTier(skillLevel)
    if skillLevel <= HeroConstants.SUMMONER_SKILL_TIER_1 then
        return 1
    elseif skillLevel <= HeroConstants.SUMMONER_SKILL_TIER_2 then
        return 2
    end

    return 3
end

return SummonerUtils
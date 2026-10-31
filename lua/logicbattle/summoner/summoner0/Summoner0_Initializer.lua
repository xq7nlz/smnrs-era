--- @class SummonerNovice_Initializer : SummonerInitializer
SummonerNovice_Initializer = Class(SummonerNovice_Initializer, SummonerInitializer)

--- @return table
--- @param heroId number
--- @param skillId number
--- @param skillLevel number
function SummonerNovice_Initializer:GetSkillLuaFile(heroId, skillId, skillLevel)
    return require(string.format(LuaPathConstants.SUMMONER_NOVICE_SKILL_PATH, skillId))
end
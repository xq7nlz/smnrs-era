--- @class SummonerInitializer : HeroInitializer
SummonerInitializer = Class(SummonerInitializer, HeroInitializer)

---------------------------------------- Create components ----------------------------------------
--- @return void
function SummonerInitializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Summoner_HpStat(self.myHero)
    self.myHero.power = Summoner_PowerStat(self.myHero)
end

--- @return void
function SummonerInitializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.skillController = Summoner_SkillController(self.myHero)
    self.myHero.effectController = Summoner_EffectController(self.myHero)
end

---------------------------------------- Set data ----------------------------------------
--- @return HeroDataEntry
--- @param heroDataService HeroDataService
function SummonerInitializer:GetHeroDataEntry(heroDataService)
    return heroDataService:GetSummonerDataEntry(self.myHero.id)
end

--- @return List<number>
--- @param heroDataService HeroDataService
function SummonerInitializer:GetSkillLevels(heroDataService)
    return self.myHero.skillLevels
end

--- @return table
--- @param heroId number
--- @param skillId number
--- @param skillLevel number
function SummonerInitializer:GetSkillLuaFile(heroId, skillId, skillLevel)
    local tier = SummonerUtils.GetSkillTier(skillLevel)
    return require(string.format(LuaPathConstants.SUMMONER_SKILL_PATH, heroId, heroId, skillId, tier))
end

---------------------------------------- Init ----------------------------------------
--- @return void
--- @param heroDataService HeroDataService
function SummonerInitializer:InitMastery(heroDataService)
    --- do nothing
end

--- @return void
--- @param itemDataService ItemDataService
function SummonerInitializer:InitItems(itemDataService)
    --- do nothing
end

---------------------------------------- Set formation ----------------------------------------
--- @return void
--- @param heroDataService HeroDataService
--- @param formationId number
--- @param numberFrontLine number
--- @param numberBackLine number
function SummonerInitializer:SetFormation(heroDataService, formationId, numberFrontLine, numberBackLine)
    self.myHero.positionInfo:SetFormationId(formationId)
end
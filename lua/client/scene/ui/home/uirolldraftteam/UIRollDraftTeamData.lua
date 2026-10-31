--- @class UIRollDraftTeamData
UIRollDraftTeamData = Class(UIRollDraftTeamData)

--- @return void
--- @param formationId number
--- @param heroList List
function UIRollDraftTeamData:Ctor(summonerId, formationId, heroList)
    --- @type number
    self.formationId = formationId
    --- @type List -- {heroResource:HeroResource, isFrontLine : boolean, position:number}
    self.heroList = heroList
end

--- @return string
function UIRollDraftTeamData:ToString()
    local str = string.format("formation: %d\n", self.formationId)
    for i, v in ipairs(self.heroList:GetItems()) do
        str = str .. LogUtils.ToDetail(v) .. "\n"
    end
    return str
end

--- @return UIFormationTeamData
--- @param team BattleTeamInfo
function UIRollDraftTeamData.CreateByBattleTeamInfo(team)
    local heroList = List()
    --- @param hero HeroBattleInfo
    for i, hero in ipairs(team.listHeroInfo:GetItems()) do
        local heroResource = HeroResource.CreateInstanceByHeroBattleInfo(hero)
        heroList:Add({['heroResource'] = heroResource, ['isFrontLine'] = hero.isFrontLine, ['position'] = hero.position})
    end
    return UIRollDraftTeamData(team.summonerBattleInfo.summonerId, team.formation, heroList)
end


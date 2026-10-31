--- @class TeamHeroPredefine
TeamHeroPredefine = Class(TeamHeroPredefine)

--- @return void
function TeamHeroPredefine:Ctor()

    --- @type number
    self.teamFormationId = -1

    --- @type number
    self.teamId = -1

    --- @type number
    self.formation = -1

    ---@type List<HeroPredefine>
    self.listHeroPredefine = List()

    ---@type SummonerBattleInfo
    self.summonerBattleInfo = nil
end

--- @return void
--- @param teamFormationId number
--- @param formation number
function TeamHeroPredefine:SetInfo(teamFormationId, formation)
    self.teamFormationId = teamFormationId
    self.formation = formation
end

--- @return void
--- @param heroPredefine HeroPredefine
function TeamHeroPredefine:AddHero(heroPredefine)
    self.listHeroPredefine:Add(heroPredefine)
end

--- @return void
--- @param summonerBattleInfo SummonerBattleInfo
function TeamHeroPredefine:SetSummonerBattleInfo(summonerBattleInfo)
    self.summonerBattleInfo = summonerBattleInfo
end
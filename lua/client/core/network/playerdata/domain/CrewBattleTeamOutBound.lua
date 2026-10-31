--- @class CrewBattleTeamOutBound : OutBound
CrewBattleTeamOutBound = Class(CrewBattleTeamOutBound, OutBound)

function CrewBattleTeamOutBound:Ctor()
    --- @type number
    self.summonerId = nil
    --- @type number
    self.formationId = nil
    --- @type List
    self.listHero = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function CrewBattleTeamOutBound:Serialize(buffer)
    buffer:PutInt(self.summonerId)
    buffer:PutInt(self.formationId)

    buffer:PutByte(self.listHero:Count())

    for i = 1, self.listHero:Count() do
        --- @type CrewBattleHeroOutBound
        local crewBattleHeroOutBound = self.listHero:Get(i)
        crewBattleHeroOutBound:Serialize(buffer)
    end
    --XDebug.Log(LogUtils.ToDetail(self))
end

--- @param uiFormationTeamData UIFormationTeamData
function CrewBattleTeamOutBound:SetFormationTeamData(uiFormationTeamData)
    self.summonerId = uiFormationTeamData.summonerId
    self.formationId = uiFormationTeamData.formationId

    self.listHero = List()
    for i = 1, uiFormationTeamData.heroList:Count() do
        --- @type {heroResource : HeroResource, isFrontLine : boolean, position:number}
        local heroData = uiFormationTeamData.heroList:Get(i)
        local crewBattleHeroOutBound = CrewBattleHeroOutBound()
        crewBattleHeroOutBound:SetHeroData(heroData)
        self.listHero:Add(crewBattleHeroOutBound)
    end
end
require "lua.client.battleShow.LogDetail.ClientEffectLogDetail"

--- @class ClientTeamDetail
ClientTeamDetail = Class(ClientTeamDetail)

--- @return void
--- @param battleTeam BattleTeam
function ClientTeamDetail:Ctor(battleTeam)
    --- @type number
    self.formationId = nil
    --- @type number
    self.companionBuffId = nil
    --- @type List<BaseHero>
    self.baseHeroList = List()
    --- @type Dictionary<BaseHero,ClientEffectLogDetail>
    self.heroEffectDict = Dictionary()

    self:InitData(battleTeam)
end

--- @return void
--- @param battleTeam BattleTeam
function ClientTeamDetail:InitData(battleTeam)
    --- formation
    self.formationId = battleTeam.formationId
    --- Companion Buff
    if battleTeam.companionBuffData ~= nil then
        self.companionBuffId = battleTeam.companionBuffData.id
    end

    --- Init Hero List
    self:InitHeroList(battleTeam)
end

--- @return void
--- @param battleTeam BattleTeam
function ClientTeamDetail:InitHeroList(battleTeam)
    self.baseHeroList:AddAll(battleTeam:GetHeroList())
    self.baseHeroList:Add(battleTeam:GetSummoner())
end

--- @param baseActionResult BaseActionResult
function ClientTeamDetail:SetEffectAndGetDifferent(baseActionResult)
    if self.heroEffectDict:IsContainKey(baseActionResult.target) then
        --- @type ClientEffectLogDetail
        local localEffectLogDetail = self.heroEffectDict:Get(baseActionResult.target)
        localEffectLogDetail:Update(baseActionResult)
    else
        local localEffectLogDetail = baseActionResult:Clone()
        self.heroEffectDict:Add(baseActionResult.target, localEffectLogDetail)
    end
end

--- @return string
function ClientTeamDetail:ToString()
    local content = ""
    for i = 1, self.baseHeroList:Count() do
        local heroDetail = self.baseHeroList:Get(i)
        content = content .. heroDetail:ToString() ..  "\n"
    end
    return content
end
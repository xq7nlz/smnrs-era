require "lua.client.core.network.playerData.arena.ArenaOpponentInBound"
require "lua.client.core.network.battleRecord.BattleRecordDataInBound"
require "lua.client.core.network.battleRecord.ArenaTeamBattleData"

--- @class ArenaData
ArenaData = Class(ArenaData)

function ArenaData:Ctor()
    --- @type ArenaOpponentInBound
    self.arenaOpponentInBound = nil
    --- @type BattleRecordDataInBound
    self.arenaRecordDataInBound = nil
    --- @type ArenaTeamBattleData
    self.arenaTeamBattleData = nil
    --- @type number
    self.indexArenaTeam = 1
    --- @type BattleRecordDataInBound
    self.arenaTeamRecordDataInBound = nil

    --- @type Dictionary
    self.battleDetailDict = Dictionary()

    --- @type ArenaTeamChallengeInBound
    self.arenaTeamChallengeInBound = nil

    --- @type Dictionary
    self.battleResultInBoundDict = Dictionary()
end

--- @param battleResult BattleResult
--- @param clientLogDetail ClientLogDetail
function ArenaData:SaveDetail(match, battleResult, clientLogDetail)
    local data = {}
    data.battleResult = battleResult
    data.clientLogDetail = clientLogDetail
    self.battleDetailDict:Add(match, data)
end

--- @param arenaTeamChallengeInBound ArenaTeamChallengeInBound
function ArenaData:CacheData(arenaTeamChallengeInBound)
    self.battleDetailDict:Clear()
    zg.battleMgr.gameMode = GameMode.ARENA_TEAM
    self.arenaTeamChallengeInBound = arenaTeamChallengeInBound
end

--- @return {battleResult : BattleResult, clientLogDetail: ClientLogDetail}
function ArenaData:GetBattleDetail(battleIndex)
    --- @type {battleResult : BattleResult, clientLogDetail: ClientLogDetail}
    local data = self.battleDetailDict:Get(battleIndex)
    if data == nil then
        data = {}
        ---@type BattleResultInBound
        local battleResultInBound = self.arenaTeamChallengeInBound:GetBattleResultInfo(battleIndex)
        ---@type BattleTeamInfo
        local attackerTeam = ClientConfigUtils.GetBattleTeamInfoArenaTeam(1, battleIndex)
        for i, v in pairs(battleResultInBound.activeLinking:GetItems()) do
            attackerTeam:AddLinkingGroup(i, v)
        end
        ---@type RandomHelper
        local randomHelper = RandomHelper()
        randomHelper:SetSeed(battleResultInBound.seedInBound.seed)
        zg.battleMgr:RunVirtualBattle(attackerTeam,
                self.arenaTeamChallengeInBound:GetBattleTeamInfoDefender(battleIndex),
                GameMode.ARENA_TEAM, randomHelper, RunMode.FAST)
        data.battleResult = ClientBattleData.battleResult
        data.clientLogDetail = ClientBattleData.clientLogDetail

        self.battleDetailDict:Add(battleIndex, data)
    end
    return data
end

return ArenaData
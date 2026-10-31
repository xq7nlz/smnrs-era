require "lua.client.core.network.playerData.arena.SingleArenaRanking"
require "lua.client.core.network.playerData.arenaTeam.SingleArenaTeamRanking"

--- @class ArenaTeamInBound
ArenaTeamInBound = Class(ArenaTeamInBound)

function ArenaTeamInBound:Ctor()
    --- @type number
    self.lastTimeGetRanking = nil
    --- @type List
    self.rankingDataList = nil
    --- @type number
    self.currentRanking = nil
    --- @type number
    self.rankType = nil
end

function ArenaTeamInBound:InitRegenTime()
    self.regenTimeData = RegenTimeData()
    self.regenTimeData.max = ResourceMgr.GetArenaTeamConfig().maxTicket
    self.regenTimeData.step = ResourceMgr.GetArenaTeamConfig().ticketRegenInterval
    self.regenTimeData.getLastRegenTime = function()
        return self.regenTime
    end
    self.regenTimeData.setLastRegenTime = function(time)
        self.regenTime = time
    end
    InventoryUtils.AddRegenTimeData(ResourceType.Money, MoneyType.ARENA_TEAM_TICKET, self.regenTimeData)
end

--- @param buffer UnifiedNetwork_ByteBuf
function ArenaTeamInBound:ReadBuffer(buffer)
    --- @type number
    self.containData = buffer:GetBool()
    if self.containData == true then
        --- @type number
        self.eloPoint = buffer:GetInt()
        --- @type number
        self.turnBoughtDaily = buffer:GetByte()
        --- @type number
        self.regenTime = buffer:GetLong()
    end
    self.lastRequest = zg.timeMgr:GetServerTime()
    self:InitRegenTime()
end

--- @return boolean
function ArenaTeamInBound:NeedRequest()
    return self.lastRequest == nil or zg.timeMgr:GetServerTime() - self.lastRequest > 30
end

function ArenaTeamInBound:GetArenaRanking(callback)
    if self.lastTimeGetRanking == nil
            or zg.timeMgr:GetServerTime() - self.lastTimeGetRanking > TimeUtils.SecondAMin then
        local onReceived = function(result)
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                self.currentRanking = nil
                self.rankType = nil

                self.rankingDataList = NetworkUtils.GetListDataInBound(buffer, SingleArenaTeamRanking)
                if self.rankingDataList:Count() > 0 then
                    local serverPlayerRanking = buffer:GetInt()
                    self.rankType = buffer:GetByte()

                    --- @param v SingleArenaTeamRanking
                    for k, v in pairs(self.rankingDataList:GetItems()) do
                        if v.playerId == PlayerSettingData.playerId then
                            self.currentRanking = k
                            break
                        end
                    end
                    if self.currentRanking == nil then
                        self.currentRanking = math.max(1, serverPlayerRanking + 1)
                    end
                end
                self.lastTimeGetRanking = zg.timeMgr:GetServerTime()
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, callback)
        end
        NetworkUtils.Request(OpCode.ARENA_TEAM_RANKING_GET, nil, onReceived)
    else
        if callback then
            callback()
        end
    end
end

function ArenaTeamInBound.Validate(callback, forceUpdate)
    --- @type ArenaDataInBound
    local arenaDataInBound = zg.playerData:GetMethod(PlayerDataMethod.ARENA_TEAM)
    if arenaDataInBound == nil
            or forceUpdate == true
            or arenaDataInBound:NeedRequest() then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.ARENA_TEAM }, callback)
    else
        if callback then
            callback()
        end
    end
end
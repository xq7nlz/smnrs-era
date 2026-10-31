require "lua.client.core.network.playerData.common.RankingItemInBound"

--- @class RankingDataInBound
RankingDataInBound = Class(RankingDataInBound)

RankingDataInBound.DELAY_REQUEST = 300

--- @param rankingType PlayerDataMethod
function RankingDataInBound:Ctor(rankingType)
    --- @type PlayerDataMethod
    self.rankType = rankingType
end

--- @param buffer UnifiedNetwork_ByteBuf
function RankingDataInBound:ReadBuffer(buffer)
    --- @type List -- RankingItemInBound
    self.rankingDataList = self:GetPlayerRankingItemList(buffer)
    if self.rankingDataList:Count() > 0 then
        --- @type string
        self.userRankingOrder = buffer:GetInt()
    end

    --- @type number
    self.requestTime = zg.timeMgr:GetServerTime()
    --- @type number
    self.lastUserSortScore = self:GetUserScore()
end

--- @return List
--- @param buffer UnifiedNetwork_ByteBuf
function RankingDataInBound:GetPlayerRankingItemList(buffer)
    ---@type number
    local size = buffer:GetByte()
    ---@type List
    local listItem = List()
    for _ = 1, size do
        --- @type RankingItemInBound
        local temp = RankingItemInBound.CreateByBuffer(buffer)
        listItem:Add(temp)
    end
    return listItem
end

--- @return number
function RankingDataInBound:GetUserScore()
    return nil
end

--- @return number
function RankingDataInBound:TimeCreated()
    -- OVERRIDE
end

--- @return number
function RankingDataInBound:IsAvailableToRequest()
    return self:IsScoreChange() == true
            or self.requestTime == nil
            or self.requestTime < zg.timeMgr:GetServerTime() - RankingDataInBound.DELAY_REQUEST
end

--- @return RankingItemInBound
function RankingDataInBound:GetUserRankingItemInBound()
    local userRankingItemInBound = RankingItemInBound()
    userRankingItemInBound.id = PlayerSettingData.playerId
    userRankingItemInBound.serverId = PlayerSettingData.serverId
    userRankingItemInBound.name = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).name
    userRankingItemInBound.score = self:GetUserScore()
    userRankingItemInBound.createdTime = self:TimeCreated()
    userRankingItemInBound.avatar = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).avatar
    userRankingItemInBound.level = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level
    return userRankingItemInBound
end

--- @param newUserScore number
--- @param createdTime number
function RankingDataInBound:UpdateUserRankingInBound(newUserScore, createdTime)
    if self.userRankingOrder >= 0 and self.userRankingOrder <= self.rankingDataList:Count() - 1 then
        self.rankingDataList:RemoveByIndex(self.userRankingOrder)
    end
    if newUserScore <= self.rankingDataList:Get(1).score
            and newUserScore >= self.rankingDataList:Get(self.rankingDataList:Count()) then
        for i = 1, self.rankingDataList:Count() do
            if self.rankingDataList:Get(i).score <= newUserScore then
                --- @type RankingItemInBound
                local userRankingItem = self.rankingDataList:Get(i)
                --userRankingItem.serverId
                userRankingItem.name = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).name
                userRankingItem.avatar = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).avatar
                userRankingItem.level = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level
                userRankingItem.score = newUserScore
                userRankingItem.createdTime = createdTime
                self.rankingDataList:Insert(userRankingItem, i)
                self.userRankingOrder = i - 1
                break
            end
        end
    end
    self.lastUserSortScore = newUserScore
end

--- @return void
function RankingDataInBound.ReloadDataRanking(playerDataMethod, callbackSuccess, callbackFailed)
    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
        if callbackFailed ~= nil then
            callbackFailed()
        end
    end
    PlayerDataRequest.RequestAndCallback({ playerDataMethod }, callbackSuccess, onFailed)
end

--- @return void
function RankingDataInBound:CheckForReloadData(callbackSuccess)
    if self:IsAvailableToRequest() then
        RankingDataInBound.ReloadDataRanking(self.rankType, function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
        end)
    else
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
end

function RankingDataInBound:IsScoreChange()
    return self:GetUserScore() ~= self.lastUserSortScore
end

--- @param newName string
function RankingDataInBound:UpdateInfoByKey(key, newName)
    for i = 1, self.rankingDataList:Count() do
        --- @type RankingItemInBound
        local rankingItemInBound = self.rankingDataList:Get(i)
        if rankingItemInBound.id == PlayerSettingData.playerId then
            rankingItemInBound:UpdateInfoByKey(key, newName)
            break
        end
    end
end

return RankingDataInBound


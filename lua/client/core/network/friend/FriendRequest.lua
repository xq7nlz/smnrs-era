--- @class FriendRequest
FriendRequest = Class(FriendRequest)

--- @return void
function FriendRequest.RequestAddFriend(friendId, callbackSuccess, callbackFailed)
    local callback = function(result)
        local id
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            id = buffer:GetLong()
        end
        local onSuccess = function()
            -- REQUEST HERO_LINKING
            ---@type HeroLinkingInBound
            local heroLinkingInBound = zg.playerData:GetMethod(PlayerDataMethod.HERO_LINKING)
            if heroLinkingInBound ~= nil then
                heroLinkingInBound.needUpdateLinking = true
            end
            
            RxMgr.friendAddSuccess:Next(id)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("send_success"))
            --zg.playerData:GetMethod(PlayerDataMethod.FRIEND).needRequest = true --hoangpl fix
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
        end
        local onFailed = function(logicCode)
            --XDebug.Log("Add Friend Failed")
            if logicCode == LogicCode.FRIEND_REQUEST_ALREADY_EXISTED then
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
            else
                if callbackFailed ~= nil then
                    callbackFailed(logicCode)
                end
            end
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FRIEND_REQUEST_ADD, UnknownOutBound.CreateInstance(PutMethod.Long, friendId), callback)
end

--- @return void
function FriendRequest.RequestFriendBoss(friendId, callbackSuccess, callbackFailed)
    local callback = function(result)
        ---@type FriendBoss
        local friendBoss
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            friendBoss = FriendBoss.CreateByBuffer(buffer)
        end
        local onSuccess = function()
            --XDebug.Log("FRIEND_BOSS_DETAIL_GET success")
            if callbackSuccess ~= nil then
                callbackSuccess(friendBoss)
            end
        end
        local onFailed = function(logicCode)
            --XDebug.Log("FRIEND_BOSS_DETAIL_GET Failed")
            if callbackFailed ~= nil then
                callbackFailed(logicCode)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FRIEND_BOSS_DETAIL_GET, UnknownOutBound.CreateInstance(PutMethod.Long, friendId), callback)
end


--- @return void
function FriendRequest.RequestBossStatistic(friendId, callbackSuccess, callbackFailed)
    local callback = function(result)
        ---@type BossStatisticsInBound
        local bossStatisticsInBound
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            bossStatisticsInBound = BossStatisticsInBound(buffer)
        end
        local onSuccess = function()
            --XDebug.Log("FRIEND_BOSS_STATISTICS_GET success")
            if callbackSuccess ~= nil then
                callbackSuccess(bossStatisticsInBound)
            end
        end
        local onFailed = function(logicCode)
            --XDebug.Log("FRIEND_BOSS_STATISTICS_GET Failed")
            if callbackFailed ~= nil then
                callbackFailed(logicCode)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.FRIEND_BOSS_STATISTICS_GET, UnknownOutBound.CreateInstance(PutMethod.Long, friendId), callback)
end

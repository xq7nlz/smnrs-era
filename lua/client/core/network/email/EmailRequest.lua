--- @class EmailRequest
EmailRequest = Class(EmailRequest)

--- @param opCode OpCode
--- @param questId number
--- @param onSuccessWithReward function
--- @param onFailed function
function EmailRequest.RequestClaimQuest(opCode, questId, onSuccessWithReward, onFailed)
    local onReceived = function(result)
        local rewardList
        local tempQuestId
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            tempQuestId = buffer:GetInt()
            rewardList = NetworkUtils.GetRewardInBoundList(buffer)
        end
        local onSuccess = function()
            if rewardList ~= nil then
                if onSuccessWithReward ~= nil then
                    onSuccessWithReward(rewardList)
                end
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(opCode, UnknownOutBound.CreateInstance(PutMethod.Int, questId), onReceived)
end

--- @param callbackSuccess function
--- @param callbackFailed function
function EmailRequest.RequestEmailStatus(callbackSuccess, callbackFailed)
    local onBufferReading = function(buffer)
        zg.playerData:GetEmailStatusInBound():ReadBuffer(buffer)
    end
    NetworkUtils.RequestAndCallback(OpCode.PLAYER_EMAIL_STATUS_GET, nil, callbackSuccess, callbackFailed, onBufferReading)
end

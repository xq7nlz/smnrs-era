--- @class ClaimPassOutBound : OutBound
ClaimPassOutBound = Class(ClaimPassOutBound, OutBound)

--- @param passId number
--- @param isBasicLine boolean
--- @param listMilestone List
function ClaimPassOutBound:Ctor(passId, isBasicLine, listMilestone)
    self.passId = passId
    self.isBasicLine = isBasicLine
    self.listMilestone = listMilestone
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ClaimPassOutBound:Serialize(buffer)
    if self.passId ~= nil then
        buffer:PutInt(self.passId)
    end
    buffer:PutBool(self.isBasicLine)
    local size = self.listMilestone:Count()
    buffer:PutByte(size)
    for i = 1, size do
        buffer:PutInt(self.listMilestone:Get(i))
    end
end

--- @param opCode OpCode
--- @param passId number
--- @param isBasicLine boolean
--- @param listMilestone List
--- @param onSuccess function
--- @param onFailedCallback function
function ClaimPassOutBound.RequestClaimPass(opCode, passId, isBasicLine, listMilestone, onSuccess, onFailedCallback)
    if listMilestone:Count() == 0 then
        return
    end
    --- @type ClaimPassOutBound
    local claimPassOutBound = ClaimPassOutBound(passId, isBasicLine, listMilestone)
    local onReceived = function(result)
        local rewardList
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            --- @type List
            rewardList = NetworkUtils.GetRewardInBoundList(buffer)
        end
        local onRequestSuccess = function()
            PopupUtils.ClaimAndShowRewardList(rewardList)
            if onSuccess ~= nil then
                onSuccess()
            end
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if onFailedCallback then
                onFailedCallback(logicCode)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onRequestSuccess, onFailed)
    end
    NetworkUtils.Request(opCode, claimPassOutBound, onReceived)
end
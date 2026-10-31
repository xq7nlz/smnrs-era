--- @class CouponRequest
CouponRequest = Class(CouponRequest)
--- @return void
function CouponRequest.SendCode(giftCode)
    local onReceived = function(result)
        local rewardList
        local giftCodeResultCode
        local onSuccess = function()
            if giftCodeResultCode == LogicCode.SUCCESS then
                PopupUtils.ClaimAndShowRewardList(rewardList)
            else
                SmartPoolUtils.GiftCodeResultNotification(giftCodeResultCode)
            end
        end

        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            giftCodeResultCode = buffer:GetShort()
            if giftCodeResultCode == LogicCode.SUCCESS then
                rewardList = NetworkUtils.GetRewardInBoundList(buffer)
            end
        end

        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.GIFT_CODE_CLAIM, UnknownOutBound.CreateInstance(PutMethod.String, giftCode), onReceived)
end
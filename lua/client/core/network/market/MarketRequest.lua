--- @class MarketRequest
MarketRequest = Class(MarketRequest)

MarketRequest.callback = nil

--- @return void
--- @param opCode OpCode
--- @param marketItemId number
--- @param callback function
function MarketRequest.BuyItem(opCode, marketItemId, callback)
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            local id = buffer:GetByte()
            RxMgr.buyCompleted:Next(true)
        end

        local onSuccess = function()
            --XDebug.Log("Buy Item successful")
            if callback ~= nil then
                callback()
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(opCode, UnknownOutBound.CreateInstance(PutMethod.Byte, marketItemId), onReceived)
end
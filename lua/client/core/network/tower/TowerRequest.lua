require "lua.client.core.network.temple.TempleSummonResultInBound"

--- @class TowerRequest
TowerRequest = Class(TowerRequest)

--- @return void
--- @param callback function
function TowerRequest.BuyItem(numberStamina, callback)
    --TouchUtils.Disable()
    local onReceived = function(result)

        local onSuccess = function()
            XDebug.Log("Buy Stamina successful")
            if callback ~= nil then
                callback()
            end
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.TOWER_STAMINA_BUY, UnknownOutBound.CreateInstance(PutMethod.Byte, numberStamina), onReceived)
end

function TowerRequest.RecordLevel(towerLevel, callback)
    local onReceived = function(result)
        local record
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            require "lua.client.core.network.towerRecord.TowerRecordInBound"
            record = TowerRecordInBound(buffer, towerLevel)
        end
        local onSuccess = function()
            callback(record)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.RECORD_TOWER_DETAIL_GET, UnknownOutBound.CreateInstance(PutMethod.Short, towerLevel), onReceived)
end
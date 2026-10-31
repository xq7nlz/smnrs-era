require "lua.client.core.network.temple.TempleSummonResultInBound"

--- @class TempleRequest
TempleRequest = Class(TempleRequest)

--- @return void
--- @param factionType HeroFactionType
--- @param numberSummon number
--- @param callback function
function TempleRequest.Summon(factionType, numberSummon, callback, isUseGem)
    --XDebug.Log("Summon: " .. numberSummon)
    --TouchUtils.Disable()
    local onReceived = function(result)
        local templeSummonResult
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            templeSummonResult = TempleSummonResultInBound(buffer)
        end

        local onSuccess = function()
            --XDebug.Log("Temple Summon hero success")
            if callback then
                callback(templeSummonResult)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.PROPHET_TREE_SUMMON,
            UnknownOutBound.CreateInstance(PutMethod.Byte, factionType, PutMethod.Byte, numberSummon, PutMethod.Bool, isUseGem), onReceived)
end

--- @return void
--- @param heroInventoryId number
--- @param callback function
function TempleRequest.Replace(heroInventoryId, callback)
    --XDebug.Log(string.format("inventoryId: %d", heroInventoryId))
    --TouchUtils.Disable()
    local onReceived = function(result)
        local beforeConvert
        local afterConvert
        local inventoryId
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            beforeConvert = buffer:GetInt()
            afterConvert = buffer:GetInt()
            inventoryId = buffer:GetLong()
        end

        local onSuccess = function()
            callback(beforeConvert, afterConvert, inventoryId)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.PROPHET_TREE_CONVERT, UnknownOutBound.CreateInstance( PutMethod.Long, heroInventoryId), onReceived)
end

--- @return void
--- @param heroInventoryId number
--- @param isSave boolean
function TempleRequest.SaveReplace(heroInventoryId, isSave, callback)
    NetworkUtils.RequestAndCallback(OpCode.PROPHET_TREE_SAVE_CONVERTED,
            UnknownOutBound.CreateInstance( PutMethod.Long, heroInventoryId, PutMethod.Bool, isSave), callback)
end
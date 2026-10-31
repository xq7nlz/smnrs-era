--- @class IdleEffectInventory
IdleEffectInventory = Class(IdleEffectInventory)

function IdleEffectInventory:Ctor()
    --- @type number
    self.lastTimeRequest = nil
    self.listIdleEffect = List()
    self.allIdleEffectDict = Dictionary() -- tat ca idle effect
end

function IdleEffectInventory:Validate(callback, forceUpdate)
    if self.lastTimeRequest == nil or forceUpdate == true then
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
                local size = buffer:GetByte()
                self.allIdleEffectDict:Clear()
                for i = 1, size do
                    self.allIdleEffectDict:Add(buffer:GetInt(), buffer:GetInt())
                end
        end
        local onSuccess = function()
            self.lastTimeRequest = zg.timeMgr:GetServerTime()
            if callback then
                callback(self.allIdleEffectDict)
            end
        end
        NetworkUtils.RequestAndCallback(OpCode.HERO_IDLE_EFFECT_COLLECTION_GET,
                nil, onSuccess, nil, onBufferReading)
    else
        if callback then
            callback(self.allIdleEffectDict)
        end
    end
end
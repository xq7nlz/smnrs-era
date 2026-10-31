--- @class SkinInventory
SkinInventory = Class(SkinInventory)

function SkinInventory:Ctor()
    --- @type number
    self.lastTimeRequest = nil

    self.listSkin = List()

    self.skinDict = Dictionary()
end

function SkinInventory:Validate(callback, forceUpdate)
    if self.lastTimeRequest == nil or forceUpdate == true then
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            local size = buffer:GetByte()
            self.skinDict:Clear()
            for i = 1, size do
                self.skinDict:Add(buffer:GetInt(), buffer:GetInt())
            end
        end
        local onSuccess = function()
            self.lastTimeRequest = zg.timeMgr:GetServerTime()

            if callback then
                callback(self.skinDict)
            end
        end
        NetworkUtils.RequestAndCallback(OpCode.HERO_SKIN_COLLECTION_GET, nil, onSuccess, nil, onBufferReading)
    else
        if callback then
            callback(self.skinDict)
        end
    end
end
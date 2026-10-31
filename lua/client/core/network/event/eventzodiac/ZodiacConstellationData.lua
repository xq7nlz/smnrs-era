--- @class ZodiacConstellationData
ZodiacConstellationData = Class(ZodiacConstellationData)

function ZodiacConstellationData:Ctor()
    self.currentMap = 0
    self.freeMapping = 0
    self.currentPosition = 0
end

--- @param buffer UnifiedNetwork_ByteBuf
function ZodiacConstellationData:ReadBuffer(buffer)
    self.currentPosition = buffer:GetInt()
    self.currentMap = buffer:GetInt() + 1
    self.freeMapping =  buffer:GetInt()
end


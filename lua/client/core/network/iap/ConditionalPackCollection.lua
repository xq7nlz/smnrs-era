--- @class ConditionalPackCollection
ConditionalPackCollection = Class(ConditionalPackCollection)

--- @param opCode OpCode
function ConditionalPackCollection:Ctor(opCode)
    --- @type OpCode
    self.opCode = opCode
    --- @type Dictionary
    self.boughtPackDict = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function ConditionalPackCollection:ReadBuffer(buffer)
    self.isActive = buffer:GetBool()
    if self.isActive == true then
        self.activeGroupId = buffer:GetInt()
        self.createdTime = buffer:GetLong() - TimeUtils.SecondAMin * 10
    end
    self.boughtPackDict = Dictionary()
    local bought = buffer:GetByte()
    for _ = 1, bought do
        local packId = buffer:GetInt()
        local boughtCount = buffer:GetInt()
        self.boughtPackDict:Add(packId, boughtCount)
    end
end

--- @return number
--- @param packId number
function ConditionalPackCollection:GetBoughtCount(packId)
    if self.boughtPackDict:IsContainKey(packId) then
        return self.boughtPackDict:Get(packId)
    end
    return 0
end

--- @param packId number
function ConditionalPackCollection:IncreaseBoughtPack(packId)
    local bought = self:GetBoughtCount(packId)
    self.boughtPackDict:Add(packId, bought + 1)
end
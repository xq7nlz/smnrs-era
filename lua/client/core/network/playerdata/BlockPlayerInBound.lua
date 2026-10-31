--- @class BlockPlayerInBound
BlockPlayerInBound = Class(BlockPlayerInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function BlockPlayerInBound:ReadBuffer(buffer)
    local size = buffer:GetByte()
    ---@type List
    self.listBlock = List()
    for i = 1, size do
        self.listBlock:Add(buffer:GetLong())
    end
    --XDebug.Log("BlockPlayerDetailInBound" .. LogUtils.ToDetail(self.listBlock:GetItems()))
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function BlockPlayerInBound:Serialize(buffer)
    buffer:PutByte(self.listBlock:Count())
    for _, playerId in pairs(self.listBlock:GetItems()) do
        buffer:PutLong(playerId)
    end
    buffer:PutByte(GameMode.ARENA)
end

--- @return void
--- @param playerId string
function BlockPlayerInBound:Remove(playerId)
    ---@param v number
    for _, v in ipairs(self.listBlock:GetItems()) do
        if v == playerId then
            self.listBlock:RemoveByReference(v)
            local blockPlayerDetailInBound = zg.playerData:GetBlockPlayerDetailInBound()
            if blockPlayerDetailInBound:IsAvailableToRequest() == false then
                blockPlayerDetailInBound:Remove(playerId)
            end
            break
        end
    end
end

--- @return void
--- @param playerId string
function BlockPlayerInBound:Add(playerId)
    self.listBlock:Add(playerId)
    zg.playerData:GetBlockPlayerDetailInBound().needRequest = true
end

--- @return boolean
--- @param playerId string
function BlockPlayerInBound:IsBlock(playerId)
    return self.listBlock:IsContainValue(playerId)
end

--- @return void
function BlockPlayerInBound:ToString()
    return LogUtils.ToDetail(self.listBlock:GetItems())
end
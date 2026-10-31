--- @class BlockPlayerDetailInBound
BlockPlayerDetailInBound = Class(BlockPlayerDetailInBound)

function BlockPlayerDetailInBound:Ctor()
    --- @type List
    self.listIdBlock = nil
    --- @type boolean
    self.needRequest = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function BlockPlayerDetailInBound:ReadBuffer(buffer)
    local size = buffer:GetByte()
    ---@type List --<OtherPlayerInfoInBound>
    self.listIdBlock = List()
    for _ = 1, size do
        self.listIdBlock:Add(OtherPlayerInfoInBound.CreateByBuffer(buffer))
    end
    ---@type boolean
    self.needRequest = false
    --XDebug.Log("BlockPlayerInBound" .. self:ToString())
end

function BlockPlayerDetailInBound:IsAvailableToRequest()
    return self.needRequest ~= false or self.listIdBlock == nil
end

--- @return void
--- @param playerId string
function BlockPlayerDetailInBound:Remove(playerId)
    ---@param v OtherPlayerInfoInBound
    for i, v in ipairs(self.listIdBlock:GetItems()) do
        if v.playerId == playerId then
            self.listIdBlock:RemoveByReference(v)
            break
        end
    end
end

--- @return void
function BlockPlayerDetailInBound:ToString()
    return LogUtils.ToDetail(self.listIdBlock:GetItems())
end

return BlockPlayerDetailInBound
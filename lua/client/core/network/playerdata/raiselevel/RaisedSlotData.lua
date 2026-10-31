--- @class RaisedSlotData
RaisedSlotData = Class(RaisedSlotData)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function RaisedSlotData:Ctor(buffer)
    self.inventoryId = nil
    self.originLevel = nil
    self.state = nil
    self.updateTime = nil
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function RaisedSlotData:ReadBuffer(buffer)
    self.inventoryId = buffer:GetLong()
    self.originLevel = buffer:GetShort()
    self.state = buffer:GetByte()
    self.updateTime = buffer:GetLong() + TimeUtils.SecondADay - zg.timeMgr:GetServerTime()
end

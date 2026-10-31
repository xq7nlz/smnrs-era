--- @class EventData
EventData = Class(EventData)

--- @return void
function EventData:Ctor()
    --- @type boolean
    self.hasData = nil
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function EventData:ReadBuffer(buffer)
    self.hasData = buffer:GetBool()
    if self.hasData then
        self:FillData(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventData:FillData(buffer)
    XDebug.Error("Need override this method")
end
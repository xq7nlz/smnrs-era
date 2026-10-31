--- @class DefenderConstructionData
DefenderConstructionData = Class(DefenderConstructionData)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function DefenderConstructionData:Ctor(buffer)
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function DefenderConstructionData:ReadBuffer(buffer)
    --- @type number   -- construction
    self.level = buffer:GetByte()
    ---@type Dictionary  --<tower, level>
    self.towerLevelMap = Dictionary()
    local size = buffer:GetByte()
    if size > 0 then
        for i = 1, size do
            self.towerLevelMap:Add(buffer:GetByte(), buffer:GetByte())
        end
    end
end
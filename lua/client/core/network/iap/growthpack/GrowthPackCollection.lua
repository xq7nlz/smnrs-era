require "lua.client.core.network.iap.GrowthPack.GrowPatchLine"

--- @class GrowthPackCollection
GrowthPackCollection = Class(GrowthPackCollection)

function GrowthPackCollection:Ctor()
    --- @type Dictionary
    self.boughtPackDict = Dictionary()
    --- @type Dictionary
    self.lineDict = Dictionary()
end

--- @param buffer UnifiedNetwork_ByteBuf
function GrowthPackCollection:ReadBuffer(buffer)
    local bought = buffer:GetByte()
    self.boughtPackDict = Dictionary()
    for _ = 1, bought do
        local packId = buffer:GetInt()
        local boughtCount = buffer:GetInt()
        self.boughtPackDict:Add(packId, boughtCount)
    end
    local numberLine = buffer:GetShort()
    self.lineDict = Dictionary()
    for _ = 1, numberLine do
        local id = buffer:GetInt()
        local line = GrowPatchLine()
        line:ReadBuffer(buffer)
        self.lineDict:Add(id, line)
    end
end

--- @return number
--- @param packId number
function GrowthPackCollection:GetBoughtCount(packId)
    if self.boughtPackDict:IsContainKey(packId) then
        return self.boughtPackDict:Get(packId)
    end
    return 0
end

--- @param packId number
function GrowthPackCollection:IncreaseBoughtPack(packId)
    local bought = self:GetBoughtCount(packId)
    self.boughtPackDict:Add(packId, bought + 1)
end

--- @param line number
--- @param isBasic boolean
--- @param listMilestone List
function GrowthPackCollection:OnSuccessClaimListMilestone(line, isBasic, listMilestone)
    --- @type GrowPatchLine
    local growPatchLine = self:GetGrowPatchLine(line)
    if growPatchLine == nil then
        growPatchLine = GrowPatchLine()
        self.lineDict:Add(line, growPatchLine)
    end
    for i = 1, listMilestone:Count() do
        local milestone = listMilestone:Get(i)
        growPatchLine:OnSuccessClaimMilestone(isBasic, milestone)
    end
end

--- @return GrowPatchLine
--- @param line number
function GrowthPackCollection:GetGrowPatchLine(line)
    if self.lineDict ~= nil then
        return self.lineDict:Get(line)
    end
    return nil
end
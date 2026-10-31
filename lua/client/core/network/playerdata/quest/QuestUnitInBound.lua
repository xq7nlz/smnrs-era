--- @class QuestUnitInBound
QuestUnitInBound = Class(QuestUnitInBound)

function QuestUnitInBound:Ctor()
    --- @type number
    self.questId = nil
    --- @type number
    self.number = nil
    --- @type number
    self.groupId = nil
    --- @type number
    self.orderInGroup = nil
    --- @type QuestState
    self.questState = nil
    --- @type QuestElementConfig
    self.config = nil
    --- @type number
    self.fixedTarget = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function QuestUnitInBound:ReadBuffer(buffer)
    self.questId = buffer:GetInt()
    self.questState = buffer:GetByte()
end

--- @return number
---@param x QuestUnitInBound
---@param y QuestUnitInBound
function QuestUnitInBound.SortById(x, y)
    if (x.questId > y.questId) then
        return 1
    else
        return -1
    end
end

--- @return number
---@param x QuestUnitInBound
---@param y QuestUnitInBound
function QuestUnitInBound.SortByRequirementTarget(x, y)
    if (x.config:GetMainRequirementTarget() < y.config:GetMainRequirementTarget()) then
        return -1
    else
        return 1
    end
end
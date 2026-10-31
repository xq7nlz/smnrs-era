--- @class RegenTimeData
RegenTimeData = Class(RegenTimeData)

--- @return void
---@param step number
---@param max number
---@param getLastRegenTime number
---@param setLastRegenTime number
function RegenTimeData:Ctor(step, max, getLastRegenTime, setLastRegenTime)
    --- @type ResourceType
    self.step = step
    --- @type number
    self.max = max
    ---@type function
    self.getLastRegenTime = getLastRegenTime
    ---@type function
    self.setLastRegenTime = setLastRegenTime
end
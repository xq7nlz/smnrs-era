--- @class QuickBattleTicketData
QuickBattleTicketData = Class(QuickBattleTicketData)

function QuickBattleTicketData:Ctor()
    --- @type number
    self.id = nil
    --- @type ResourceType
    self.resourceType = nil
    --- @type number
    self.resourceId = nil
    --- @type number
    self.time = nil
end

--- @data string
function QuickBattleTicketData:ParseCsv(parsedData)
    self.id = tonumber(parsedData['id'])
    self.resourceType = tonumber(parsedData['res_type'])
    self.resourceId = tonumber(parsedData['res_id'])
    self.time = tonumber(parsedData['quick_battle_duration'])
    self.limitUse = tonumber(parsedData['limit_per'])
end

--- @data string
function QuickBattleTicketData:GetHour()
    return math.floor(self.time / 3600)
end

--- @return number
---@param x QuickBattleTicketData
---@param y QuickBattleTicketData
function QuickBattleTicketData.SortTime(x, y)
    if (x.time > y.time) then
        return 1
    else
        return -1
    end
end
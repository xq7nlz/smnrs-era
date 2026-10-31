--- @class DefenseTowerData
DefenseTowerData = Class(DefenseTowerData)

function DefenseTowerData:Ctor(parsedCsv)
    self:_ReadParsedData(parsedCsv)
end

function DefenseTowerData:_ReadParsedData(parsedCsv)
    self.id = tonumber(parsedCsv.id)
    self._heroSlotDict = Dictionary()
    for i = 1, 5 do
        local key = "hero_" .. i
        local heroId = tonumber(parsedCsv[key])
        self._heroSlotDict:Add(i, heroId)
    end
end

--- @return Dictionary
function DefenseTowerData:GetHeroSlotDict()
    return self._heroSlotDict
end

--- @return number
function DefenseTowerData:GetHeroIdBySlot(slotId)
    return self._heroSlotDict:Get(slotId)
end
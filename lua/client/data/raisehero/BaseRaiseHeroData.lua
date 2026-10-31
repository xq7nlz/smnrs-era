--- @class BaseRaiseHeroData
BaseRaiseHeroData = Class(BaseRaiseHeroData)

function BaseRaiseHeroData:Ctor(data)
    self.defaultSlotNumber = tonumber(data["default_slot_number"])
    self.maxSlot = tonumber(data["max_slot_number"])
    self.pentaGramSlot = tonumber(data["pentagram_slot"])
end
---@type number
function BaseRaiseHeroData:GetMaxSlot()
    return self.maxSlot
end
---@type number
function BaseRaiseHeroData:GetPentaSlot()
    return self.pentaGramSlot
end
return BaseRaiseHeroData
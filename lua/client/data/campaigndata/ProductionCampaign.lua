--- @class ProductionCampaign
ProductionCampaign = Class(ProductionCampaign)

--- @return void
---@param resourceType ResourceType
---@param id number
---@param number number
---@param time number
function ProductionCampaign:Ctor(resourceType, id, number, time)
    ---@type ResourceType
    self.resourceType = resourceType
    ---@type number
    self.id = id
    ---@type number
    self.number = number
    ---@type number
    self.time = time
end
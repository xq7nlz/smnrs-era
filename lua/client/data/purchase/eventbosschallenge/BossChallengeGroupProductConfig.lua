--- @class BossChallengeGroupProductConfig
BossChallengeGroupProductConfig = Class(BossChallengeGroupProductConfig)

function BossChallengeGroupProductConfig:Ctor(data)
    self.groupId = tonumber(data.group)
    --- @type List | ProductConfig
    self.listProductConfig = List()
end

--- @param productConfig ProductConfig
function BossChallengeGroupProductConfig:AddProductConfig(productConfig)
    self.listProductConfig:Add(productConfig)
end

--- @return List
function BossChallengeGroupProductConfig:GetListProductConfig()
    return self.listProductConfig
end

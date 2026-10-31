require "lua.client.data.Fragment.ArtifactFragmentRate"

--- @class ArtifactFragmentConfig
ArtifactFragmentConfig = Class(ArtifactFragmentConfig)

--- @return void
function ArtifactFragmentConfig:Ctor()
    ---id,name,rarity,price,artifact_1,rate_1,artifact_2,rate_2,artifact_3,rate_3,artifact_4,rate_4,artifact_5,rate_5
    ------ @type number
    self.id = -1
    --- @type string
    self.name = -1
    --- @type number
    self.rarity = -1
    --- @type number
    self.price = -1
end

--- @return void
--- @param data string
function ArtifactFragmentConfig:ParseCsv(data)
    self.id = tonumber(data.id)
    self.name = data.name
    self.rarity = tonumber(data.rarity)
    self.price = tonumber(data.price)
end
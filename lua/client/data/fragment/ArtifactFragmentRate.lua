--- @class ArtifactFragmentRate
ArtifactFragmentRate = Class(ArtifactFragmentRate)

--- @return void
function ArtifactFragmentRate:Ctor()
    --- @type number
    self.rate = nil
    --- @type number
    self.id = nil
end

--- @return void
--- @param data string
--- @param i number
function ArtifactFragmentRate:ParseCsv(data, i)
    self.rate = tonumber(data["rate_" .. i])
    self.id = tonumber(data["artifact_" .. i])
end
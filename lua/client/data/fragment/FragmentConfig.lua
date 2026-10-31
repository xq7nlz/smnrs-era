require "lua.client.data.Fragment.HeroFragmentNumberConfig"
require "lua.client.data.Fragment.ArtifactFragmentConfig"
require "lua.client.data.Fragment.HeroFragmentGroupRate"

--- @class FragmentConfig
FragmentConfig = Class(FragmentConfig)

--- @return void
function FragmentConfig:Ctor()
    --- @type Dictionary --<star, HeroFragmentNumberConfig>
    self.heroFragmentNumberDictionary = self:GetHeroFragmentNumberDictionary()
    --- @type Dictionary --<id, ArtifactFragmentConfig>
    self.artifactFragmentDictionary = self:GetArtifactFragmentDictionary()
end


--- @return Dictionary<key, value>
function FragmentConfig:GetHeroFragmentNumberDictionary()
    local dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.HERO_FRAGMENT_NUMBER_PATH)
    for i = 1, #parsedData do
        --- @type HeroFragmentNumberConfig
        local data = HeroFragmentNumberConfig()
        data:ParseCsv(parsedData[i])
        dict:Add(data.star, data)
    end
    return dict
end

--- @return Dictionary<key, value>
function FragmentConfig:GetArtifactFragmentDictionary()
    local dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.ARTIFACT_FRAGMENT_PATH)
    for i = 1, #parsedData do
        --- @type ArtifactFragmentConfig
        local data = ArtifactFragmentConfig()
        data:ParseCsv(parsedData[i])
        dict:Add(data.id, data)
    end
    return dict
end

return FragmentConfig
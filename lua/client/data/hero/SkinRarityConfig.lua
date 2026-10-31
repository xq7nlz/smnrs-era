--- @class SkinRarityConfig
SkinRarityConfig = Class(SkinRarityConfig)
local SKIN_RARITY_CONFIG_PATH = "csv/client/skin_rarity_config.csv"

function SkinRarityConfig:Ctor()
    self:_ReadCsv()
end

function SkinRarityConfig:_ReadCsv()
    --- @type Dictionary
    self.skinConfigDict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(SKIN_RARITY_CONFIG_PATH)
    for i = 1, #parsedData do
        local skinId = tonumber(parsedData[i].skin_id)
        local rarity = tonumber(parsedData[i].rarity)
        self.skinConfigDict:Add(skinId, rarity)
    end
end

--- @return SkinRarity
--- @param skinId number
function SkinRarityConfig:GetSkinRarity(skinId)
    if self.skinConfigDict:IsContainKey(skinId) then
        return self.skinConfigDict:Get(skinId)
    end
    return SkinRarity.DEFAULT
end

return SkinRarityConfig
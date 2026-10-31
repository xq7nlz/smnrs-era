local ITEM_CHEST_ARTIFACT_PATH = "csv/item/artifact_chest/artifact_chest_select.csv"

--- @class ArtifactChestRewardConfig
ArtifactChestRewardConfig = Class(ArtifactChestRewardConfig)

--- @return void
function ArtifactChestRewardConfig:Ctor()
    ---@type Dictionary
    self.listArenaChestRewardConfig = Dictionary()
    self:ReadChestArtifactRewardConfig()
end

function ArtifactChestRewardConfig:ReadChestArtifactRewardConfig()
    ---@type List
    self.listChestArtifactRewardConfig = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(ITEM_CHEST_ARTIFACT_PATH)
    if parsedData == nil then
        XDebug.Error(string.format("Chest reward config missing: ", ITEM_CHEST_ARTIFACT_PATH ))
        return
    end
    local lastChestId= nil
    for i = 1, #parsedData do
        if parsedData[i]["chest_id"] ~= nil then
            lastChestId = tonumber(parsedData[i]["chest_id"])
            self.listChestArtifactRewardConfig:Add(lastChestId, List())
            self.listChestArtifactRewardConfig:Get(lastChestId):Add(
                    RewardInBound.CreateByParamsArenaChest(parsedData[i]):GetSelectionIconData())
        else
            self.listChestArtifactRewardConfig:Get(lastChestId):Add(
                    RewardInBound.CreateByParamsArenaChest(parsedData[i]):GetSelectionIconData())
        end
    end
end

function ArtifactChestRewardConfig:GetChestArtifactRewardConfig(chestId)
    return self.listChestArtifactRewardConfig:Get(chestId)
end

return ArtifactChestRewardConfig
--- @class LandUnlockConfig
LandUnlockConfig = Class(LandUnlockConfig)

function LandUnlockConfig:Ctor(parsedData)
    ---@type number
    self.id = tonumber(parsedData.id)
    ---@type number
    self.level = tonumber(parsedData.level)
    ---@type number
    self.stage = tonumber(parsedData.stage)
    ---@type number
    self.restrictType = tonumber(parsedData.restrict_type)
    ---@type FeatureState
    self.unlockState = tonumber(parsedData.unlock_state)
end

--- @return boolean
function LandUnlockConfig:IsUnlocked(currentLevel, currentCampaignStage)
    if self.unlockState == FeatureState.UNLOCK then
        return currentLevel >= self.level and currentCampaignStage >= self.stage
    end
    return false
end

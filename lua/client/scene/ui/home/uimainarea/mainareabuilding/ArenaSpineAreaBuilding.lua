--- @class ArenaSpineAreaBuilding : SpineAreaBuilding
ArenaSpineAreaBuilding = Class(ArenaSpineAreaBuilding, SpineAreaBuilding)

function ArenaSpineAreaBuilding:SetTagBuildingFeatureIcon(featureState, featureType)
    if self.tagBuilding then
        self.tagBuilding:SetFeatureIcon(featureType)
    end
end
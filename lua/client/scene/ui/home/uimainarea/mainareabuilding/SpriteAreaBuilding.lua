--- @class SpriteAreaBuilding : MainAreaBuilding
SpriteAreaBuilding = Class(SpriteAreaBuilding, MainAreaBuilding)

--- @param transform UnityEngine_Transform
--- @param featureType FeatureType
function SpriteAreaBuilding:Ctor(transform, featureType)
    MainAreaBuilding.Ctor(self, transform)
end

function SpriteAreaBuilding:_InitConfig(transform)
    ---@type SpriteAreaBuildingConfig
    self.config = UIBaseConfig(transform)

    MainAreaBuilding._InitConfig(self, transform)
end

function SpriteAreaBuilding:OnPointerDown()
    MainAreaBuilding.OnPointerDown(self)
    self.config.highlight:SetActive(true)
end

function SpriteAreaBuilding:OnPointerUp()
    MainAreaBuilding.OnPointerUp(self)
    self.config.highlight:SetActive(false)
end


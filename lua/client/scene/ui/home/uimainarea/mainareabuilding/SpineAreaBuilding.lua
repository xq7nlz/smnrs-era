--- @class SpineAreaBuilding : MainAreaBuilding
SpineAreaBuilding = Class(SpineAreaBuilding, MainAreaBuilding)

--- @param transform UnityEngine_Transform
--- @param featureType FeatureType
function SpineAreaBuilding:Ctor(transform, featureType)
    --- @type UnityEngine_MaterialPropertyBlock
    self._propBlock = U_MaterialPropertyBlock()

    self._normalColor = U_Color(0, 0, 0, 1)
    self._highlightColor = MainAreaBuilding.GetHighlightColorBuilding(featureType)

    MainAreaBuilding.Ctor(self, transform)
end

function SpineAreaBuilding:_InitConfig(transform)
    ---@type SpineAreaBuildingConfig
    self.config = UIBaseConfig(transform)
    if (Main.IsNull(self.config.meshRenderer) == false) then
        --XDebug.Log("Log MeshRenderer:" .. LogUtils.ToDetail(self.config.meshRenderer.name))
        self.config.meshRenderer:GetPropertyBlock(self._propBlock)
    end
    MainAreaBuilding._InitConfig(self, transform)
end

function SpineAreaBuilding:OnPointerDown()
    MainAreaBuilding.OnPointerDown(self)
    self:SetShaderFieldColorById(self._highlightColor)
end

function SpineAreaBuilding:OnPointerUp()
    MainAreaBuilding.OnPointerUp(self)
    self:SetShaderFieldColorById(self._normalColor)
end

--- @param color UnityEngine_Color
function SpineAreaBuilding:SetShaderFieldColorById(color)
    self._propBlock:SetColor(ClientConfigUtils.FIELD_COLOR_BLACK_ID, color)
    if (Main.IsNull(self.config.meshRenderer) == false) then
        self.config.meshRenderer:SetPropertyBlock(self._propBlock)
    end
end


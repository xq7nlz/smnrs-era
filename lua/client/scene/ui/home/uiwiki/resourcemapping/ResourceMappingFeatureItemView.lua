--- @class ResourceMappingFeatureItemView : UIPrefabView
ResourceMappingFeatureItemView = Class(ResourceMappingFeatureItemView, UIPrefabView)

function ResourceMappingFeatureItemView:Ctor()
    UIPrefabView.Ctor(self)
    self.id=0
end

function ResourceMappingFeatureItemView:SetPrefabName()
    self.prefabName = 'resrouce_mapping_feature_item'
    self.uiPoolType = UIPoolType.ResourceMappingFeatureItemView
end


--- @return void
--- @param transform UnityEngine_Transform
function ResourceMappingFeatureItemView:SetConfig(transform)
    --- @type ResourceMappingFeatureItemViewConfig
    self.config = UIBaseConfig(transform)
end
--- @return void
--- @param iconData RewardInBound
function ResourceMappingFeatureItemView:SetData(feature)
    self.config.decs.text =  LanguageUtils.LocalizeFeatureContent(feature)
    self.config.featureName.text = LanguageUtils.LocalizeFeature(feature)
    self.config.textGo.text = LanguageUtils.LocalizeCommon("go")
end
---@p
function ResourceMappingFeatureItemView:AddListener(callback)
    self.config.goButton.onClick:RemoveAllListeners()
    self.config.goButton.onClick:AddListener(callback)
end


return ResourceMappingFeatureItemView
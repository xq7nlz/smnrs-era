--- @class TagLand
TagLand = Class(TagLand)

--- @param transform UnityEngine_RectTransform
function TagLand:Ctor(transform)
    --- @type TagBuildingConfig
    self.config = UIBaseConfig(transform)
end

--- @param featureType FeatureType
function TagLand:SetFeatureIcon(featureType)
    if featureType == nil then
        self.config.featureIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLands, -1)
        return
    end
        self.config.featureIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLands, featureType)
end

--- @param featureType FeatureType
function TagLand:InitLocalize(featureType)
    self.config.featureName.text = LanguageUtils.LocalizeLand(featureType)
end

--- @param tittle string
function TagLand:FixedTittle(tittle)
    self.config.featureName.text = tittle
end
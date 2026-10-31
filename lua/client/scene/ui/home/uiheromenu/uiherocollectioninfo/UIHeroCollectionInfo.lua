---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiHeroMenu.uiHeroCollectionInfo.UIHeroCollectionInfoConfig"
require "lua.client.scene.ui.common.prefabHeroInfo.PrefabHeroInfoView"

--- @class UIHeroCollectionInfo
UIHeroCollectionInfo = Class(UIHeroCollectionInfo)

--- @return void
--- @param transform UnityEngine_Transform
function UIHeroCollectionInfo:Ctor(transform, model)
    --- @type UIHeroMenuModel
    self.model = model
    ---@type UIHeroCollectionInfoConfig
    ---@type UIHeroCollectionInfoConfig
    self.config = UIBaseConfig(transform)
    ---@type PrefabHeroInfoView
    self.prefabHeroInfoView = PrefabHeroInfoView(self.config.prefabHeroInfo)
    ---@type HeroLevelCapConfig
    self.heroLevelCap = nil
end

--- @return void
function UIHeroCollectionInfo:InitLocalization()
    self.config.localizeLevelMax.text = LanguageUtils.LocalizeCommon("hero_info_max_level")
end

--- @return void
function UIHeroCollectionInfo:Show()
    self:UpdateUI()
end

--- @return void
function UIHeroCollectionInfo:Hide()
    self.prefabHeroInfoView:OnDisable()
    PopupUtils.CheckAndHideSkillPreview()
end

--- @return void
function UIHeroCollectionInfo:OnChangeHero()
    self:UpdateUI()
end

--- @return void
function UIHeroCollectionInfo:UpdateUI()
    ---@type HeroResource
    local heroResource = self.model.heroResource
    self.heroLevelCap = ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(heroResource.heroStar)
    self.config.textLevelCharacter.text = string.format("Lv.%d", tostring(self.heroLevelCap.levelCap))
    self.prefabHeroInfoView:SetData(heroResource)
end
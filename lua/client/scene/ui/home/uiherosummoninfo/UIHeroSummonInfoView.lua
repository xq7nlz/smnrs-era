require "lua.client.scene.ui.common.prefabHeroInfo.PrefabHeroInfoView"

--- @class UIHeroSummonInfoView : UIBaseView
UIHeroSummonInfoView = Class(UIHeroSummonInfoView, UIBaseView)

--- @return void
--- @param model UIHeroSummonInfoModel
function UIHeroSummonInfoView:Ctor(model)
    --- @type UIHeroSummonInfoConfig
    self.config = nil
    --- @type PrefabHeroInfoView
    self.prefabHeroInfoView = nil
    --- @type HeroIconView
    self.heroIconView = nil
    UIBaseView.Ctor(self, model)
end

--- @return void
function UIHeroSummonInfoView:OnReadyCreate()
    ---@type UIHeroSummonInfoConfig
    self.config = UIBaseConfig(self.uiTransform)

    ---@type PrefabHeroInfoView
    self.prefabHeroInfoView = PrefabHeroInfoView(self.config.prefabHeroInfo)

    self:_InitButtonListener()
end

--- @return void
--- @param result {heroResource : HeroResource, power, statDict}
function UIHeroSummonInfoView:Init(result)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)

    if result == nil then
        return
    end
    --- @type HeroResource
    self.model.heroResource = result.heroResource
    if self.model.heroResource.heroLevel == nil or self.model.heroResource.heroLevel < 1 then
        self.model.heroResource.heroLevel = 1
    end

    self.prefabHeroInfoView:SetData(self.model.heroResource, result.power, result.statDict)
    self.heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.iconSlot)
    self.heroIconView:SetIconData(HeroIconData.CreateByHeroResource(self.model.heroResource))
    self:_SetNameHeroInfo()

    self.config.textApValue.text = tostring(result.power)
end

--- @return void
function UIHeroSummonInfoView:_SetNameHeroInfo()
    self.config.textHeroName.text = LanguageUtils.LocalizeNameHero(self.model.heroResource.heroId)
end

--- @return void
function UIHeroSummonInfoView:_InitButtonListener()
    self.config.backGround.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UIHeroSummonInfoView:OnReadyShow(result)
    self:Init(result)
end

--- @return void
function UIHeroSummonInfoView:Hide()
    UIBaseView.Hide(self)
    self.heroIconView:ReturnPool()
    self.heroIconView = nil

    self.prefabHeroInfoView:OnDisable()
end
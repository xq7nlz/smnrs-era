--- @class UIPopupEnhanceRaiseLevelView : UIBaseView
UIPopupEnhanceRaiseLevelView = Class(UIPopupEnhanceRaiseLevelView, UIBaseView)

--- @return void
--- @param model UIPopupEnhanceRaiseLevelModel
function UIPopupEnhanceRaiseLevelView:Ctor(model)
    ---@type UIPopupEnhanceRaiseLevelConfig
    self.config = nil
    UIBaseView.Ctor(self, model)
    ---@type PlayerRaiseLevelInbound
    self.raiseInbound = nil
end
--- @return void
function UIPopupEnhanceRaiseLevelView:OnReadyCreate()
    ---@type UIPopupEnhanceConfig
    self.config = UIBaseConfig(self.uiTransform)
    ResourceLoadUtils.LoadUIEffect("fx_ui_evolveenhance_light", self.config.fxUiEvolveenhanceLight)

    self.config.background.onClick:AddListener(function ()
        self:OnClickBackOrClose()
    end)
end


--- @return void
function UIPopupEnhanceRaiseLevelView:InitLocalization()
    self.config.congratulationText.text = LanguageUtils.LocalizeCommon("congratulation")

end

--- @return void
function UIPopupEnhanceRaiseLevelView:OnReadyShow(result)
    self.raiseInbound = zg.playerData:GetRaiseLevelHero()
    if result ~= nil then
        self.originLevel = self.raiseInbound:GetRaisedSlot(result.index).originLevel
        self:UpdateUIHero(result)
    end
    zg.audioMgr:PlaySfxUi(SfxUiType.CLAIM)
end

--- @return void
function UIPopupEnhanceRaiseLevelView:Hide()
    UIBaseView.Hide(self)
    self.config.upEffect.gameObject:SetActive(false)
    if self.hero1 ~= nil then
        self.hero1:ReturnPool()
        self.hero1 = nil
    end
    if self.hero2 ~= nil then
        self.hero2:ReturnPool()
        self.hero2 = nil
    end
end


--- @return void
function UIPopupEnhanceRaiseLevelView:UpdateUIHero(result)
    ---@type HeroResource
    local heroResource = InventoryUtils.GetHeroResourceByInventoryId(result.inventoryId)

    local heroIconData1 = HeroIconData.CreateByHeroResource(heroResource)
    if self.hero1 == nil then
        self.hero1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.hero1)
    end
    if self.hero2 == nil then
        self.hero2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.hero2)
    end
    self.config.levelText1.text = string.format("%s %s" , LanguageUtils.LocalizeCommon("level") , self.originLevel)
    self.config.levelText2.text = string.format("%s %s" , LanguageUtils.LocalizeCommon("level") , self.raiseInbound.pentaGram:GetLowestHero())
    self.hero1:SetIconData(heroIconData1)
    self.hero2:SetIconData(heroIconData1)
    self.config.upEffect.gameObject:SetActive(false)
    self.config.upEffect.gameObject:SetActive(true)
    heroResource.heroLevel = self.raiseInbound.pentaGram:GetLowestHero()
    self.hero1.config.txtLv.gameObject:SetActive(false)
    self.hero2.config.txtLv.gameObject:SetActive(false)
end
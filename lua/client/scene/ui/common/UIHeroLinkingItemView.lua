--- @class UIHeroLinkingItemView : MotionIconView
UIHeroLinkingItemView = Class(UIHeroLinkingItemView, MotionIconView)

--- @return void
function UIHeroLinkingItemView:Ctor()
    ---@type ItemLinkingTierConfig
    self.itemLinkingTierConfig = nil
    ---@type List
    self.listBonusView = List()
    ---@type List
    self.listHeroLinking = List()
    MotionIconView.Ctor(self)
end

--- @return void
function UIHeroLinkingItemView:SetPrefabName()
    self.prefabName = 'linking_item_view_2'
    self.uiPoolType = UIPoolType.UIHeroLinkingItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIHeroLinkingItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UILinkingItemConfig2
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param itemLinkingTierConfig ItemLinkingTierConfig
--- @param linkingGroupDataInBound LinkingGroupDataInBound
function UIHeroLinkingItemView:SetData(itemLinkingTierConfig, linkingGroupDataInBound, callbackSelectHero)
    self.itemLinkingTierConfig = itemLinkingTierConfig
    self.linkingGroupDataInBound = linkingGroupDataInBound
    self.config.iconLinking.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconHeroLinking, string.format("linking_%s", self.itemLinkingTierConfig.id ))
    self.config.iconLinking:SetNativeSize()
    self.config.textLinking.text = LanguageUtils.LocalizeNameLinking(self.itemLinkingTierConfig.id)
    ---@type HeroLinkingInBound
    self.heroLinkingInBound = zg.playerData:GetMethod(PlayerDataMethod.HERO_LINKING)
    ---@type BonusLinkingTierConfig
    local bonus, _, nextBonus = self.heroLinkingInBound:GetActiveLinking(itemLinkingTierConfig.id)
    ---@param v BonusLinkingTierConfig
    for i, v in ipairs(self.itemLinkingTierConfig.listBonus:GetItems()) do
        --- @type UIHeroLinkingCardRequireItemView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIHeroLinkingCardRequireItemView, self.config.listLinking)
        local count = 0
        if self.linkingGroupDataInBound ~= nil then
            count = self.heroLinkingInBound:GetCountStarByLinkingGroupDataInBoundAndStar(self.linkingGroupDataInBound, v.star)
        end
        local isActive = bonus ~= nil and bonus.star >= v.star
        iconView:SetData(v, count, isActive, itemLinkingTierConfig.listHero:Count())
        self.listBonusView:Add(iconView)
    end
    for i, v in ipairs(self.itemLinkingTierConfig.listHero:GetItems()) do
        --- @type UIHeroLinkingItemSelectView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIHeroLinkingItemSelectView, self.config.hero)
        local isNoti = self.heroLinkingInBound:IsNotificationLinkingSlot(self.itemLinkingTierConfig.id, i, nextBonus)
        iconView:SetData(v, i, self.itemLinkingTierConfig.id, isNoti)
        iconView.callbackSelect = callbackSelectHero
        self.listHeroLinking:Add(iconView)
    end
    if bonus ~= nil then
        if self.listHeroLinking:Count() == 3 then
            self.config.iconLinkingChain.sizeDelta = U_Vector2(500, self.config.iconLinkingChain.sizeDelta.y)
        else
            self.config.iconLinkingChain.sizeDelta = U_Vector2(232, self.config.iconLinkingChain.sizeDelta.y)
        end
        self.config.iconLinkingChain.gameObject:SetActive(true)
    else
        self.config.iconLinkingChain.gameObject:SetActive(false)
    end
end

--- @return void
function UIHeroLinkingItemView:ReturnPoolItem()
    ---@param v UIHeroLinkingCardRequireItemView
    for i, v in ipairs(self.listBonusView:GetItems()) do
        v:ReturnPool()
    end
    self.listBonusView:Clear()
    ---@param v UIHeroLinkingItemSelectView
    for i, v in ipairs(self.listHeroLinking:GetItems()) do
        v:ReturnPool()
    end
    self.listHeroLinking:Clear()
end

--- @return void
function UIHeroLinkingItemView:ReturnPool()
    self:ReturnPoolItem()
    MotionIconView.ReturnPool(self)
end

--- @return void
function UIHeroLinkingItemView:OnClickSelect()
    if self.callbackSelect ~= nil then
        self.callbackSelect()
    end
end

return UIHeroLinkingItemView
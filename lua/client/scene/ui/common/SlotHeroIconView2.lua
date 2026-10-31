--- @class SlotHeroIconView2 : IconView
SlotHeroIconView2 = Class(SlotHeroIconView2, IconView)

SlotHeroIconView2.prefabName = 'slot_hero_view2'

--- @return void
function SlotHeroIconView2:Ctor(component)
    IconView.Ctor(self)
    ---@type HeroResource
    self.heroResource = nil
    ---@type HeroIconView
    self.heroIconView = nil
end

--- @return void
function SlotHeroIconView2:SetPrefabName()
    self.prefabName = 'slot_hero_view2'
    self.uiPoolType = UIPoolType.SlotHeroIconView2
end

--- @return void
--- @param transform UnityEngine_Transform
function SlotHeroIconView2:SetConfig(transform)
    assert(transform)
    --- @type SlotHeroIconConfig
    ---@type SlotHeroIconConfig
    self.config = UIBaseConfig(transform)
    self:SetTickSlot(false)
end

--- @return void
function SlotHeroIconView2:ReturnPool()
    IconView.ReturnPool(self)
    self.config.rectTransform.sizeDelta = U_Vector2.zero
    self:DeSpawnHeroIconView()
    self:SetTickSlot(false)
end

--- @return void
function SlotHeroIconView2:AddListener(func)
    self:RemoveAllListeners()
    self.config.button.onClick:AddListener(function ()
        func()
    end)
end

--- @return void
function SlotHeroIconView2:RemoveAllListeners()
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
---@param isTick boolean
function SlotHeroIconView2:SetTickSlot(isTick)
    if isTick == true then
        self.config.iconAdd:SetActive(false)
        self.config.iconTick:SetActive(true)
        UIUtils.SetInteractableButton(self.config.button, false)
    else
        self.config.iconAdd:SetActive(true)
        self.config.iconTick:SetActive(false)
        UIUtils.SetInteractableButton(self.config.button, true)
    end
end

--- @return void
---@param heroResource HeroResource
function SlotHeroIconView2:ShowHeroIconView(heroResource, showClass)
    self.heroResource = heroResource
    if self.heroIconView == nil then
        self.heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.slot_hero )
    end
    --- @type HeroIconData
    local data
    if heroResource.inventoryId ~= nil then
        data = HeroIconData.CreateByHeroResource(heroResource)
    else
        data = ItemIconData.CreateBuyHeroFood(heroResource.heroFoodType, heroResource.star)
    end
    self.heroIconView:SetIconData(data)
    if showClass == true then
        self.heroIconView:ShowClassHero()
    end
end

--- @return void
function SlotHeroIconView2:DeSpawnHeroIconView()
    if self.heroResource ~= nil then
        self.heroResource = nil
    end
    if self.heroIconView ~= nil then
        self.heroIconView:ReturnPool()
        self.heroIconView = nil
    end
end

return SlotHeroIconView2
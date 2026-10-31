--- @class SlotHeroIconView : IconView
SlotHeroIconView = Class(SlotHeroIconView, IconView)

SlotHeroIconView.prefabName = 'slot_hero_view'

--- @return void
function SlotHeroIconView:Ctor(component)
    IconView.Ctor(self)
    ---@type HeroResource
    self.heroResource = nil
    ---@type HeroIconView
    self.heroIconView = nil
end

--- @return void
function SlotHeroIconView:SetPrefabName()
    self.prefabName = 'slot_hero_view'
    self.uiPoolType = UIPoolType.SlotHeroIconView
end

--- @return void
--- @param transform UnityEngine_Transform
function SlotHeroIconView:SetConfig(transform)
    assert(transform)
    --- @type SlotHeroIconConfig
    ---@type SlotHeroIconConfig
    self.config = UIBaseConfig(transform)
    self:SetTickSlot(false)
end

--- @return void
function SlotHeroIconView:ReturnPool()
    IconView.ReturnPool(self)
    self.config.rectTransform.sizeDelta = U_Vector2.zero
    self:DeSpawnHeroIconView()
    self:SetTickSlot(false)
end

--- @return void
function SlotHeroIconView:AddListener(func)
    self:RemoveAllListeners()
    self.config.button.onClick:AddListener(function ()
        func()
    end)
end

--- @return void
function SlotHeroIconView:RemoveAllListeners()
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
---@param isTick boolean
function SlotHeroIconView:SetTickSlot(isTick)
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
function SlotHeroIconView:ShowHeroIconView(heroResource, showClass)
    self.heroResource = heroResource
    if self.heroIconView == nil then
        self.heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.slot_hero )
    end
    --- @type HeroIconData
    local data = HeroIconData.CreateByHeroResource(heroResource)
    self.heroIconView:SetIconData(data)
    if showClass == true then
        self.heroIconView:ShowClassHero()
    end
end

--- @return void
function SlotHeroIconView:DeSpawnHeroIconView()
    if self.heroResource ~= nil then
        self.heroResource = nil
    end
    if self.heroIconView ~= nil then
        self.heroIconView:ReturnPool()
        self.heroIconView = nil
    end
end

return SlotHeroIconView
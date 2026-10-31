require "lua.client.core.network.hero.HeroEvolveOutBound"

--- @class MultiEvolveItemView : IconView
MultiEvolveItemView = Class(MultiEvolveItemView, IconView)

--- @return void
function MultiEvolveItemView:Ctor()
    IconView.Ctor(self)
    ---@type HeroEvolveOutBound
    self.heroEvolveOutBound = nil
    ---@type HeroIconView
    self.heroIconView = nil
    ---@type List
    self.listHeroMaterialView = List()
    ---@type HeroEvolvePriceConfig
    self.heroEvolvePrice = nil
    ---@type function
    self.onClickRemove = nil
    ---@type function
    self.onClickAuto = nil
end

--- @return void
function MultiEvolveItemView:SetPrefabName()
    self.prefabName = 'multi_evolve_item'
    self.uiPoolType = UIPoolType.MultiEvolveItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function MultiEvolveItemView:SetConfig(transform)
    ---@type MultiEvolveItemConfig
    self.config = UIBaseConfig(transform)
    self.config.buttonAuto.onClick:AddListener(function ()
        if self.onClickAuto ~= nil then
            self.onClickAuto()
        end
    end)
    self.config.buttonRemove.onClick:AddListener(function ()
        if self.onClickRemove ~= nil then
            self.onClickRemove()
        end
    end)
end

--- @return void
function MultiEvolveItemView:InitLocalization()
    self.config.textAuto.text = LanguageUtils.LocalizeCommon("auto_fill")
    self.config.textRemove.text = LanguageUtils.LocalizeCommon("remove")
end

--- @return void
---@param func function
function MultiEvolveItemView:AddListener(func)
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(func)
end

--- @return void
--- @param heroEvolveOutBound HeroEvolveOutBound
function MultiEvolveItemView:SetData(heroEvolveOutBound, onClickRemove, onClickAuto)
    self.onClickRemove = onClickRemove
    self.onClickAuto = onClickAuto
    self.heroEvolveOutBound = heroEvolveOutBound
    ---@type HeroResource
    local heroResource = InventoryUtils.GetHeroResourceByInventoryId(self.heroEvolveOutBound.heroInventoryId)
    if self.heroIconView == nil then
        self.heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.iconMainHeroEvolve)
    end
    self.heroIconView:SetIconData(HeroIconData.CreateByHeroResource(heroResource))
    self:ActiveSelection(false)
    self:UpdateFillHero()
end

function MultiEvolveItemView:UpdateFillHero()
    ---@type HeroResource
    local heroResource = InventoryUtils.GetHeroResourceByInventoryId(self.heroEvolveOutBound.heroInventoryId)
    self:ReturnPoolListMaterial()
    self.heroEvolvePrice = ResourceMgr.GetHeroMenuConfig():GetHeroEvolvePriceConfig(heroResource.heroId, heroResource.heroStar + 1)
    ---@param heroMaterialEvolveData HeroMaterialEvolveData
    for i, heroMaterialEvolveData in ipairs(self.heroEvolvePrice.heroMaterialEvolveData:GetItems()) do
        ---@type HeroIconData
        local iconData = heroMaterialEvolveData:GetHeroIconDataByHeroResource(heroResource)
        for i = 1, heroMaterialEvolveData.number do
            ---@type HeroIconView
            local material = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.iconMaterialHeroEvolve)
            material:SetActiveColorObject(material.config.heroIcon.gameObject, false)
            material:SetIconData(iconData)
            material:ActiveAdd(true)
            self.listHeroMaterialView:Add(material)
        end
    end
    ---@param heroEvolveMaterialOutBound HeroEvolveMaterialOutBound
    for i, heroEvolveMaterialOutBound in ipairs(self.heroEvolveOutBound.heroMaterials:GetItems()) do
        ---@type HeroIconData
        local iconData = heroEvolveMaterialOutBound:GetHeroIconData()
        if iconData then
            ---@type HeroIconView
            local material = self.listHeroMaterialView:Get(heroEvolveMaterialOutBound.index + 1)
            material:SetActiveColorObject(material.config.heroIcon.gameObject, true)
            material:SetIconData(iconData)
            material:SetSizeHeroView()
            material:ActiveAdd(false)
        end
    end
end

---@param isActive boolean
function MultiEvolveItemView:ActiveButtonRemove(isActive)
    self.config.buttonRemove.gameObject:SetActive(isActive)
end

---@param isActive boolean
function MultiEvolveItemView:ActiveSelection(isActive)
    self.config.bgHeroEvolveSelected:SetActive(isActive)
end

function MultiEvolveItemView:ReturnPoolListMaterial()
    ClientConfigUtils.ReturnPoolList(self.listHeroMaterialView)
end

--- @return void
function MultiEvolveItemView:ReturnPool()
    IconView.ReturnPool(self)
    if self.heroIconView ~= nil then
        self.heroIconView:ReturnPool()
        self.heroIconView = nil
    end
    self:ReturnPoolListMaterial()
    self.config.button.onClick:RemoveAllListeners()
end

return MultiEvolveItemView
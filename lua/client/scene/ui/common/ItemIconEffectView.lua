---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.ItemIconEffectConfig"

--- @class ItemIconEffectView : ItemIconView
ItemIconEffectView = Class(ItemIconEffectView, ItemIconView)

--- @return void
function ItemIconEffectView:Ctor()
    ItemIconView.Ctor(self)
end
--- @return void
function ItemIconEffectView:SetPrefabName()
    self.prefabName = 'item_icon_effect_view'
    self.uiPoolType = UIPoolType.ItemIconEffectView
end

--- @return void
--- @param transform UnityEngine_Transform
function ItemIconEffectView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type ItemIconConfig
    ---@type ItemIconEffectConfig
    self.config = UIBaseConfig(transform)
end

---@return void
function ItemIconEffectView:GetPathEquipment()
    return ResourceLoadUtils.iconEquipmentEffect
end

---@return void
function ItemIconEffectView:GetPathArtifact()
    return ResourceLoadUtils.iconArtifactEffect
end

---@return void
function ItemIconEffectView:GetPathCurrency()
    return ResourceLoadUtils.iconCurrenciesEffect
end

---@return void
---@param id number
function ItemIconEffectView:_SetIcon(id)
    ItemIconView._SetIcon(self, id)
    UIUtils.SetFillSizeImage(self.config.item, self.config.rectTransform.sizeDelta.x, 300)
end

--- @return void
--- @param star number
function ItemIconEffectView:_SetStar(star)
    if star ~= nil and star > 0 then
        self.config.starImage.gameObject:SetActive(true)
        UIUtils.SlideImageHorizontal(self.config.starImage, star)
    else
        self.config.starImage.gameObject:SetActive(false)
    end
end

return ItemIconEffectView



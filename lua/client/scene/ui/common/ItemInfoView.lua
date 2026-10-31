---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.ItemInfoViewConfig"

--- @class ItemInfoView : IconView
ItemInfoView = Class(ItemInfoView, IconView)

--- @return void
function ItemInfoView:Ctor()
    IconView.Ctor(self)

    --- @type RootIconView
    self.rootIconView = nil
end
--- @return void
function ItemInfoView:SetPrefabName()
    self.prefabName = 'item_info_view'
    self.uiPoolType = UIPoolType.ItemInfoView
end

--- @return void
--- @param transform UnityEngine_Transform
function ItemInfoView:SetConfig(transform)
    --- @type ItemInfoViewConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param iconData ItemIconData
--- @param size UnityEngine_Vector2
function ItemInfoView:SetIconData(iconData, size)
    self.iconData = iconData
    self.iconSize = size
    self:UpdateView()
end

--- @return void
function ItemInfoView:UpdateView()
    if self.rootIconView == nil then
        self.rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.itemIconAnchor)
    end

    local itemIconData = ItemIconData.Clone(self.iconData)
    self.rootIconView:SetIconData(itemIconData)

    self.rootIconView:RegisterShowInfo()
    if self.iconSize then
        self.rootIconView:SetSize(self.iconSize.x, self.iconSize.y)
    end

    self:ShowDefaultInfo(self.iconData.tittle, self.iconData.info)
end

--- @return void
function ItemInfoView:ReturnPool()
    IconView.ReturnPool(self)
    if self.rootIconView ~= nil then
        self.rootIconView:ReturnPool()
        self.rootIconView = nil
    end
end

--- @param tittle string
--- @param info string
function ItemInfoView:ShowDetailInfo(tittle, info)
    self.config.tittle.text = tittle
    self.config.info.text = info
end

function ItemInfoView:ShowDefaultInfo()
    local title = LanguageUtils.GetStringResourceName(self.iconData.type, self.iconData.itemId)
    local info = LanguageUtils.GetStringResourceType(self.iconData.type, self.iconData.itemId)
    self:ShowDetailInfo(title, info)
    self:SetScaleInfo(1, 1)
end

--- @param titleScale number
--- @param infoScale number
function ItemInfoView:SetScaleInfo(titleScale, infoScale)
    self.config.tittle.transform.localScale = U_Vector3.one * titleScale
    self.config.info.transform.localScale = U_Vector3.one * infoScale
end

return ItemInfoView



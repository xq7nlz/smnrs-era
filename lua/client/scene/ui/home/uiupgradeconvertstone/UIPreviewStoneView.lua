---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiUpgradeConvertStone.UIPreviewStoneConfig"

--- @class UIPreviewStoneView
UIPreviewStoneView = Class(UIPreviewStoneView)

--- @return void
--- @param transform UnityEngine_Transform
function UIPreviewStoneView:Ctor(transform)
    ---@type UIPreviewStoneConfig
    ---@type UIPreviewStoneConfig
    self.config = UIBaseConfig(transform)
    ---@type ItemIconView
    self.iconView = nil
end

--- @return void
--- @param id number
function UIPreviewStoneView:ShowStone(id)
    if self.iconView == nil then
        self.iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ItemIconView, self.config.item)
    end
    self.iconView:SetIconData(ItemIconData.CreateInstance( ResourceType.ItemStone, id))
    ---@type ItemData
    local itemData = ResourceMgr.GetServiceConfig():GetItemData(ResourceType.ItemStone, id)
    self.config.textName.text = LanguageUtils.GetStringResourceName(ResourceType.ItemStone, id)
    self.config.textStone.text = LanguageUtils.GetStringResourceType(ResourceType.ItemStone, id)
    self.config.textInfo.text = LanguageUtils.GetDescriptionStatItem(itemData)
end

--- @return void
function UIPreviewStoneView:Hide()
    if self.iconView ~= nil then
        self.iconView:ReturnPool()
        self.iconView = nil
    end
end
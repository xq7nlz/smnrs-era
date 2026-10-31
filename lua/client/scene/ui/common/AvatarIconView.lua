--- @class AvatarIconView : IconView
AvatarIconView = Class(AvatarIconView, IconView)

AvatarIconView.prefabName = 'avatar_icon_view'

--- @return void
function AvatarIconView:Ctor()
    IconView.Ctor(self)
end

--- @return void
function AvatarIconView:SetPrefabName()
    self.prefabName = 'avatar_icon_view'
    self.uiPoolType = UIPoolType.AvatarIconView
end

--- @return void
--- @param transform UnityEngine_Transform
function AvatarIconView:SetConfig(transform)
    if transform then
        ---@type AvatarIconConfig
        self.config = UIBaseConfig(transform)
    else
        XDebug.Error("transform is nil")
    end
end

--- @return void
--- @param itemIconData ItemIconData
--- @param isSelect boolean
function AvatarIconView:SetIconData(itemIconData, isSelect)
    self.iconData = itemIconData

    self.config.icon.sprite = ClientConfigUtils.GetSpriteSkin(itemIconData.itemId)

    local avatarItemConfig = ResourceMgr.GetAvatarConfig():GetAvatarItemConfig(self.iconData.itemId)
    self:ActiveUIPool(UIPoolType.MarkLimitedTime, avatarItemConfig ~= nil and avatarItemConfig.timeDuration > 0)

    UIUtils.FillSizeHeroView(self.config.icon)
    self:ActiveEffectSelect(isSelect == true)
end

--- @return void
---@param func function
function AvatarIconView:AddListener(func)
    self:EnableButton(true)
    self.config.button.onClick:AddListener(func)
end

--- @return void
function AvatarIconView:RemoveAllListeners()
    self:EnableButton(false)
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function AvatarIconView:EnableButton(enabled)
    UIUtils.SetInteractableButton(self.config.button, enabled)
    self.config.icon.raycastTarget = enabled
end

--- @return void
--- @param enabled boolean
function AvatarIconView:EnableRaycast(enabled)
    self.config.icon.raycastTarget = enabled
end

--- @return void
function AvatarIconView:ShowInfo()
    if self.iconData ~= nil then
        PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = self.iconData.type, ["id"] = self.iconData.itemId, ["rate"] = self.rate } })
    end
end

return AvatarIconView
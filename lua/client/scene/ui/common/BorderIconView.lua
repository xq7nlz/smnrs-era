---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.BorderIconConfig"

--- @class BorderIconView : IconView
BorderIconView = Class(BorderIconView, IconView)

BorderIconView.prefabName = 'border_icon_view'

--- @return void
function BorderIconView:Ctor()
    IconView.Ctor(self)
end

--- @return void
function BorderIconView:SetPrefabName()
    self.prefabName = 'border_icon_view'
    self.uiPoolType = UIPoolType.BorderIconView
end

--- @return void
--- @param transform UnityEngine_Transform
function BorderIconView:SetConfig(transform)
    assert(transform)
    --- @type BorderIconConfig
    ---@type BorderIconConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param id number
function BorderIconView:_GetPathBorder(id)
    return string.format(ResourceLoadUtils.iconBorder, id)
end
--- @return number
function BorderIconView:GetBorderLimitedTime(id)
    ---@type FrameItemConfig
    local frameItemConfig = ResourceMgr.GetAvatarConfig():GetFrameItemConfig(id)
    if (frameItemConfig == nil) then
        return -1
    end
    return frameItemConfig.timeDuration
end

--- @return void
--- @param itemIconData ItemIconData
function BorderIconView:SetIconData(itemIconData)
    self.iconData = itemIconData
    local id = itemIconData.itemId
    self.config.frame.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconBorder, id)
    local borderIsLimitedTime = self:GetBorderLimitedTime(id) > 0

    self:ActiveUIPool(UIPoolType.MarkLimitedTime, borderIsLimitedTime)
    UIUtils.FillSizeHeroView(self.config.frame)
    self:ActiveEffectSelect(isSelect == true)

    self.config.frame:SetNativeSize()
end

--- @return void
---@param func function
function BorderIconView:AddListener(func)
    self:EnableButton(true)
    self.config.button.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func then
            func()
        end
    end)
end

--- @return void
function BorderIconView:RemoveAllListeners()
    self:EnableButton(false)
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function BorderIconView:EnableButton(enabled)
    UIUtils.SetInteractableButton(self.config.button, enabled)
    self.config.frame.raycastTarget = enabled
end

--- @return void
--- @param enabled boolean
function BorderIconView:EnableRaycast(enabled)
    self.config.frame.raycastTarget = enabled
end

--- @return void
function BorderIconView:ShowInfo()
    ---@type number
    local _borderDuration = self:GetBorderLimitedTime(self.iconData.itemId)

    if self.iconData ~= nil then
        --XDebug.Log("border time " .. tostring(_borderDuration))
        PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = {["type"] = self.iconData.type, ["id"] = self.iconData.itemId, ["rate"] = self.rate ,["border"] = _borderDuration }})
    end
end

return BorderIconView
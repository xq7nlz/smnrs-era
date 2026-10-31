--- @class SkinIconView : MotionIconView
SkinIconView = Class(SkinIconView, MotionIconView)

--- @return void
--- @param transform UnityEngine_RectTransform
function SkinIconView:Ctor(transform)
    MotionIconView.Ctor(self, transform)
end

--- @return void
function SkinIconView:SetPrefabName()
    self.prefabName = 'skin_icon_info'
    self.uiPoolType = UIPoolType.SkinIconView
end

--- @return void
--- @param transform UnityEngine_Transform
function SkinIconView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type SkinIconConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param iconData ItemIconData
function SkinIconView:SetIconData(iconData)
    if iconData == nil then
        XDebug.Error("SkinIconView:SetIconData NIL")
        return
    end
    --- @type ItemIconData
    self.iconData = iconData
    self:UpdateView()
    self:SetAlpha(1)
end

--- @return void
---@param func function
function SkinIconView:AddListener(func)
    self:EnableButton(true)
    self.config.button.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func then
            func()
        end
    end)
end

--- @return void
function SkinIconView:RemoveAllListeners()
    self:EnableButton(false)
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function SkinIconView:EnableButton(enabled)
    UIUtils.SetInteractableButton(self.config.button, enabled)
    self.config.icon.raycastTarget = enabled
end

--- @return void
--- @param enabled boolean
function SkinIconView:EnableRaycast(enabled)
    self.config.icon.raycastTarget = enabled
end

--- @return void
function SkinIconView:UpdateView()
    self.config.icon.sprite = ResourceLoadUtils.LoadSkinIcon(self.iconData.itemId)
    if not Main.IsNull(self.config.icon.sprite) then
        UIUtils.FillSizeHeroView(self.config.icon)
    end
    ---@type SkinDataEntry
    local skinDataEntry = ResourceMgr.GetServiceConfig():GetItems().skinDataEntries:Get(self.iconData.itemId)
    local rarity = ClientConfigUtils.GetSkinRarity(skinDataEntry.id)
    self.config.rarity.sprite = ResourceLoadUtils.LoadSkinRarity(rarity)
    self.config.rarity:SetNativeSize()
    if self.iconData.quantity ~= nil then
        self.config.textNumber.text = tostring(self.iconData.quantity)
        self.config.textNumber.gameObject:SetActive(true)
    else
        self.config.textNumber.gameObject:SetActive(false)
    end
end

--- @return void
function SkinIconView:ReturnPool()
    MotionIconView.ReturnPool(self)

    --if self.iconData ~= nil then
    --    self.iconData:ReturnPool()
    --    self.iconData = nil
    --end
end

--- @param isActive boolean
function SkinIconView:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

--- @return void
function SkinIconView:ShowInfo()
    if self.iconData ~= nil then
        PopupMgr.ShowPopup(UIPopupName.UISkinPreview, { ["type"] = self.iconData.type, ["id"] = self.iconData.itemId})
    end
end

return SkinIconView
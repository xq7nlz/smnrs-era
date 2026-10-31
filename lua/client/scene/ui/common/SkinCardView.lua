--- @class SkinCardView : MotionIconView
SkinCardView = Class(SkinCardView, MotionIconView)

--- @return void
--- @param transform UnityEngine_RectTransform
function SkinCardView:Ctor(transform)
    MotionIconView.Ctor(self, transform)
end

--- @return void
function SkinCardView:SetPrefabName()
    self.prefabName = 'skin_card_info'
    self.uiPoolType = UIPoolType.SkinCardView
end

--- @return void
--- @param transform UnityEngine_Transform
function SkinCardView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type SkinCardConfig
    self.config = UIBaseConfig(transform)
end

function SkinCardView:InitLocalization()
    self.config.equipped.text = LanguageUtils.LocalizeCommon("equipped")
end

--- @return void
--- @param iconData ItemIconData
function SkinCardView:SetIconData(iconData)
    if iconData == nil then
        XDebug.Error("SkinCardView:SetIconData NIL")
        return
    end
    --- @type ItemIconData
    self.iconData = iconData
    self:UpdateView()
    self:SetAlpha(1)
end

--- @return void
---@param func function
function SkinCardView:AddListener(func)
    self:EnableButton(true)
    self.config.button.onClick:AddListener(func)
end

--- @return void
function SkinCardView:RemoveAllListeners()
    self:EnableButton(false)
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function SkinCardView:EnableButton(enabled)
    UIUtils.SetInteractableButton(self.config.button, enabled)
    self.config.icon.raycastTarget = enabled
end

--- @return void
--- @param enabled boolean
function SkinCardView:EnableRaycast(enabled)
    self.config.icon.raycastTarget = enabled
end

--- @return void
function SkinCardView:UpdateView()
    self.config.faction.sprite = ResourceLoadUtils.LoadFactionIcon(ClientConfigUtils.GetFactionIdByHeroId(ClientConfigUtils.GetHeroIdBySkinId(self.iconData.itemId)))
    self.config.icon.sprite = ResourceLoadUtils.LoadSkinIcon(self.iconData.itemId)
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
function SkinCardView:ReturnPool()
    MotionIconView.ReturnPool(self)

    --if self.iconData ~= nil then
    --    self.iconData:ReturnPool()
    --    self.iconData = nil
    --end
    self.config.transform:GetChild(0).localScale = U_Vector3.zero
    self:UnEquip()
    self:SetSize(0,0)
end

--- @param isActive boolean
function SkinCardView:SetActive(isActive)
    self.config.gameObject:SetActive(isActive)
end

--- @return void
function SkinCardView:Equip()
    self:SetActiveColor2(false)
    self.config.equipped.transform.parent.gameObject:SetActive(true)
end

--- @return void
function SkinCardView:UnEquip()
    self:SetActiveColor2(true)
    self.config.equipped.transform.parent.gameObject:SetActive(false)
end

--- @return void
function SkinCardView:ShowInfo()
    if self.iconData ~= nil then
        PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = self.iconData.type, ["id"] = self.iconData.itemId}})
    end
end

--- @return void
function SkinCardView:ShowPreview()
    if self.iconData ~= nil then
        PopupMgr.ShowPopup(UIPopupName.UISkinPreview, { ["type"] = self.iconData.type, ["id"] = self.iconData.itemId})
    end
end

return SkinCardView
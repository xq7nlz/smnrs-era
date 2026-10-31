--- @class VipIconView : IconView
VipIconView = Class(VipIconView, IconView)

--- @return void
function VipIconView:Ctor()
    IconView.Ctor(self)
end

--- @return void
function VipIconView:SetPrefabName()
    self.prefabName = 'vip_icon_view'
    self.uiPoolType = UIPoolType.VipIconView
end

--- @return void
--- @param transform UnityEngine_Transform
function VipIconView:SetConfig(transform)
    assert(transform)
    --- @type VipIconConfig
    ---@type VipIconConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
function VipIconView:SetData(avatar, level, border)
    self.config.textLevel.text = level
    self.config.avatar.sprite = ClientConfigUtils.GetSpriteSkin(avatar)
    UIUtils.FillSizeHeroView(self.config.avatar)
    local spriteBorder = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconBorder, border)
    if spriteBorder == nil then
        spriteBorder = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconBorder, 0)
        XDebug.Warning("Nill border " .. border)
    end
    self.config.bgVip.sprite = spriteBorder
    self.config.bgVip:SetNativeSize()
    self.config.textVip.gameObject:SetActive(false)

    self:SetFX(avatar)
end

--- @return void
function VipIconView:SetData2(_avatar, level)
    local avatar, border = ClientConfigUtils.GetAvatarId(_avatar)
    self:SetData(avatar, level, border)
end

--- @return void
function VipIconView:SetGuildAvatar(avatar)
    self.config.textLevel.text = ""
    self.config.avatar.sprite = ResourceLoadUtils.LoadGuildIcon(avatar)
    self.config.bgVip.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconBorder, 0)
    self.config.bgVip:SetNativeSize()
    self.config.textVip.gameObject:SetActive(false)
end

--- @return void
---@param listener function
function VipIconView:AddListener(listener)
    self:EnableButton(true)
    self.config.button.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if listener then
            listener()
        end
    end)
end

--- @return void
function VipIconView:RemoveAllListeners()
    self:EnableButton(false)
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function VipIconView:EnableButton(enabled)
    UIUtils.SetInteractableButton(self.config.button, enabled)
    self.config.avatar.raycastTarget = enabled
end

--- @return void
--- @param avatarID number
function VipIconView:SetFX(avatarID)
   local fx_id = ResourceMgr.GetAvatarEffectConfig():GetAvatarEffectID(avatarID)
     if (fx_id ~= nil) then
         self:ClearEffectPoolDict()
        self:ActiveFXAvatar(fx_id)
     else
         self:ClearEffectPoolDict()
     end
end
--- @return void
function VipIconView:ActiveFXAvatar(fx_id)
    local effectPoolType = EffectPoolType.AvatarEffect .. fx_id
    local bgIndex =  self.config.bgVip.transform:GetSiblingIndex()
    self:ActiveEffectPool(effectPoolType, true, nil,
            function(effect)
               -- effect:SetAsLastSibling()
                 effect:SetSiblingIndex(bgIndex)
                end
    )
end

return VipIconView


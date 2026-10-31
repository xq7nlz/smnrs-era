---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiSelectGuildLogo.GuildLogoSelectItemConfig"

--- @class GuildLogoSelectItem : IconView
GuildLogoSelectItem = Class(GuildLogoSelectItem, IconView)

function GuildLogoSelectItem:Ctor()
    IconView.Ctor(self)
end

function GuildLogoSelectItem:SetPrefabName()
    self.prefabName = 'guild_logo_select_item'
    self.uiPoolType = UIPoolType.GuildLogoSelectItem
end

--- @return void
--- @param transform UnityEngine_Transform
function GuildLogoSelectItem:SetConfig(transform)
    --- @type GuildLogoSelectItemConfig
    self.config = UIBaseConfig(transform)
end

--- @param sprite UnityEngine_SpriteRenderer
function GuildLogoSelectItem:SetIcon(sprite)
    self.config.iconGuildFlag.sprite = sprite
end

--- @param isSelect boolean
function GuildLogoSelectItem:SetSelect(isSelect)
    self.config.select:SetActive(isSelect)
    self.config.iconTick:SetActive(isSelect)
end

--- @param listener function
function GuildLogoSelectItem:AddOnSelectListener(listener)
    self.config.buttonSelect.onClick:RemoveAllListeners()
    self.config.buttonSelect.onClick:AddListener(function ()
        if listener ~= nil then
            listener()
        end
    end)
end

return GuildLogoSelectItem
--- @class GuildIconView : IconView
GuildIconView = Class(GuildIconView, IconView)

--- @return void
function GuildIconView:Ctor()
    IconView.Ctor(self)
end

--- @return void
function GuildIconView:SetPrefabName()
    self.prefabName = 'guild_icon_view'
    self.uiPoolType = UIPoolType.GuildIconView
end

--- @return void
--- @param transform UnityEngine_Transform
function GuildIconView:SetConfig(transform)
    assert(transform)
    --- @type GuildIconViewConfig
    self.config = UIBaseConfig(transform)
end

function GuildIconView:InitLocalization()
    self.config.textLevel.text = LanguageUtils.LocalizeCommon("level")
end

--- @param avatar UnityEngine_SpriteRenderer
--- @param level number
function GuildIconView:SetData(avatar, level)
    self.config.avatar.sprite = avatar
    self.config.avatar:SetNativeSize()
    self.config.textLevelNumber.text = tostring(level)
end

return GuildIconView


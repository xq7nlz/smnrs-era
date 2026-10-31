---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiSwitchCharacter.SwitchCharacterIconConfig"

--- @class SwitchCharacterIconView : IconView
SwitchCharacterIconView = Class(SwitchCharacterIconView, IconView)

--- @return void
function SwitchCharacterIconView:Ctor()
    IconView.Ctor(self)
end

--- @return void
function SwitchCharacterIconView:SetPrefabName()
    self.prefabName = 'main_character_card'
    self.uiPoolType = UIPoolType.SwitchCharacterIconView
end

--- @return void
--- @param transform UnityEngine_Transform
function SwitchCharacterIconView:SetConfig(transform)
    assert(transform)
    --- @type SwitchCharacterIconConfig
    ---@type SwitchCharacterIconConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param iconData IconData
function SwitchCharacterIconView:SetIconData(iconData)

end

return SwitchCharacterIconView
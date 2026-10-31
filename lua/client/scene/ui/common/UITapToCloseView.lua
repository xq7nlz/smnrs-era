---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.UITapToCloseConfig"

--- @class UITapToCloseView : IconView
UITapToCloseView = Class(UITapToCloseView, IconView)

--- @return void
function UITapToCloseView:Ctor()
    IconView.Ctor(self)
end

--- @return void
function UITapToCloseView:SetPrefabName()
    self.prefabName = 'text_tap_to_close'
    self.uiPoolType = UIPoolType.UITapToCloseView
end

--- @return void
--- @param transform UnityEngine_Transform
function UITapToCloseView:SetConfig(transform)
    assert(transform)
    --- @type UITapToCloseConfig
    ---@type UITapToCloseConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
function UITapToCloseView:InitLocalization()
    self.config.localizeTapToClose.gameObject:SetActive(false)
end

return UITapToCloseView
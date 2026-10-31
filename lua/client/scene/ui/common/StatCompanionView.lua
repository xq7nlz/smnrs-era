---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.StatCompanionConfig"

--- @class StatCompanionView : IconView
StatCompanionView = Class(StatCompanionView, IconView)

--- @return void
function StatCompanionView:Ctor()
    IconView.Ctor(self)
end

--- @return void
function StatCompanionView:SetPrefabName()
    self.prefabName = 'stat_companion'
    self.uiPoolType = UIPoolType.StatCompanionView
end

--- @return void
--- @param transform UnityEngine_Transform
function StatCompanionView:SetConfig(transform)
    assert(transform)
    --- @type StatCompanionConfig
    ---@type StatCompanionConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
---@param statBonus StatBonus
function StatCompanionView:SetData(statBonus, color)
    if color ~= nil then
        self.config.textStats.text = UIUtils.SetColorString(color, LanguageUtils.LocalizeStatBonus(statBonus))
    else
        self.config.textStats.text = LanguageUtils.LocalizeStatBonus(statBonus)
    end
end

return StatCompanionView
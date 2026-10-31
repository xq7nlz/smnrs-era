---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.StatUpgradeViewConfig"

--- @class StatUpgradeView : IconView
StatUpgradeView = Class(StatUpgradeView, IconView)

--- @return void
function StatUpgradeView:Ctor(component)
    IconView.Ctor(self)
end

--- @return void
function StatUpgradeView:SetPrefabName()
    self.prefabName = 'stat_upgrade_view'
    self.uiPoolType = UIPoolType.StatUpgradeView
end

--- @return void
--- @param transform UnityEngine_Transform
function StatUpgradeView:SetConfig(transform)
    assert(transform)
    --- @type StatUpgradeViewConfig
    ---@type StatUpgradeViewConfig
    self.config = UIBaseConfig(transform)
    if self.effect == nil then
        self.effect = ResourceLoadUtils.LoadUIEffect("fx_ui_uptier", self.config.fxUiUptier)
    end
    self.effect:SetActive(false)
end

--- @return void
---@param title string
---@param stat1 number
---@param stat2 number
function StatUpgradeView:SetData(title, stat1, stat2)
    self.config.title.text = title
    self.config.stat1.text = tostring(stat1)
    self.config.stat2.text = tostring(stat2)
    if self.effect ~= nil then
        self.effect:SetActive(false)
    end
end

--- @return void
function StatUpgradeView:PlayEffect()
    self.effect:SetActive(false)
    self.effect:SetActive(true)
end

return StatUpgradeView
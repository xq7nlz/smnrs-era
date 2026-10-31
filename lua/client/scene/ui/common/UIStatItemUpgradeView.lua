--- @class UIStatItemUpgradeView : IconView
UIStatItemUpgradeView = Class(UIStatItemUpgradeView, IconView)

--- @return void
function UIStatItemUpgradeView:Ctor()
    IconView.Ctor(self)
end

--- @return void
function UIStatItemUpgradeView:SetPrefabName()
    self.prefabName = 'stat_item_upgrade'
    self.uiPoolType = UIPoolType.UIStatItemUpgradeView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIStatItemUpgradeView:SetConfig(transform)
    assert(transform)
    ---@type UIStatItemUpgradeConfig
    self.config = UIBaseConfig(transform)
    --if self.effect == nil then
    --    self.effect = ResourceLoadUtils.LoadUIEffect("fx_ui_uptier", self.config.fxUiUptier)
    --end
    --self.effect:SetActive(false)
end

--- @return void
---@param title string
---@param stat1 number
---@param stat2 number
function UIStatItemUpgradeView:SetData(title, stat1, stat2)
    self.config.textStat.text = title
    self.config.textBaseValue.text = stat1
    self.config.textUpgardeValue.text = stat2
    --if self.effect ~= nil then
    --    self.effect:SetActive(false)
    --end
end

--- @return void
function UIStatItemUpgradeView:PlayEffect()
    if self.effect ~= nil then
        self.effect:SetActive(false)
        self.effect:SetActive(true)
    end
end


return UIStatItemUpgradeView
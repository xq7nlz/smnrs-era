--- @class RequirementHeroView : IconView
RequirementHeroView = Class(RequirementHeroView, IconView)

--- @return void
function RequirementHeroView:Ctor(component)
    IconView.Ctor(self)
end

--- @return void
function RequirementHeroView:InitTrigger(onPointEnter, onPointExit)
    UIUtils.SetTrigger(self.config.eventTrigger, onPointEnter, onPointExit)
end

--- @return void
function RequirementHeroView:SetPrefabName()
    self.prefabName = 'icon_requirement_view'
    self.uiPoolType = UIPoolType.RequirementHeroIconView
end

--- @return void
--- @param transform UnityEngine_Transform
function RequirementHeroView:SetConfig(transform)
    assert(transform)
    --- @type RequirementHeroConfig
    ---@type RequirementHeroConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
---@param pass boolean
function RequirementHeroView:SetPass(pass)
    self.config.tick:SetActive(pass)
end

return RequirementHeroView
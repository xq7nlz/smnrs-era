---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.RequirementHeroInfoConfig"

--- @class RequirementHeroInfoView : IconView
RequirementHeroInfoView = Class(RequirementHeroInfoView, IconView)

--- @return void
function RequirementHeroInfoView:Ctor(component)
    IconView.Ctor(self)
end

--- @return void
function RequirementHeroInfoView:SetPrefabName()
    self.prefabName = 'requirement_info'
    self.uiPoolType = UIPoolType.RequirementHeroInfoView
end

--- @return void
--- @param transform UnityEngine_Transform
function RequirementHeroInfoView:SetConfig(transform)
    assert(transform)
    --- @type RequirementHeroInfoConfig
    ---@type RequirementHeroInfoConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param text string
function RequirementHeroInfoView:SetData(text)
    self.config.text.text = text
    Coroutine.start(function ()
        coroutine.waitforendofframe()
        self.config.bgFilterPannel.rectTransform.sizeDelta = U_Vector2(self.config.text.rectTransform.sizeDelta.x + 100, self.config.bgFilterPannel.rectTransform.sizeDelta.y)
    end)
end

return RequirementHeroInfoView
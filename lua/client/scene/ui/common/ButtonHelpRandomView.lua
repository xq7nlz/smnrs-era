--- @class ButtonHelpRandomView : IconView
ButtonHelpRandomView = Class(ButtonHelpRandomView, IconView)

--- @return void
--- @param transform UnityEngine_RectTransform
function ButtonHelpRandomView:Ctor(transform)
    --- @type {gameObject : UnityEngine_GameObject, transform : UnityEngine_Transform, button : UnityEngine_UI_Button}
    self.config = nil
    IconView.Ctor(self, transform)
end

--- @return void
function ButtonHelpRandomView:SetPrefabName()
    self.prefabName = 'button_help_random'
    self.uiPoolType = UIPoolType.ButtonHelpRandomView
end

--- @return void
--- @param transform UnityEngine_Transform
function ButtonHelpRandomView:SetConfig(transform)
    self.config = {}
    self.config.gameObject = transform.gameObject
    self.config.transform = transform
    self.config.button = transform:GetComponent(ComponentName.UnityEngine_UI_Button)
end

--- @return void
---@param func function
function ButtonHelpRandomView:AddListener(func)
    self:RemoveAllListeners()
    self.config.button.onClick:AddListener(func)
end

--- @return void
function ButtonHelpRandomView:RemoveAllListeners()
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function ButtonHelpRandomView:EnableButton(enabled)
    self.config.gameObject:SetActive(enabled)
end

return ButtonHelpRandomView

--- @class WorldMapButtonMode
WorldMapButtonMode = Class(WorldMapButtonMode)

--- @param transform UnityEngine_Transform
function WorldMapButtonMode:Ctor(transform)
    self:_InitConfig(transform)
end

--- @param transform UnityEngine_Transform
function WorldMapButtonMode:_InitConfig(transform)
    --- @type {transform : UnityEngine_RectTransform, textMode : UnityEngine_UI_Text, button : UnityEngine_UI_Button}
    self.config = {}
    self.config.textMode = transform:Find("text_mode"):GetComponent(ComponentName.UnityEngine_UI_Text)
    self.config.button = transform:GetComponent(ComponentName.UnityEngine_UI_Button)
    self.config.transform = transform:GetComponent(ComponentName.UnityEngine_RectTransform)
end

function WorldMapButtonMode:AddOnSelectListener(listener)
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(function()
        if listener then
            listener()
        end
    end)
end

--- @param title string
function WorldMapButtonMode:SetButtonTitle(title)
    self.config.textMode.text = title
end

--- @return UnityEngine_Vector3
function WorldMapButtonMode:GetPosition()
    return self.config.transform.anchoredPosition3D
end

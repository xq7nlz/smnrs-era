--- @class SimpleButtonView : IconView
SimpleButtonView = Class(SimpleButtonView, IconView)

--- @return void
function SimpleButtonView:SetPrefabName()
    self.prefabName = 'simple_button_view'
    self.uiPoolType = UIPoolType.SimpleButtonView
end

--- @return void
--- @param transform UnityEngine_Transform
function SimpleButtonView:SetConfig(transform)
    ---@type SimpleButtonConfig
    self.config = UIBaseConfig(transform)
end

function SimpleButtonView:SetIconData(data)
    self:SetIcon(data.icon)

    self:SetIconScale(data.scale)

    self:SetCallback(data.callback)
end

--- @param icon UnityEngine_SpriteRenderer
function SimpleButtonView:SetIcon(icon)
    if icon ~= nil then
        self.config.icon.sprite = icon
        self.config.icon:SetNativeSize()
    end
end

function SimpleButtonView:SetIconScale(scale)
    scale = scale or 1
    self.config.icon.transform.localScale = U_Vector3.one * scale
end

--- @return void
---@param func function
function SimpleButtonView:SetCallback(func)
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func then
            func()
        end
    end)
end

function SimpleButtonView:ReturnPool()
    IconView.ReturnPool(self)

    self:SetIconScale(1)
end

return SimpleButtonView



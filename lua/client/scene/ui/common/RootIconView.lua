--- @class RootIconView : MotionIconView
RootIconView = Class(RootIconView, MotionIconView)

RootIconView.prefabName = 'root_info'

function RootIconView:Ctor()
    --- @type IconView
    self.iconView = nil
    ---@type boolean
    self.registerShowInfo = nil
    MotionIconView.Ctor(self)
end

--- @return void
function RootIconView:SetPrefabName()
    self.prefabName = 'root_info'
    self.uiPoolType = UIPoolType.RootIconView
end

--- @return void
--- @param transform UnityEngine_RectTransform
function RootIconView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type {transform, gameObject, rectTransform, visual : UnityEngine_RectTransform}
    self.config = {}
    self.config.transform = transform
    self.config.gameObject = transform.gameObject
    self.config.rectTransform = transform:GetComponent(ComponentName.UnityEngine_RectTransform)
    self.config.visual = transform:Find("visual"):GetComponent(ComponentName.UnityEngine_RectTransform)
end

--- @return void
--- @param itemIconData ItemIconData
function RootIconView:SetIconData(itemIconData)
    self.iconData = itemIconData
    if self.iconView ~= nil then
        self.iconView:ReturnPool()
        self.iconView = nil
    end
    self.iconView = SmartPoolUtils.GetIconViewByIconData(self.iconData, self.config.visual)
    if self.registerShowInfo == true then
        self.iconView:RegisterShowInfo()
    end
    self:SetAlpha(1)
    self:DefaultShow()
end

--- @return void
--- @param func function
function RootIconView:SetItemTicked()

end

--- @return void
--- @param func function
function RootIconView:AddListener(func)
    self:RemoveAllListeners()
    if self.iconView ~= nil then
        self.iconView:AddListener(func)
    end
end

--- @return void
--- @param func function
function RootIconView:RemoveAllListeners(func)
    if self.iconView ~= nil then
        self.iconView:RemoveAllListeners()
    end
end

--- @return void
function RootIconView:Show()
    IconView.Show(self)
end

--- @return void
function RootIconView:ReturnPool()
    IconView.ReturnPool(self)
    if self.iconView ~= nil then
        --XDebug.Log(LogUtils.ToDetail(self.iconView))
        self.iconView:ReturnPool()
        self.iconView = nil
    end
    self:SetSize(0, 0)
    self.registerShowInfo = nil
end

--- @return void
function RootIconView:ActiveEffectSelect(isActive)
    if self.iconView ~= nil then
        self.iconView:ActiveEffectSelect(isActive)
    end
end

--- @return void
function RootIconView:RegisterShowInfo()
    self.registerShowInfo = true
    if self.iconView ~= nil then
        self.iconView:RegisterShowInfo()
    end
end

--- @return void
function RootIconView:ShowInfo()
    if self.iconView ~= nil then
        self.iconView:ShowInfo()
    end
end

return RootIconView

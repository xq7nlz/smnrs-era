---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.FragmentIconConfig"

--- @class FragmentIconView : MotionIconView
FragmentIconView = Class(FragmentIconView, MotionIconView)

FragmentIconView.prefabName = 'fragment_icon_info'

--- @return void
function FragmentIconView:Ctor()
    ---@type RootIconView
    self.iconView = nil
    --- @type FragmentIconData
    self.iconData = nil
    IconView.Ctor(self)
end

--- @return void
function FragmentIconView:SetPrefabName()
    self.prefabName = 'fragment_icon_info'
    self.uiPoolType = UIPoolType.FragmentIconView
end

--- @return void
--- @param transform UnityEngine_Transform
function FragmentIconView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type FragmentIconConfig
    ---@type FragmentIconConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param iconData FragmentIconData
function FragmentIconView:SetIconData(iconData)
    assert(iconData)
    self.iconData = iconData
    if self.iconView == nil then
        self.iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.iconInfo)
    end
    self:UpdateView()
    self.iconView:SetAlpha(1)
end

--- @return void
---@param func function
function FragmentIconView:AddListener(func)
    if self.iconView ~= nil then
        self.iconView:AddListener(func)
    end
end

--- @return void
function FragmentIconView:RemoveAllListeners()
    if self.iconView ~= nil then
        self.iconView:RemoveAllListeners()
    end
end

--- @return void
--- @param enabled boolean
function FragmentIconView:EnableButton(enabled)
    if self.iconView ~= nil then
        self.iconView:EnableButton(enabled)
    end
end

--- @return void
--- @param enabled boolean
function FragmentIconView:EnableRaycast(enabled)
    if self.iconView ~= nil then
        self.iconView:EnableRaycast(enabled)
    end
end

--- @return void
function FragmentIconView:UpdateView()
    ---@type ItemIconData
    local iconData = ItemIconData.CreateInstance(self.iconData.type, self.iconData.itemId, nil)
    --XDebug.Log(LogUtils.ToDetail(iconData))
    self.iconView:SetIconData(iconData)
    local fill = self.iconData.quantity / self.iconData.countFull
    if fill >= 1 then
        fill = 1
        self.config.imageProcessFull:SetActive(true)
        self.config.imageProcess.gameObject:SetActive(false)
    else
        self.config.imageProcessFull:SetActive(false)
        self.config.imageProcess.gameObject:SetActive(true)
    end
    self.config.imageProcess.fillAmount = fill
    self.config.textProcess.text = string.format("%d/%d", self.iconData.quantity, self.iconData.countFull)
end

--- @return void
function FragmentIconView:ReturnPool()
    MotionIconView.ReturnPool(self)
    if self.iconView ~= nil then
        self.iconView:ReturnPool()
        self.iconView = nil
    end

    self.iconData = nil
end

--- @return void
function FragmentIconView:ShowInfo()
    if self.iconView ~= nil then
        self.iconView:ShowInfo()
    end
end

return FragmentIconView


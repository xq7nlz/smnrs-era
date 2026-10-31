---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.HeroMaterialIconConfig"

--- @class HeroMaterialIconView : IconView
HeroMaterialIconView = Class(HeroMaterialIconView, IconView)

HeroMaterialIconView.prefabName = 'hero_material_view'

--- @return void
function HeroMaterialIconView:Ctor()
    ---@type HeroIconView
    self.iconView = nil
    ---@type HeroIconData
    self.iconData = nil
    ---@type number
    self.number = nil
    ---@type number
    self.full = nil
    IconView.Ctor(self)
end

--- @return void
function HeroMaterialIconView:SetPrefabName()
    self.prefabName = 'hero_material_view'
    self.uiPoolType = UIPoolType.HeroMaterialIconView
end

--- @return void
--- @param transform UnityEngine_Transform
function HeroMaterialIconView:SetConfig(transform)
    assert(transform)
    --- @type HeroMaterialIconConfig
    ---@type HeroMaterialIconConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param iconData HeroIconData
--- @param number number
--- @param full number
function HeroMaterialIconView:SetIconData(iconData, number, full)
    self.iconData = iconData
    self:SetNumberData(number, full)
end

--- @return void
--- @param number number
--- @param full number
function HeroMaterialIconView:SetNumberData(number, full)
    self.number = number
    self.full = full
    self:UpdateView()
end

--- @return void
---@param func function
function HeroMaterialIconView:AddListener(func)
    --XDebug.Log(LogUtils.ToDetail(self.iconView))
    if self.iconView == nil then
        self.iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.heroIconInfo)
    end
    self.iconView:AddListener(func)
end

--- @return void
function HeroMaterialIconView:RemoveAllListeners()
    if self.iconView ~= nil then
        self.iconView:RemoveAllListeners()
    end
end

--- @return void
--- @param enabled boolean
function HeroMaterialIconView:EnableButton(enabled)
    if self.iconView ~= nil then
        self.iconView:EnableButton(enabled)
    end
end

--- @return void
--- @param enabled boolean
function HeroMaterialIconView:EnableRaycast(enabled)
    self.iconView:EnableRaycast(enabled)
end

--- @return void
function HeroMaterialIconView:UpdateView()
    if self.iconView == nil then
        self.iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.heroIconInfo)
    end
    self.iconView:SetIconData(self.iconData)
    self:UpdateNumberMaterial()
end

--- @return void
function HeroMaterialIconView:UpdateNumberMaterial()
    local color
    if self.iconView ~= nil then
        if self.number < self.full then
            self.iconView:SetActiveColorObject(self.iconView.config.heroIcon.gameObject, false)
            color = UIUtils.color7
        else
            self.iconView:SetActiveColorObject(self.iconView.config.heroIcon.gameObject, true)
            color = UIUtils.color2
        end
    end
    self.config.textCountMaterial.text = string.format("<color=#%s>%d/%d</color>", color, self.number, self.full)
end

--- @return void
function HeroMaterialIconView:ReturnPool()
    IconView.ReturnPool(self)
    if self.iconView ~= nil then
        self.iconView:ReturnPool()
        self.iconView = nil
    end
end

return HeroMaterialIconView
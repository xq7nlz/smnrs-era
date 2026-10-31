---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.HeroIconSelectConfig"

--- @class HeroIconSelectView : IconView
HeroIconSelectView = Class(HeroIconSelectView , IconView)

HeroIconSelectView.prefabName = 'hero_icon_select'

function HeroIconSelectView:Ctor()
    IconView.Ctor(self)
    ---@type HeroIconView
    self.heroIconView = nil
end

--- @return void
function HeroIconSelectView:SetPrefabName()
    self.prefabName = 'hero_icon_select'
    self.uiPoolType = UIPoolType.HeroIconSelectView
end

--- @return void
--- @param transform UnityEngine_Transform
function HeroIconSelectView:SetConfig(transform)
    assert(transform)
    --- @type HeroIconSelectConfig
    ---@type HeroIconSelectConfig
    self.config = UIBaseConfig(transform)
    self:CheckHeroIconView()
end

--- @return void
function HeroIconSelectView:CheckHeroIconView()
    if self.heroIconView == nil then
        self.heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.transform)
        self.heroIconView.config.transform:SetAsFirstSibling()
    end
end

--- @return void
--- @param iconData IconData
function HeroIconSelectView:SetIconData(iconData)
    self:CheckHeroIconView()
    self.heroIconView:SetIconData(iconData)
end

--- @return void
---@param func function
function HeroIconSelectView:AddListener(func)
    if self.heroIconView ~= nil then
        self.heroIconView:AddListener(func)
    end
end

--- @return void
function HeroIconSelectView:RemoveAllListeners()
    if self.heroIconView ~= nil then
        self.heroIconView:RemoveAllListeners()
    end
end

--- @return void
function HeroIconSelectView:ReturnPool()
    IconView.ReturnPool(self)
    if self.heroIconView ~= nil then
        self.heroIconView:ReturnPool()
        self.heroIconView = nil
    end
end

--- @return void
function HeroIconSelectView:Show()
    self:SetRelease(true)
    self.config.gameObject:SetActive(true)
end

--- @return void
--- @param isRelease boolean
function HeroIconSelectView:SetRelease(isRelease)
    if isRelease then
        self.config.mask:SetActive(false)
    else
        self.config.mask:SetActive(true)
    end
end

return HeroIconSelectView
---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.DungeonHeroIconConfig"
--- @class DungeonHeroIconView : IconView
DungeonHeroIconView = Class(DungeonHeroIconView, IconView)

--- @return void
--- @param transform UnityEngine_RectTransform
function DungeonHeroIconView:Ctor(transform)
    --- @type DungeonHeroIconConfig
    self.config = nil

    IconView.Ctor(self, transform)
end

function DungeonHeroIconView:SetPrefabName()
    self.prefabName = 'dungeon_hero_icon_view'
    self.uiPoolType = UIPoolType.DungeonHeroIconView
end

--- @param transform UnityEngine_RectTransform
function DungeonHeroIconView:SetConfig(transform)
    ---@type DungeonHeroIconConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param iconData DungeonBindingHeroInBound
function DungeonHeroIconView:SetIconData(iconData)
    self.iconData = iconData
    self.heroResource = HeroIconData.CreateByHeroResource(iconData.heroResource)
    self:UpdateView()
end

function DungeonHeroIconView:UpdateView()
    self:SetActiveColor(self.iconData:IsAlive())
    self:UpdateIconView()
    self:UpdateBarView()
    if self.iconData:IsAlive() == false then
        self:SetHeroDie()
    end
end

function DungeonHeroIconView:UpdateIconView()
    if self.heroResource.skinId ~= nil and self.heroResource.skinId > 0 then
        self.config.heroIcon.sprite = ResourceLoadUtils.LoadSkinIcon(self.heroResource.skinId)
    else
        self.config.heroIcon.sprite = ResourceLoadUtils.LoadHeroCardsIcon(self.heroResource.heroId,
                ClientConfigUtils.GetSkinLevelByStar(self.heroResource.heroId, self.heroResource.star))
    end
    UIUtils.FillSizeHeroView(self.config.heroIcon)
    self.config.factionIcon.sprite = ResourceLoadUtils.LoadFactionIcon(self.heroResource.faction)
    self.config.textLevel.text = tostring(self.heroResource.level)
end

function DungeonHeroIconView:UpdateBarView()
    self.config.rectHp:SetSizeWithCurrentAnchors(U_Rect_Axis.Horizontal, self.iconData.hpPercent * 149)
    self.config.rectPower:SetSizeWithCurrentAnchors(U_Rect_Axis.Horizontal, self.iconData.power / HeroConstants.MAX_HERO_POWER * 152)
end

function DungeonHeroIconView:SetHeroDie()
    self:SetActiveColor(false)
    self.config.imgDark.enabled = false
end

function DungeonHeroIconView:GetYPos()
    return self.config.transform.parent.localPosition.y
end

--- @return void
--- @param func function
function DungeonHeroIconView:AddListener(func)
    self:RemoveAllListeners()
    self:EnableButton(true)
    self.config.buttonHero.onClick:AddListener(func)
end

--- @return void
function DungeonHeroIconView:RemoveAllListeners()
    self:EnableButton(false)
    self.config.buttonHero.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function DungeonHeroIconView:EnableButton(enabled)
    UIUtils.SetInteractableButton(self.config.buttonHero, enabled)
end

--- @return void
--- @param isSelected boolean
function DungeonHeroIconView:SetSelected(isSelected)
    self.config.imgDark.enabled = not isSelected
    self.config.imgLight.enabled = isSelected
    self.config.transform.parent.localScale = isSelected and U_Vector3.one * 1.1 or U_Vector3.one
    --self:EnableButton(not isSelected)
end

function DungeonHeroIconView:SetAsLastSibling()
    self.config.transform.parent:SetAsLastSibling()
end

function DungeonHeroIconView:SetSibling()
    self.config.transform.parent:SetSiblingIndex(5 - self.iconData.index)
end

--- @param isActive boolean
function DungeonHeroIconView:SetActiveColor(isActive)
    UIUtils.SetActiveColor(self.config.transform.gameObject, isActive)
end

return DungeonHeroIconView

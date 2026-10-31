--- @class HeroSummonBaseIconView : IconView
HeroSummonBaseIconView = Class(HeroSummonBaseIconView, IconView)

function HeroSummonBaseIconView:Ctor()
    --- @type HeroIconView
    self.heroIconView = nil
    --- @type UnityEngine_GameObject
    self.effectTop = nil
    --- @type UnityEngine_GameObject
    self.effectBottom = nil
    IconView.Ctor(self)
end

--- @return void
function HeroSummonBaseIconView:SetPrefabName()
    self.prefabName = 'root_info'
    self.uiPoolType = UIPoolType.HeroSummonBaseIconView
end

--- @return void
--- @param transform UnityEngine_RectTransform
function HeroSummonBaseIconView:SetConfig(transform)
    --- @type {transform, gameObject}
    self.config = {}
    self.config.transform = transform
    self.config.gameObject = transform.gameObject
end

--- @return void
--- @param {index, heroIconData}
function HeroSummonBaseIconView:SetIconData(iconData)
    self.iconData = iconData
    self:UpdateView()
end

--- @return void
--- @param func function
function HeroSummonBaseIconView:AddListener(func)
    assert(func)
    self.heroIconView:AddListener(func)
end

--- @return void
function HeroSummonBaseIconView:Show()
    IconView.Show(self)
    self.heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.transform)
    self.heroIconView:EnableButton(true)
end

--- @return void
function HeroSummonBaseIconView:UpdateView()
    self:SetHeroIcon()
    self:_SetSpecialEffect()
end

--- @return void
function HeroSummonBaseIconView:SetHeroIcon()
    self.heroIconView:SetIconData(self.iconData.heroIconData)

    --- @type UnityEngine_Transform
    local icon = self.heroIconView.config.transform

    -- add effect when show icon
    local fxCardGlow = SmartPool.Instance:SpawnUIEffectPool(EffectPoolType.SummonCardGlow, icon)
    Coroutine.start(function()
        coroutine.waitforseconds(1)
        SmartPool.Instance:DespawnUIEffectPool(EffectPoolType.SummonCardGlow, fxCardGlow)
    end)

    -- set init position
    icon.localPosition = U_Vector3(-700 - (10 - self.iconData.index) * 150, 0, 0)

    -- move icon to view
    DOTweenUtils.DOLocalMoveX(icon, 0, 0.4 + self.iconData.index * 0.05, U_Ease.OutBack)
end

--- @return void
function HeroSummonBaseIconView:_SetSpecialEffect()
    self.heroIconView:ActiveEffectHeroIcon(false)
    self.heroIconView:ActiveEffectHeroIconTierA(false)
    if self.iconData.heroIconData.star >= 5 then
        local heroTier = ResourceMgr.GetHeroesConfig():GetHeroTier():GetHeroTier(self.iconData.heroIconData.heroId)
        if heroTier > 5 then
            self.heroIconView:ActiveEffectHeroIconTierA(true)
        else
            self.heroIconView:ActiveEffectHeroIcon(true)
        end
    end
end

--- @return void
function HeroSummonBaseIconView:ShowInfo()
    --- do nothing
end

--- @return void
--- @param isEnabled boolean
function HeroSummonBaseIconView:EnableButton(isEnabled)
    self.heroIconView:EnableButton(isEnabled)
end

--- @return void
function HeroSummonBaseIconView:ReturnPool()
    IconView.ReturnPool(self)
    self.heroIconView:ReturnPool()
    self.heroIconView = nil

end

return HeroSummonBaseIconView

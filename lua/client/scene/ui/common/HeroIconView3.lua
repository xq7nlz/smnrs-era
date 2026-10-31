--- @class HeroIconView3 : HeroIconView
HeroIconView3 = Class(HeroIconView3, HeroIconView)

--- @return void
--- @param transform UnityEngine_RectTransform
function HeroIconView3:Ctor(transform)
    --- @type HeroIcon2Config
    self.config = nil
    HeroIconView.Ctor(self, transform)
end

--- @return void
--- @param id number
function HeroIconView:_SetHeroIconById(id, star, skinId)
    if ClientConfigUtils.IsFragmentRedBorder(id) then

        local sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.heroFragmentByStars, id)
        if sprite ~= nil then
            self.config.heroIcon.sprite = sprite
        else
            self.config.heroIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.heroFragmentByStars, 6)
        end
        self:ActiveEffectPool(EffectPoolType.HeroInfoFire, true, nil, nil, self.config.fxHeroIcon)
    elseif id == nil or id < HeroConstants.FACTION_HERO_ID_DELTA then
        local index = math.min(star, 5)
        self.config.heroIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.heroFragmentByStars, index)
    elseif skinId ~= nil and skinId > 0 then
        self.config.heroIcon.sprite = ResourceLoadUtils.LoadSkinIcon(skinId)
    else
        self:_SetHeroIcon(id, star)
    end
end

return HeroIconView3
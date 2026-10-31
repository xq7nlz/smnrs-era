--- @class HeroCardItemView : HeroIconView
HeroCardItemView = Class(HeroCardItemView, HeroIconView)

--- @return void
function HeroCardItemView:Ctor()
    HeroIconView.Ctor(self)
end

--- @return void
function HeroCardItemView:SetPrefabName()
    self.prefabName = 'hero_card_item'
    self.uiPoolType = UIPoolType.HeroCardItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function HeroCardItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type HeroCardItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param iconData HeroIconData
function HeroCardItemView:SetIconData(iconData, noti)
    assert(iconData)
    HeroIconView.SetIconData(self, iconData)
    self.config.textName.text = LanguageUtils.LocalizeNameHero(iconData.heroId)
    self.config.noti:SetActive(noti == true)
end

--- @return void
function HeroCardItemView:UpdateViewHero()
    self:_SetHeroCardBorder()
    self:_SetFactionById(self.iconData.faction)
    self:_SetHeroIconById(self.iconData.heroId, self.iconData.star, self.iconData.skinId)
    self:_SetTextLevel(self.iconData.level)
    self:_SetStar(self.iconData.star)
    self:_SetQuantity(self.iconData.quantity)
    self:_SetFrameById(1)
    if self.config.fragmentIcon ~= nil then
        self.config.fragmentIcon.gameObject:SetActive(false)
    end
end

function HeroCardItemView:_SetHeroIcon(id, star)
    self.config.heroIcon.sprite = ResourceLoadUtils.LoadHeroCardsIcon(id, star)
end

function HeroCardItemView:_SetHeroCardBorder()
    local heroTier = ResourceMgr.GetHeroesConfig():GetHeroTier():GetHeroTier(self.iconData.heroId)
    --- @type UnityEngine_Sprite
    local borderSprite
    --- @type UnityEngine_Sprite
    local iconRankSprite
    local spriteName = "border_large_new"
    local iconRankSpriteName = "icon_border"

    if heroTier ~= nil and heroTier > 3 then
        spriteName = string.format("%s_%s", spriteName, heroTier)
        iconRankSpriteName = string.format("%s_%s", iconRankSpriteName, heroTier)
    else
        heroTier = 3
        spriteName = string.format("%s_%s", spriteName, heroTier)
        iconRankSpriteName = string.format("%s_%s", iconRankSpriteName, heroTier)
    end

    borderSprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconHeroCardBorder, spriteName)
    iconRankSprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconHeroCardBorder, iconRankSpriteName)
    self.config.frame.sprite = borderSprite
    self.config.iconRank.sprite = iconRankSprite
    self.config.iconRank:SetNativeSize()

    if self.iconData.star >= 13 then
        self:ActiveFxHeroCard(true)
    end
end

--- @return void
--- @param star number
function HeroCardItemView:_SetStar(star)
    HeroIconView._SetStar(self, star)
    if star > 13 then
        self:ActiveMultiStarCard(true, star - 13 )
    elseif star == 13 then
        self:ActiveStarCard(true)
    end
end

function HeroCardItemView:ActiveStarCard(isActive)
    self:ActiveEffectPool(EffectPoolType.StarHeroCard, isActive, nil, nil, self.config.starImage.transform)
end

function HeroCardItemView:ActiveMultiStarCard(isActive, number)
    self:ActiveMultiEffectPool(EffectPoolType.StarHeroCard, isActive, nil, nil, self.config.starImage.transform, number)
end

function HeroCardItemView:ActiveFxHeroCard(isActive)
    local effectPoolType
    local faction = self.iconData.faction
    if faction == HeroFactionType.WATER then
        effectPoolType = EffectPoolType.HeroCardWater
    elseif faction == HeroFactionType.FIRE then
        effectPoolType = EffectPoolType.HeroCardFire
    elseif faction == HeroFactionType.ABYSS then
        effectPoolType = EffectPoolType.HeroCardAbyss
    elseif faction == HeroFactionType.NATURE then
        effectPoolType = EffectPoolType.HeroCardNature
    elseif faction == HeroFactionType.LIGHT then
        effectPoolType = EffectPoolType.HeroCardLight
    elseif faction == HeroFactionType.DARK then
        effectPoolType = EffectPoolType.HeroCardDark
    end
    self:ActiveEffectPool(effectPoolType, isActive, nil, nil, self.config.heroIcon.transform)
end

return HeroCardItemView
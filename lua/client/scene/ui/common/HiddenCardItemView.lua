--- @class HiddenCardItemView : MotionIconView
HiddenCardItemView = Class(HiddenCardItemView, MotionIconView)

--- @return void
function HiddenCardItemView:Ctor()
    HeroIconView.Ctor(self)
end

--- @return void
function HiddenCardItemView:SetPrefabName()
    self.prefabName = 'hidden_card_item'
    self.uiPoolType = UIPoolType.HiddenCardItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function HiddenCardItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type HiddenCardItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param iconData HeroIconData
function HiddenCardItemView:SetActiveNotify(noti)
    self.config.noti:SetActive(noti)
end

function HiddenCardItemView:SetCardBorder()
end

function HiddenCardItemView:EnableFrontCard()
end

--- @return void
--- @param boolean
function HiddenCardItemView:SetActiveCompleteBackground(isActive)
    self.config.completeBackground:SetActive(isActive)
end

--- @return void
--- @param listener function
function HiddenCardItemView:AddListener(listener)
    self:EnableButton(true)
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if listener then
            listener()
        end
    end)
end

--- @param UnityEngine_Sprite
function HiddenCardItemView:SetHeroIdData(heroId)
    self.config.cardSlotAnchor.gameObject:SetActive(true)
    self.config.iconCard.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconHeroPuzzleCard, heroId)
    self.config.iconFaction.sprite = ResourceLoadUtils.LoadFactionIcon(ClientConfigUtils.GetFactionIdByHeroId(heroId))
    self.config.bgTextGlow.color = ClientConfigUtils.GetColorGlowByFaction(ClientConfigUtils.GetFactionIdByHeroId(heroId))
    self.config.textHeroName.text = LanguageUtils.LocalizeNameHero(heroId)
end


function HiddenCardItemView:ActiveFxCard(isActive)
    self:ActiveEffectPool(EffectPoolType.HeroCardWater, isActive, nil, nil, self.config.iconCard.transform)
end

--- @return void
function HiddenCardItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
    self.config.cardSlotAnchor.gameObject:SetActive(false)
    self.config.completeBackground:SetActive(false)
    self.config.noti:SetActive(false)
    self.config.iconCard.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconHeroPuzzleCard, -1)
end

--- @return void
function HiddenCardItemView:RemoveAllListeners()
    self:EnableButton(false)
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function HiddenCardItemView:EnableButton(enabled)
    UIUtils.SetInteractableButton(self.config.button, enabled)
end

return HiddenCardItemView
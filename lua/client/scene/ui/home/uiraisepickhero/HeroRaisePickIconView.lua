--- @class HeroRaisePickIconView : HeroIconView
HeroRaisePickIconView = Class(HeroRaisePickIconView, HeroIconView)

HeroRaisePickIconView.STATE = {
    PENTAGRAM = 1,
    RAISE_SLOT = 2,
    NOT_SELECT = 3,
    TRAINING = 4,
    HIDE = 5,
    ANCIENT_TREE = 6,
    SAME_HERO_ID = 7,
}
--- @return void
function HeroRaisePickIconView:Ctor(transform)
    ---@type HeroPickIconInfoConfig
    self.config = nil
    HeroIconView.Ctor(self, transform)
end
--- @return void
function HeroRaisePickIconView:SetPrefabName()
    self.prefabName = 'hero_pick_icon_info'
    self.uiPoolType = UIPoolType.RaiseHeroPickIconView
end
--- @return void
function HeroRaisePickIconView:SetupView(state)
    if state == HeroRaisePickIconView.STATE.PENTAGRAM then
        self:SetPentaGram()
    elseif state == HeroRaisePickIconView.STATE.TRAINING then
        self:SetInTraining()
    elseif state == HeroRaisePickIconView.STATE.ANCIENT_TREE then
        self:SetInAncient()
    elseif state == HeroRaisePickIconView.STATE.SAME_HERO_ID then
        self:SetTheSameHeroId()
    elseif state == HeroRaisePickIconView.STATE.RAISE_SLOT then
        self:SetStateRaiseSlot()
    elseif state == HeroRaisePickIconView.STATE.NOT_SELECT then
        self:SetNotSelect()
    elseif state == HeroRaisePickIconView.STATE.HIDE then
        self:SetHideSlot()
    else
        self:SetNotSelect()
    end
end

function HeroRaisePickIconView:SetPentaGram()
    self.config.hide.gameObject:SetActive(true)
    self:ActiveMaskSelect(false)
    self.config.xIcon.gameObject:SetActive(true)
end

function HeroRaisePickIconView:SetInTraining()
    self.config.hide.gameObject:SetActive(true)
    self:ActiveMaskSelect(false)
    self.config.xIcon.gameObject:SetActive(true)
end

function HeroRaisePickIconView:SetInAncient()
    self.config.hide.gameObject:SetActive(true)
    self:ActiveMaskSelect(false)
    self.config.xIcon.gameObject:SetActive(true)
end

function HeroRaisePickIconView:SetTheSameHeroId()
    self.config.hide.gameObject:SetActive(true)
    self:ActiveMaskSelect(false)
    self.config.xIcon.gameObject:SetActive(true)
end

function HeroRaisePickIconView:SetStateRaiseSlot()
    self.config.hide.gameObject:SetActive(false)
    self:ActiveMaskSelect(true)
    self.config.xIcon.gameObject:SetActive(false)
end

function HeroRaisePickIconView:SetHideSlot()
    self.config.hide.gameObject:SetActive(false)
    self:ActiveMaskSelect(false)
    self.config.xIcon.gameObject:SetActive(false)
end

function HeroRaisePickIconView:SetNotSelect()
    self.config.hide.gameObject:SetActive(false)
    self:ActiveMaskSelect(false)
    self.config.xIcon.gameObject:SetActive(false)
end

return HeroRaisePickIconView
require "lua.client.scene.ui.home.uiFormation2.heroSlotWorldFormation.HeroSlotWorldFormation"
--- @class MidAutumnHeroSlotWorldFormation : HeroSlotWorldFormation
MidAutumnHeroSlotWorldFormation = Class(MidAutumnHeroSlotWorldFormation,HeroSlotWorldFormation)

--- @param isEnable boolean
function MidAutumnHeroSlotWorldFormation:DisableRemoveButton()
    self.config.buttonRemove.gameObject:SetActive(false)
end

return MidAutumnHeroSlotWorldFormation
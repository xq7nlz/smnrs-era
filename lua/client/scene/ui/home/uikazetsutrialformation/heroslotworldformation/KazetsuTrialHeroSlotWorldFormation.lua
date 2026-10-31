require "lua.client.scene.ui.home.uiFormation2.heroSlotWorldFormation.HeroSlotWorldFormation"
--- @class KazetsuTrialHeroSlotWorldFormation : HeroSlotWorldFormation
KazetsuTrialHeroSlotWorldFormation = Class(KazetsuTrialHeroSlotWorldFormation,HeroSlotWorldFormation)

--- @param isEnable boolean
function KazetsuTrialHeroSlotWorldFormation:DisableRemoveButton()
    self.config.buttonRemove.gameObject:SetActive(false)
end

return KazetsuTrialHeroSlotWorldFormation
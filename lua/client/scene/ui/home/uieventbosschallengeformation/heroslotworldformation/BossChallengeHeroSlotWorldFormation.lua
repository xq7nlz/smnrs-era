require "lua.client.scene.ui.home.uiFormation2.heroSlotWorldFormation.HeroSlotWorldFormation"
--- @class BossChallengeHeroSlotWorldFormation : HeroSlotWorldFormation
BossChallengeHeroSlotWorldFormation = Class(BossChallengeHeroSlotWorldFormation,HeroSlotWorldFormation)

--- @param isEnable boolean
function BossChallengeHeroSlotWorldFormation:DisableRemoveButton()
    self.config.buttonRemove.gameObject:SetActive(false)
end

return BossChallengeHeroSlotWorldFormation
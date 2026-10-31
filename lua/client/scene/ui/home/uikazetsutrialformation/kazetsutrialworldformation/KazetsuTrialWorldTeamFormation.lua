require "lua.client.scene.ui.home.uiFormation2.heroSlotWorldFormation.HeroSlotWorldFormation"

--- @class KazetsuTrialWorldTeamFormation : WorldTeamFormation
KazetsuTrialWorldTeamFormation = Class(KazetsuTrialWorldTeamFormation,WorldTeamFormation)


--- @param worldFormation WorldFormation
--- @param isAttackerTeam boolean
function KazetsuTrialWorldTeamFormation:Ctor(worldFormation, isAttackerTeam)
    WorldTeamFormation.Ctor(self,worldFormation,isAttackerTeam)
    self.heroSlotWorldFormationType = UIPoolType.HeroSlotWorldFormation
end


--- @param selectedSlot {isFrontLine, positionId}
function KazetsuTrialWorldTeamFormation:EnableSwapOnOtherSlot(selectedSlot)
    for _, v in pairs(self.frontLineDict:GetItems()) do
        v:EnableBtnSelect(false)
        v:EnableBtnSwap(true)
    end
    for _, v in pairs(self.backLineDict:GetItems()) do
        v:EnableBtnSelect(false)
        v:EnableBtnSwap(true)
    end
    local slot = self:GetSlotByPosition(selectedSlot.isFrontLine, selectedSlot.positionId)
    slot:EnableBtnSwap(false)
    slot:EnableBtnRemove(true)
    if slot.heroResource.heroId == HeroConstants.KAZETSU_HERO_ID then
        slot:DisableRemoveButton()
    end
end

--- @return KazetsuTrialHeroSlotWorldFormation
--- @param isFrontLine boolean
--- @param positionId number
function KazetsuTrialWorldTeamFormation:GetSlotByPosition(isFrontLine, positionId)
    if isFrontLine == true then
        return self.frontLineDict:Get(positionId)
    else
        return self.backLineDict:Get(positionId)
    end
end

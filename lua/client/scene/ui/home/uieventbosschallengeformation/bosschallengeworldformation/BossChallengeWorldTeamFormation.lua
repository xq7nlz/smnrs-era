require "lua.client.scene.ui.home.uiFormation2.heroSlotWorldFormation.HeroSlotWorldFormation"

--- @class BossChallengeWorldTeamFormation : WorldTeamFormation
BossChallengeWorldTeamFormation = Class(BossChallengeWorldTeamFormation,WorldTeamFormation)


--- @param worldFormation WorldFormation
--- @param isAttackerTeam boolean
function BossChallengeWorldTeamFormation:Ctor(worldFormation, isAttackerTeam)
    WorldTeamFormation.Ctor(self,worldFormation,isAttackerTeam)
    self.heroSlotWorldFormationType = UIPoolType.HeroSlotWorldFormation
end


--- @param selectedSlot {isFrontLine, positionId}
function BossChallengeWorldTeamFormation:EnableSwapOnOtherSlot(selectedSlot)
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
end

--- @return BossChallengeHeroSlotWorldFormation
--- @param isFrontLine boolean
--- @param positionId number
function BossChallengeWorldTeamFormation:GetSlotByPosition(isFrontLine, positionId)
    if isFrontLine == true then
        return self.frontLineDict:Get(positionId)
    else
        return self.backLineDict:Get(positionId)
    end
end

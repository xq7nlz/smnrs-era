require "lua.client.scene.ui.home.uiFormation2.heroSlotWorldFormation.HeroSlotWorldFormation"

--- @class MidAutumnWorldTeamFormation : WorldTeamFormation
MidAutumnWorldTeamFormation = Class(MidAutumnWorldTeamFormation,WorldTeamFormation)


--- @param worldFormation WorldFormation
--- @param isAttackerTeam boolean
function MidAutumnWorldTeamFormation:Ctor(worldFormation, isAttackerTeam)
    WorldTeamFormation.Ctor(self,worldFormation,isAttackerTeam)
    self.heroSlotWorldFormationType = UIPoolType.HeroSlotWorldFormation
end


--- @param selectedSlot {isFrontLine, positionId}
function MidAutumnWorldTeamFormation:EnableSwapOnOtherSlot(selectedSlot)

end

--- @return KazetsuTrialHeroSlotWorldFormation
--- @param isFrontLine boolean
--- @param positionId number
function MidAutumnWorldTeamFormation:GetSlotByPosition(isFrontLine, positionId)
    if isFrontLine == true then
        return self.frontLineDict:Get(positionId)
    else
        return self.backLineDict:Get(positionId)
    end
end

--- @param heroResource HeroResource
--- @param enableBtnChange boolean
function MidAutumnWorldTeamFormation:ShowSummoner(heroResource, enableBtnChange)
    if heroResource == nil then
        return
    end
    if self.summonerSlot == nil then
        self.summonerSlot = self:GetMoreHeroWorldSlot()
        self.summonerSlot:EnableTextSlot(false)
        self.summonerSlot:EnableBuffStat(false)

        self.summonerSlot.config.buttonSwap.onClick:RemoveAllListeners()
        self.summonerSlot.config.buttonRemove.onClick:RemoveAllListeners()

        local summonerPos = FormationPositionConfig.GetSummonerPosition(self.isAttackerTeam)
        self.summonerSlot:SetPosition(summonerPos, nil, nil)
    end
    if heroResource ~= nil then
        self.summonerSlot:SetSummonerSlot(heroResource)
        self.summonerSlot:EnableBtnChange(false)
    else
        self.summonerSlot:OnRemoveSlot()
    end
end

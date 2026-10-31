--- @class ClientHero30015ActiveSkill : BaseSkillShow
ClientHero30015ActiveSkill = Class(ClientHero30015ActiveSkill, BaseSkillShow)

function ClientHero30015ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(18, function()
        local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
        self:AccostTarget(clientTargetHero, nil, nil, nil, 16 / ClientConfigUtils.FPS)
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero30015ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero30015ActiveSkill:OnEndAnimation()
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        BaseSkillShow.OnEndAnimation(self)
        return
    end
    if self.clientHero.isPlayingDead == true then
        BaseSkillShow.OnEndTurn(self)
        return
    end

    self.clientHero:PlayIdleAnimation()
    self:DoMovePosition(self.clientHero.originPosition, function()
        BaseSkillShow.OnEndAnimation(self)
        BaseSkillShow.OnEndTurn(self)
    end)
end

function ClientHero30015ActiveSkill:OnCompleteActionTurn()

end
--- @class ClientHero10012ActiveSkill : BaseSkillShow
ClientHero10012ActiveSkill = Class(ClientHero10012ActiveSkill, BaseSkillShow)

function ClientHero10012ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(30, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero10012ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero10012ActiveSkill:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, nil, nil, nil, 5.0 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end

function ClientHero10012ActiveSkill:OnEndAnimation()
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

function ClientHero10012ActiveSkill:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
end

function ClientHero10012ActiveSkill:OnCompleteActionTurn()

end
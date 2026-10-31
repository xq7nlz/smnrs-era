--- @class ClientHero50009ActiveSkill : BaseSkillShow
ClientHero50009ActiveSkill = Class(ClientHero50009ActiveSkill, BaseSkillShow)

function ClientHero50009ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(30, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero50009ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero50009ActiveSkill:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, nil, nil, nil, 5 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end

function ClientHero50009ActiveSkill:OnEndAnimation()
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

function ClientHero50009ActiveSkill:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
end

function ClientHero50009ActiveSkill:OnCompleteActionTurn()

end
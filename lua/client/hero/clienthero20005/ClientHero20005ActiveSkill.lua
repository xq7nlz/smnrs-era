--- @class ClientHero20005ActiveSkill : BaseSkillShow
ClientHero20005ActiveSkill = Class(ClientHero20005ActiveSkill, BaseSkillShow)

function ClientHero20005ActiveSkill:SetOffsetAccostX()
    BaseSkillShow.SetOffsetAccostX(self, 2)
end

function ClientHero20005ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(32, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero20005ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero20005ActiveSkill:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, nil, nil, nil, 12.0 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end

function ClientHero20005ActiveSkill:OnEndAnimation()
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

function ClientHero20005ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero20005ActiveSkill:OnCompleteActionTurn()

end
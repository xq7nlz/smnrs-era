--- @class ClientHero20010MeleeAttack : BaseSkillShow
ClientHero20010MeleeAttack = Class(ClientHero20010MeleeAttack, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero20010MeleeAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

function ClientHero20010MeleeAttack:DeliverSetFrameAction()
    self:AddFrameAction(10, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero20010MeleeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero20010MeleeAttack:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, nil, nil, nil, 5 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end

function ClientHero20010MeleeAttack:OnEndAnimation()
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

function ClientHero20010MeleeAttack:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
end

function ClientHero20010MeleeAttack:OnCompleteActionTurn()

end

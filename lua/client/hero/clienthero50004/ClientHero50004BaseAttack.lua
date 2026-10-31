--- @class ClientHero50004BaseAttack : BaseSkillShow
ClientHero50004BaseAttack = Class(ClientHero50004BaseAttack, BaseSkillShow)

function ClientHero50004BaseAttack:DeliverSetFrameAction()
    local frameActionStart = 9
    if (self.clientHero.skinId == 50004001) then
        frameActionStart = 13
    end
    self:AddFrameAction(frameActionStart, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero50004BaseAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero50004BaseAttack:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, nil, nil, nil, 19.0 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end

function ClientHero50004BaseAttack:OnEndAnimation()
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

function ClientHero50004BaseAttack:OnCompleteActionTurn()

end
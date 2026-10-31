--- @class ClientHero20005BaseAttack : BaseSkillShow
ClientHero20005BaseAttack = Class(ClientHero20005BaseAttack, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero20005BaseAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

function ClientHero20005BaseAttack:DeliverSetFrameAction()
    self:AddFrameAction(6, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero20005BaseAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero20005BaseAttack:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, nil, nil, nil, 10.0 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end

function ClientHero20005BaseAttack:OnEndAnimation()
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        BaseSkillShow.OnEndAnimation(self)
        return
    end
    if self.clientHero.isPlayingDead == true then
        BaseSkillShow.OnEndTurn(self)
        return
    end

    self:DoMovePosition(self.clientHero.originPosition, function()
        BaseSkillShow.OnEndAnimation(self)
        BaseSkillShow.OnEndTurn(self)
    end)
end

function ClientHero20005BaseAttack:OnCompleteActionTurn()

end
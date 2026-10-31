--- @class ClientHero40015BaseAttack : BaseSkillShow
ClientHero40015BaseAttack = Class(ClientHero40015BaseAttack, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero40015BaseAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

function ClientHero40015BaseAttack:SetOffsetAccostX()
    BaseSkillShow.SetOffsetAccostX(self, 1.5)
end

function ClientHero40015BaseAttack:DeliverSetFrameAction()
    self:AddFrameAction(10, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero40015BaseAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero40015BaseAttack:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, nil, nil, nil, 0.17, DOTweenEase.OutSine)
end

function ClientHero40015BaseAttack:OnEndAnimation()
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

function ClientHero40015BaseAttack:OnCompleteActionTurn()

end
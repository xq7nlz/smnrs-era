--- @class ClientHero20004BaseAttack : BaseSkillShow
ClientHero20004BaseAttack = Class(ClientHero20004BaseAttack, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero20004BaseAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

function ClientHero20004BaseAttack:DeliverSetFrameAction()
    self:AddFrameAction(15, function()
        self:StartAccost()
    end)
    self:AddFrameAction(30, function()
        self:StartBackward()
    end)
end

function ClientHero20004BaseAttack:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, nil, nil, nil, 3.0 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end

function ClientHero20004BaseAttack:StartBackward()
    self:DoMovePosition(self.clientHero.originPosition, nil, 5 / ClientConfigUtils.FPS)
end

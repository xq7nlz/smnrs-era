--- @class ClientHero60002BaseAttack : BaseSkillShow
ClientHero60002BaseAttack = Class(ClientHero60002BaseAttack, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero60002BaseAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

function ClientHero60002BaseAttack:DeliverSetFrameAction()
    self:AddFrameAction(12, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero60002BaseAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero60002BaseAttack:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, nil, nil, nil, 9.0 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end

function ClientHero60002BaseAttack:OnEndAnimation()
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

function ClientHero60002BaseAttack:OnCompleteActionTurn()

end
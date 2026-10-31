--- @class ClientHero60015BaseAttack : BaseSkillShow
ClientHero60015BaseAttack = Class(ClientHero60015BaseAttack, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero60015BaseAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

function ClientHero60015BaseAttack:DeliverSetFrameAction()
    self:AddFrameAction(22, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero60015BaseAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero60015BaseAttack:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, nil, self.offsetAccostX + 0.5, nil, 4 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end

function ClientHero60015BaseAttack:OnEndAnimation()
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

function ClientHero60015BaseAttack:OnCompleteActionTurn()

end
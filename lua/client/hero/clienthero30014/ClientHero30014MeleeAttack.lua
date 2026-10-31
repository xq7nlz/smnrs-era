--- @class ClientHero30014MeleeAttack : BaseSkillShow
ClientHero30014MeleeAttack = Class(ClientHero30014MeleeAttack, BaseSkillShow)

function ClientHero30014MeleeAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

function ClientHero30014MeleeAttack:DeliverCtor()
    self.fxImpactName = ClientConfigUtils.EFFECT_IMPACT_MELEE
end

function ClientHero30014MeleeAttack:DeliverSetFrameAction()
    self:AddFrameAction(12, function()
        local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
        self:AccostTarget(clientTargetHero, nil, nil, nil, 8.0 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero30014MeleeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero30014MeleeAttack:OnEndAnimation()
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        BaseSkillShow.OnEndAnimation(self)
        return
    end

    self:DoMovePosition(self.clientHero.originPosition, function()
        BaseSkillShow.OnEndAnimation(self)
        self:OnEndTurn()
    end)
end

function ClientHero30014MeleeAttack:OnCompleteActionTurn()

end
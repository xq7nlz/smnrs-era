--- @class ClientHero60008BaseAttack : BaseSkillShow
ClientHero60008BaseAttack = Class(ClientHero60008BaseAttack, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero60008BaseAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

function ClientHero60008BaseAttack:DeliverSetFrameAction()
    self:AddFrameAction(25, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero60008BaseAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero60008BaseAttack:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    local targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        targetPosition.x = targetPosition.x - 1.5
    else
        targetPosition.x = targetPosition.x + 1.5
    end
    self:AccostTarget(clientTargetHero, nil, nil, nil, 2 / ClientConfigUtils.FPS)
end

function ClientHero60008BaseAttack:OnEndAnimation()
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        BaseSkillShow.OnEndAnimation(self)
        return
    end
    if self.clientHero.isPlayingDead == true then
        self:OnEndTurn()
        return
    end
    self:DoMovePosition(self.clientHero.originPosition, function()
        BaseSkillShow.OnEndAnimation(self)
        self:OnEndTurn()
    end)
end

function ClientHero60008BaseAttack:OnCompleteActionTurn()

end
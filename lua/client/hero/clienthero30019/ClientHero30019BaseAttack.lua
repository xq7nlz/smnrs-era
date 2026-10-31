--- @class ClientHero30019BaseAttack : BaseSkillShow
ClientHero30019BaseAttack = Class(ClientHero30019BaseAttack, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero30019BaseAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

function ClientHero30019BaseAttack:DeliverSetFrameAction()
    self:AddFrameAction(12, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero30019BaseAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero30019BaseAttack:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    local targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    targetPosition.y = targetPosition.y - ClientConfigUtils.OFFSET_ACCOST_Y
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        targetPosition.x = targetPosition.x - ClientConfigUtils.OFFSET_ACCOST_X
    else
        targetPosition.x = targetPosition.x + ClientConfigUtils.OFFSET_ACCOST_X
    end
    targetPosition.y = targetPosition.y - 0.05
    self:DoMovePosition(targetPosition, nil, 15 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end

function ClientHero30019BaseAttack:OnEndAnimation()
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

function ClientHero30019BaseAttack:OnCompleteActionTurn()

end
--- @class ClientHero10017BaseAttack : BaseSkillShow
ClientHero10017BaseAttack = Class(ClientHero10017BaseAttack, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero10017BaseAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

function ClientHero10017BaseAttack:DeliverSetFrameAction()
    self:AddFrameAction(10, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero10017BaseAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero10017BaseAttack:StartAccost()
    --- @type ClientHero
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    local targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    targetPosition.y = targetPosition.y - ClientConfigUtils.OFFSET_ACCOST_Y
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        targetPosition.x = targetPosition.x - ClientConfigUtils.OFFSET_ACCOST_X
    else
        targetPosition.x = targetPosition.x + ClientConfigUtils.OFFSET_ACCOST_X
    end
    targetPosition.y = targetPosition.y - 0.05
    targetPosition.z = 0
    self:DoMovePosition(targetPosition, nil, 18 / ClientConfigUtils.FPS, DOTweenEase.OutSine)
end

function ClientHero10017BaseAttack:OnEndAnimation()
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

function ClientHero10017BaseAttack:OnCompleteActionTurn()

end
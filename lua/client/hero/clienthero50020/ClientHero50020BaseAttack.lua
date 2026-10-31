--- @class ClientHero50020BaseAttack : BaseSkillShow
ClientHero50020BaseAttack = Class(ClientHero50020BaseAttack, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero50020BaseAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

function ClientHero50020BaseAttack:DeliverSetFrameAction()
    self:AddFrameAction(10, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero50020BaseAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero50020BaseAttack:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    local _targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    _targetPosition.y = _targetPosition.y - ClientConfigUtils.OFFSET_ACCOST_Y
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        _targetPosition.x = _targetPosition.x - ClientConfigUtils.OFFSET_ACCOST_X
    else
        _targetPosition.x = _targetPosition.x + ClientConfigUtils.OFFSET_ACCOST_X
    end
    self:DoMovePosition(U_Vector3(_targetPosition.x, _targetPosition.y - 0.05, 0), nil, 0.86)
end

function ClientHero50020BaseAttack:OnEndAnimation()
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

function ClientHero50020BaseAttack:OnCompleteActionTurn()

end
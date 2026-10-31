--- @class ClientHero20016BaseAttack : BaseSkillShow
ClientHero20016BaseAttack = Class(ClientHero20016BaseAttack, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero20016BaseAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

function ClientHero20016BaseAttack:DeliverSetFrameAction()
    self:AddFrameAction(10, function()
        self:StartAccost()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero20016BaseAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero20016BaseAttack:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    local targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    targetPosition.y = targetPosition.y - ClientConfigUtils.OFFSET_ACCOST_Y
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        targetPosition.x = targetPosition.x - ClientConfigUtils.OFFSET_ACCOST_X
    else
        targetPosition.x = targetPosition.x + ClientConfigUtils.OFFSET_ACCOST_X
    end

    self:DoMovePosition(targetPosition)
end

function ClientHero20016BaseAttack:OnEndAnimation()
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        BaseSkillShow.OnEndAnimation(self)
        return
    end

    self:DoMovePosition(self.clientHero.originPosition, function()
        BaseSkillShow.OnEndAnimation(self)
        BaseSkillShow.OnEndTurn(self)
    end)
end

function ClientHero20016BaseAttack:OnCompleteActionTurn()

end
--- @class ClientHero40026BaseAttack : BaseSkillShow
ClientHero40026BaseAttack = Class(ClientHero40026BaseAttack, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero40026BaseAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

function ClientHero40026BaseAttack:DeliverSetFrameAction()
    self:AddFrameAction(20, function()
        self:Accost()
    end)
    self:AddFrameAction(48, function()
        self:Backward()
    end)
end

function ClientHero40026BaseAttack:Accost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    local targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    targetPosition.y = targetPosition.y - ClientConfigUtils.OFFSET_ACCOST_Y
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        targetPosition.x = targetPosition.x - ClientConfigUtils.OFFSET_ACCOST_X
    else
        targetPosition.x = targetPosition.x + ClientConfigUtils.OFFSET_ACCOST_X
    end

    self.clientHero.clientHeroMovement:SetPosition(targetPosition)
end

function ClientHero40026BaseAttack:Backward()
    self.clientHero.clientHeroMovement:SetPosition(self.clientHero.originPosition)
end

--- @param actionResults List<BaseActionResult>
function ClientHero40026BaseAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end
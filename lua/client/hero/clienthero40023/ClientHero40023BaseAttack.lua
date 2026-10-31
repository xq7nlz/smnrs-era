--- @class ClientHero40023BaseAttack : BaseSkillShow
ClientHero40023BaseAttack = Class(ClientHero40023BaseAttack, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero40023BaseAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

function ClientHero40023BaseAttack:DeliverCtor()
    self.moveBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/D_move")
    self.moveTweener = nil
end

function ClientHero40023BaseAttack:DeliverSetFrameAction()
    self:AddFrameAction(10, function()
        self:StartAccost()
    end)
    self:AddFrameAction(37, function()
        self:StartBackward()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero40023BaseAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.FRONT_BATTLE_LAYER_ID)
end

function ClientHero40023BaseAttack:StartAccost()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    local targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        targetPosition.x = targetPosition.x - 1.5
    else
        targetPosition.x = targetPosition.x + 1.5
    end
    self.moveTweener = self.moveBone:DOMove(targetPosition, 18.0 / ClientConfigUtils.FPS)--:SetEase(self.ease.Linear)
end

function ClientHero40023BaseAttack:StartBackward()
    self.moveTweener = self.moveBone:DOMove(self.clientHero.originPosition, 3.0 / ClientConfigUtils.FPS)
end

function ClientHero40023BaseAttack:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_NORMAL)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero40023BaseAttack:OnCompleteActionTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    self.clientHero:FinishActionTurn()
end

function ClientHero40023BaseAttack:ResetMoveBone()
    if self.moveBone ~= nil then
        self.moveBone.localPosition = U_Vector3.zero
    end
end

function ClientHero40023BaseAttack:BreakSkillAction()
    BaseSkillShow.BreakSkillAction(self)
    ClientConfigUtils.KillTweener(self.moveTweener)
    self:ResetMoveBone()
end
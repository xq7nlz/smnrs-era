--- @class ClientHero50008RangeAttack : BaseRangeAttack
ClientHero50008RangeAttack = Class(ClientHero50008RangeAttack, BaseRangeAttack)

function ClientHero50008RangeAttack:DeliverCtor()
    self.targetAttackBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/TargetAttack")
    self.targetAttackBone.localPosition = U_Vector3(13, 2, 0)
end

--- @param actionResults List<BaseActionResult>
function ClientHero50008RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.FRONT_BATTLE_LAYER_ID)
    local clientTarget = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    local targetPosition = clientTarget.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    self.targetAttackBone.position = targetPosition

    self.clientHero.animation:UpdateLayer(clientTarget.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR).y, 1)
end

function ClientHero50008RangeAttack:OnCompleteActionTurn()
    self.clientHero.animation:UpdateLayer(self.clientHero.originPosition.y)
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    self.clientHero:FinishActionTurn()
end
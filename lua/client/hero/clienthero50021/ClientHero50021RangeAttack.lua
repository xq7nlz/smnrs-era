--- @class ClientHero50021RangeAttack : BaseRangeAttack
ClientHero50021RangeAttack = Class(ClientHero50021RangeAttack, BaseRangeAttack)

function ClientHero50021RangeAttack:DeliverCtor()
    self.targetAttackBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/target_attack")
end

--- @param actionResults List<BaseActionResult>
function ClientHero50021RangeAttack:CastOnTarget(actionResults)
    BaseRangeAttack.CastOnTarget(self, actionResults)

    local target = self.listTargetHero:Get(1)
    local clientTarget = self.clientBattleShowController:GetClientHeroByBaseHero(target)
    local targetPosition = clientTarget.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    self.targetAttackBone.position = targetPosition
end
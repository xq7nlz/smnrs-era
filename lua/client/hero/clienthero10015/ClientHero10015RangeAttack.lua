--- @class ClientHero10015RangeAttack : BaseRangeAttack
ClientHero10015RangeAttack = Class(ClientHero10015RangeAttack, BaseRangeAttack)

function ClientHero10015RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position")
    self.targetAttackBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/target_skill")
    self.targetAttackBone.position = self.clientHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR) + U_Vector3.right * 10
end

--- @param actionResults List<BaseActionResult>
function ClientHero10015RangeAttack:CastOnTarget(actionResults)
    BaseRangeAttack.CastOnTarget(self, actionResults)
    self:DoAnimation()

    local target = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self.targetAttackBone.position = target.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
end

function ClientHero10015RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, nil, self.projectileLaunchPos.position)
end
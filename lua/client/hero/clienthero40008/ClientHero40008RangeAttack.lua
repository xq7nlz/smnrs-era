--- @class ClientHero40008RangeAttack : BaseRangeAttack
ClientHero40008RangeAttack = Class(ClientHero40008RangeAttack, BaseRangeAttack)

function ClientHero40008RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position")
    self.targetBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/Target")
end

--- @param actionResults List<BaseActionResult>
function ClientHero40008RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    local target = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    local targetPosition = target.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    self.targetBone.position = targetPosition
end

function ClientHero40008RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName,
            nil, nil, self.projectileLaunchPos.position)
end
--- @class ClientHero10020RangeAttack : BaseRangeAttack
ClientHero10020RangeAttack = Class(ClientHero10020RangeAttack, BaseRangeAttack)

function ClientHero10020RangeAttack:DeliverCtor()
    self.launchBone = self.clientHero.components:FindChildByPath("Model/launch_position")
    self.targetBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/Target")
end

--- @param actionResults List<BaseActionResult>
function ClientHero10020RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    local target = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self.targetBone.position = target.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
end

function ClientHero10020RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, nil, self.launchBone.position)
end
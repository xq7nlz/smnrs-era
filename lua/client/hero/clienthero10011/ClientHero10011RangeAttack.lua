--- @class ClientHero10011RangeAttack : BaseRangeAttack
ClientHero10011RangeAttack = Class(ClientHero10011RangeAttack, BaseRangeAttack)

function ClientHero10011RangeAttack:DeliverCtor()
    self.launchAnchor = self.clientHero.components:FindChildByPath("Model/launch_position")
    self.boneControl = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/bone_control")
end

function ClientHero10011RangeAttack:CastOnTarget(actionResults)
    BaseRangeAttack.CastOnTarget(self, actionResults)
    self:DoAnimation()
    local targetPosition = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
                               .components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    self.boneControl.position = targetPosition
end

function ClientHero10011RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, nil, self.launchAnchor.position)
end
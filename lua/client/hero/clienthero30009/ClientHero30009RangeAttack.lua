--- @class ClientHero30009RangeAttack : BaseRangeAttack
ClientHero30009RangeAttack = Class(ClientHero30009RangeAttack, BaseRangeAttack)

function ClientHero30009RangeAttack:DeliverCtor()
    self.targetAttack = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/target_attack")
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/bone_hand_laught/launch_position")
end

--- @param actionResults List<BaseActionResult>
function ClientHero30009RangeAttack:CastOnTarget(actionResults)
    BaseRangeAttack.CastOnTarget(self, actionResults)
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self.targetAttack.position = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
end

function ClientHero30009RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, nil, self.projectileLaunchPos.position)
end
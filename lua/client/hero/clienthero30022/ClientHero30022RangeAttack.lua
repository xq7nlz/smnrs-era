--- @class ClientHero30022RangeAttack : BaseRangeAttack
ClientHero30022RangeAttack = Class(ClientHero30022RangeAttack, BaseRangeAttack)

function ClientHero30022RangeAttack:DeliverCtor()
    self.targetAim = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/move_attack")
    self.projectileName = "hero_30022_attack_projectile_" .. self.clientHero.skinName
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/attack_launch_position").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero30022RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    local target = self.listTargetHero:Get(1)
    self.targetAim.transform.position = self.clientBattleShowController:GetClientHeroByBaseHero(target).components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
end

function ClientHero30022RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, ClientConfigUtils.PROJECTILE_FRY_TIME)
end
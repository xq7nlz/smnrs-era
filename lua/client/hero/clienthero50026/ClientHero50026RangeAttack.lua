--- @class ClientHero50026RangeAttack : BaseRangeAttack
ClientHero50026RangeAttack = Class(ClientHero50026RangeAttack, BaseRangeAttack)

function ClientHero50026RangeAttack:DeliverCtor()
    self.targetAim = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/Target_contror")
    self.launchBone = self.clientHero.components:FindChildByPath("Model/launch_position_skill")
end

--- @param actionResults List<BaseActionResult>
function ClientHero50026RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self.targetAim.position = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
end

function ClientHero50026RangeAttack:OnCastEffect()
    self.projectileLaunchPos = self.launchBone.position
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end
--- @class ClientHero20021RangeAttack : BaseRangeAttack
ClientHero20021RangeAttack = Class(ClientHero20021RangeAttack, BaseRangeAttack)

function ClientHero20021RangeAttack:DeliverCtor()
    self.targetAim = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/target_aim")
    self.launchAnchor = self.clientHero.components:FindChildByPath("Model/bone_skin_1_cung")
end

--- @param actionResults List<BaseActionResult>
function ClientHero20021RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self.targetAim.transform.position = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
end

function ClientHero20021RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, nil, self.launchAnchor.position)
end
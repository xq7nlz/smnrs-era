--- @class ClientHero30016RangeAttack : BaseRangeAttack
ClientHero30016RangeAttack = Class(ClientHero30016RangeAttack, BaseRangeAttack)

function ClientHero30016RangeAttack:DeliverCtor()
    self.targetAim = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/target_aim")
end

--- @param actionResults List<BaseActionResult>
function ClientHero30016RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self.targetAim.position = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
end

function ClientHero30016RangeAttack:OnCastEffect()
    --self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end
--- @class ClientHero50014RangeAttack : BaseRangeAttack
ClientHero50014RangeAttack = Class(ClientHero50014RangeAttack, BaseRangeAttack)

function ClientHero50014RangeAttack:DeliverCtor()
    self.targetAim = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/Target")
end

--- @param actionResults List<BaseActionResult>
function ClientHero50014RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self.targetAim.position = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
end

function ClientHero50014RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end
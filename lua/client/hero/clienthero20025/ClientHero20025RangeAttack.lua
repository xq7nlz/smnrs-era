--- @class ClientHero20025RangeAttack : BaseRangeAttack
ClientHero20025RangeAttack = Class(ClientHero20025RangeAttack, BaseRangeAttack)

function ClientHero20025RangeAttack:DeliverCtor()
    self.moveSkill = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/move_skill")
    self.launchBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/fx_bone")
end

--- @param actionResults List<BaseActionResult>
function ClientHero20025RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self.moveSkill.transform.position = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
end

function ClientHero20025RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, nil, self.launchBone.position)
end
--- @class ClientHero60001RangeAttack : BaseRangeAttack
ClientHero60001RangeAttack = Class(ClientHero60001RangeAttack, BaseRangeAttack)

function ClientHero60001RangeAttack:DeliverCtor()
    self.moveSkill = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/move_skill")
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/bone_hand_laught/launch_position")
end

--- @param actionResults List<BaseActionResult>
function ClientHero60001RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self.moveSkill.position = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
end

function ClientHero60001RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, nil, self.projectileLaunchPos.position)
end
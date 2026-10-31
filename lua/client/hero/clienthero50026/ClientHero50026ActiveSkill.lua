--- @class ClientHero50026ActiveSkill : BaseSkillShow
ClientHero50026ActiveSkill = Class(ClientHero50026ActiveSkill, BaseSkillShow)

function ClientHero50026ActiveSkill:DeliverCtor()
    self.targetAim = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/Target_contror")
    self.projectileName = string.format("hero_%d_%s", self.baseHero.id, ClientConfigUtils.DEFAULT_ATTACK_PROJECTILE)
    self.launchBone = self.clientHero.components:FindChildByPath("Model/launch_position_skill")
end

--- @param actionResults List<BaseActionResult>
function ClientHero50026ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self.targetAim.position = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
end

function ClientHero50026ActiveSkill:OnCastEffect()
    self.projectileLaunchPos = self.launchBone.position
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end

function ClientHero50026ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_NORMAL)
    BaseSkillShow.OnTriggerActionResult(self)
end
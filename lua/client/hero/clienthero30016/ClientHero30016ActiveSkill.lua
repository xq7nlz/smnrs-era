--- @class ClientHero30016ActiveSkill : BaseSkillShow
ClientHero30016ActiveSkill = Class(ClientHero30016ActiveSkill, BaseSkillShow)

function ClientHero30016ActiveSkill:DeliverCtor()
    self.projectileName = string.format("hero_%d_%s", self.baseHero.id, ClientConfigUtils.DEFAULT_ATTACK_PROJECTILE)
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/skill_launch_position").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero30016ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero30016ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end

function ClientHero30016ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_NORMAL)
    BaseSkillShow.OnTriggerActionResult(self)
end
--- @class ClientHero50014ActiveSkill : BaseSkillShow
ClientHero50014ActiveSkill = Class(ClientHero50014ActiveSkill, BaseSkillShow)

function ClientHero50014ActiveSkill:DeliverCtor()
    self.projectileName = string.format("hero_%d_%s", self.baseHero.id, ClientConfigUtils.DEFAULT_SKILL_PROJECTILE)
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/skill_launch_position").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero50014ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero50014ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end

function ClientHero50014ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_NORMAL)
    BaseSkillShow.OnTriggerActionResult(self)
end
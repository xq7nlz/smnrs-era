--- @class ClientHero30022ActiveSkill : BaseSkillShow
ClientHero30022ActiveSkill = Class(ClientHero30022ActiveSkill, BaseSkillShow)

function ClientHero30022ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/skill_launch_position").position
    self.projectileName = "hero_30022_attack_projectile_" .. self.clientHero.skinName
end

--- @param actionResults List<BaseActionResult>
function ClientHero30022ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero30022ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end

function ClientHero30022ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end
--- @class ClientHero30023ActiveSkill : BaseSkillShow
ClientHero30023ActiveSkill = Class(ClientHero30023ActiveSkill, BaseSkillShow)

function ClientHero30023ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero30023ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero30023ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, ClientConfigUtils.PROJECTILE_FRY_TIME, ClientConfigUtils.BODY_ANCHOR)
end

function ClientHero30023ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end
--- @class ClientHero40013ActiveSkill : BaseSkillShow
ClientHero40013ActiveSkill = Class(ClientHero40013ActiveSkill, BaseSkillShow)

function ClientHero40013ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero40013ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero40013ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end

function ClientHero40013ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end
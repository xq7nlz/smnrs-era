--- @class ClientHero60013ActiveSkill : BaseSkillShow
ClientHero60013ActiveSkill = Class(ClientHero60013ActiveSkill, BaseSkillShow)

function ClientHero60013ActiveSkill:DeliverCtor()
    self.projectileName = string.format("hero_%d_%s", self.baseHero.id, ClientConfigUtils.DEFAULT_SKILL_PROJECTILE)
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/skill_launch_position").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero60013ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 0.8, 0.3)

end

function ClientHero60013ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end

function ClientHero60013ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end


--- @class ClientHero20013ActiveSkill : BaseSkillShow
ClientHero20013ActiveSkill = Class(ClientHero20013ActiveSkill, BaseSkillShow)

--- @param actionResults List<BaseActionResult>
function ClientHero20013ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero20013ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero20013ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 7/30)
end
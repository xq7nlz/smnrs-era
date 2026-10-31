--- @class ClientHero10014ActiveSkill : BaseSkillShow
ClientHero10014ActiveSkill = Class(ClientHero10014ActiveSkill, BaseSkillShow)

--- @param actionResults List<BaseActionResult>
function ClientHero10014ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero10014ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero10014ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end
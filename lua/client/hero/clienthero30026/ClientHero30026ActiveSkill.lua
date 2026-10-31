--- @class ClientHero30026ActiveSkill : BaseSkillShow
ClientHero30026ActiveSkill = Class(ClientHero30026ActiveSkill, BaseSkillShow)

function ClientHero30026ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero30026ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero30026ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end

function ClientHero30026ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_NORMAL)
    BaseSkillShow.OnTriggerActionResult(self)
end
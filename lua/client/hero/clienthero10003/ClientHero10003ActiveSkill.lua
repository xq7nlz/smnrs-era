--- @class ClientHero10003ActiveSkill : BaseSkillShow
ClientHero10003ActiveSkill = Class(ClientHero10003ActiveSkill, BaseSkillShow)

function ClientHero10003ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_skill").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero10003ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:CastImpactFromConfig()
end

function ClientHero10003ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 20 / ClientConfigUtils.FPS)
end

function ClientHero10003ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_NORMAL)
    self:CastSfxImpactFromConfig()
    self.clientHero:TriggerActionResult()
end
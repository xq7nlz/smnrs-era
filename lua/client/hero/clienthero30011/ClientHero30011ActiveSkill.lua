--- @class ClientHero30011ActiveSkill : BaseSkillShow
ClientHero30011ActiveSkill = Class(ClientHero30011ActiveSkill, BaseSkillShow)

function ClientHero30011ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
end

--- @param actionResults List<BaseActionResult>
function ClientHero30011ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:CastImpactFromConfig()
end

function ClientHero30011ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_NORMAL)

    self:CastSfxImpactFromConfig()
    self.clientHero:TriggerActionResult()
end

function ClientHero30011ActiveSkill:OnCastEffect()
    --self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 2, ClientConfigUtils.FOOT_ANCHOR)
end
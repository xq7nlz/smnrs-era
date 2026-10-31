--- @class ClientHero10024ActiveSkill : BaseSkillShow
ClientHero10024ActiveSkill = Class(ClientHero10024ActiveSkill, BaseSkillShow)

function ClientHero10024ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/skill_launch_position").position
    self.fxImpactName = ClientConfigUtils.EFFECT_IMPACT_RANGE
    self.projectileName = string.format("hero_%d_projectile", self.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero10024ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1, 0.3)

end

function ClientHero10024ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end

function ClientHero10024ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_NORMAL)
    BaseSkillShow.OnTriggerActionResult(self)
    self:CastNewClientImpactOnTargets(AssetType.GeneralBattleEffect, "impact_range")
end

function ClientHero10024ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
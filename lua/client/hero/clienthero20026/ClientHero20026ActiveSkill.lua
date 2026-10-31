--- @class ClientHero20026ActiveSkill : BaseSkillShow
ClientHero20026ActiveSkill = Class(ClientHero20026ActiveSkill, BaseSkillShow)

function ClientHero20026ActiveSkill:DeliverCtor()
    self.fxImpactName = string.format("hero_%d_skill_impact", self.baseHero.id)
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_skill").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero20026ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1, 0.3)

end

function ClientHero20026ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end

function ClientHero20026ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero20026ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
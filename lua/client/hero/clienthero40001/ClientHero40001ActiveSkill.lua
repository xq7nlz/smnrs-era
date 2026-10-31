--- @class ClientHero40001ActiveSkill : BaseSkillShow
ClientHero40001ActiveSkill = Class(ClientHero40001ActiveSkill, BaseSkillShow)

function ClientHero40001ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_skill").position
    self.projectileName = string.format("hero_%d_%s", self.baseHero.id, ClientConfigUtils.DEFAULT_SKILL_PROJECTILE)
end

--- @param actionResults List<BaseActionResult>
function ClientHero40001ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.3)

end

function ClientHero40001ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end

function ClientHero40001ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero40001ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
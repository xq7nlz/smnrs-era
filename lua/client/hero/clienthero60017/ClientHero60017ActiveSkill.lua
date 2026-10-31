--- @class ClientHero60017ActiveSkill : BaseSkillShow
ClientHero60017ActiveSkill = Class(ClientHero60017ActiveSkill, BaseSkillShow)

function ClientHero60017ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
    self.projectileName = string.format("hero_%d_%s_%s", self.baseHero.id, ClientConfigUtils.DEFAULT_SKILL_PROJECTILE, self.clientHero.skinName)
end

--- @param actionResults List<BaseActionResult>
function ClientHero60017ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 0.7, 0.3)

end

function ClientHero60017ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName)
end

function ClientHero60017ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero60017ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
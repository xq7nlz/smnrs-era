--- @class ClientHero30010ActiveSkill : BaseSkillShow
ClientHero30010ActiveSkill = Class(ClientHero30010ActiveSkill, BaseSkillShow)

function ClientHero30010ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/skill_launch_position").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero30010ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 0.8, 0.3)

end

function ClientHero30010ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero30010ActiveSkill:OnCastEffect()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 0.3, ClientConfigUtils.FOOT_ANCHOR)
end

function ClientHero30010ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
--- @class ClientHero30004ActiveSkill : BaseSkillShow
ClientHero30004ActiveSkill = Class(ClientHero30004ActiveSkill, BaseSkillShow)

function ClientHero30004ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_skill_position").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero30004ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.4, 0.9, 0.3)

end

function ClientHero30004ActiveSkill:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)

    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_NORMAL)
end

function ClientHero30004ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 5.0 / ClientConfigUtils.FPS, ClientConfigUtils.FOOT_ANCHOR)
end

function ClientHero30004ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
--- @class ClientHero50016ActiveSkill : BaseSkillShow
ClientHero50016ActiveSkill = Class(ClientHero50016ActiveSkill, BaseSkillShow)

function ClientHero50016ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero50016ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 0.5, 0.3)

end

function ClientHero50016ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 7 / ClientConfigUtils.FPS)
end

function ClientHero50016ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero50016ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
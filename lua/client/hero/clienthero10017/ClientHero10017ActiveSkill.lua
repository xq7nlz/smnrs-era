--- @class ClientHero10017ActiveSkill : BaseSkillShow
ClientHero10017ActiveSkill = Class(ClientHero10017ActiveSkill, BaseSkillShow)

function ClientHero10017ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero10017ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1, 0.3)

end

function ClientHero10017ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero10017ActiveSkill:OnCompleteActionTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnCompleteActionTurn(self)
end

function ClientHero10017ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, ClientConfigUtils.PROJECTILE_FRY_TIME, ClientConfigUtils.BODY_ANCHOR)
end
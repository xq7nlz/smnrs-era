--- @class ClientHero10005ActiveSkill : BaseSkillShow
ClientHero10005ActiveSkill = Class(ClientHero10005ActiveSkill, BaseSkillShow)

function ClientHero10005ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_skill").position
    self.projectileName = string.format("hero_%d_%s", self.baseHero.id, ClientConfigUtils.DEFAULT_SKILL_PROJECTILE)
end

--- @param actionResults List<BaseActionResult>
function ClientHero10005ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1.4, 0.5)
end

function ClientHero10005ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, ClientConfigUtils.FOOT_ANCHOR)
end

function ClientHero10005ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero10005ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
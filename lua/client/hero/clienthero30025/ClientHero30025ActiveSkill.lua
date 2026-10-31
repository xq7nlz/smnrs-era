--- @class ClientHero30025ActiveSkill : BaseSkillShow
ClientHero30025ActiveSkill = Class(ClientHero30025ActiveSkill, BaseSkillShow)

function ClientHero30025ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_skill").position
    self.projectileName = string.format("hero_%d_%s", self.baseHero.id, ClientConfigUtils.DEFAULT_SKILL_PROJECTILE)
end

--- @param actionResults List<BaseActionResult>
function ClientHero30025ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.3)

end

function ClientHero30025ActiveSkill:OnCastEffect()
	self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, ClientConfigUtils.FOOT_ANCHOR)
end

function ClientHero30025ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero30025ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
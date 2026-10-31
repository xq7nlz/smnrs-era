--- @class ClientHero20006ActiveSkill : BaseSkillShow
ClientHero20006ActiveSkill = Class(ClientHero20006ActiveSkill, BaseSkillShow)

function ClientHero20006ActiveSkill:DeliverCtor()
	self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_gate")
	self.fxSkillName = string.format("hero_%s_skill_gate", self.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero20006ActiveSkill:CastOnTarget(actionResults)
	BaseSkillShow.CastOnTarget(self, actionResults)
	self:DoAnimation()

	self:DoCoverBattle(0.5, 1, 0.3)

end

function ClientHero20006ActiveSkill:OnCastEffect()
	self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName,
			20 / ClientConfigUtils.FPS,
			ClientConfigUtils.BODY_ANCHOR,
			self.projectileLaunchPos.position)

end

function ClientHero20006ActiveSkill:DoAnimation()
	self.clientHero:PlayAnimation(self.animName, false, self.clientHero.mainTrackIndex)
	self.clientHero:PlayAnimationEffectByFrame(self.animName)

	self:PlayFrameAction(self.listFrameAction)
	--- @type ClientHero
	local clientTargetHero
	--- @type ClientEffect
	local fxSkill
	fxSkill = self:GetClientEffect(AssetType.HeroBattleEffect, self.fxSkillName)
	if fxSkill ~= nil then
		fxSkill:SetToHeroAnchor(self.clientHero)
	end
end

function ClientHero20006ActiveSkill:OnTriggerActionResult()
	self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
	BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero20006ActiveSkill:OnEndTurn()
	BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
	BaseSkillShow.OnEndTurn(self)
end



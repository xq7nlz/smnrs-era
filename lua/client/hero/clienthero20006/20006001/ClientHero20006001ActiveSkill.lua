--- @class ClientHero20006001ActiveSkill : BaseSkillShow
ClientHero20006001ActiveSkill = Class(ClientHero20006001ActiveSkill, BaseSkillShow)

function ClientHero20006001ActiveSkill:DeliverCtor()
	self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_gate")
	self.fxSkillName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_gate")
	self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_projectile")
end

--- @param actionResults List<BaseActionResult>
function ClientHero20006001ActiveSkill:CastOnTarget(actionResults)
	BaseSkillShow.CastOnTarget(self, actionResults)
	self:DoAnimation()

	self:DoCoverBattle(0.5, 1, 0.3)

end

function ClientHero20006001ActiveSkill:OnCastEffect()
	self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName,
			20 / ClientConfigUtils.FPS,
			ClientConfigUtils.BODY_ANCHOR,
			self.projectileLaunchPos.position)

end


--- @param effectType string
--- @param effectName string
function ClientHero20006001ActiveSkill:CastNewClientImpactOnTargets(effectType, effectName)
	for i = 1, self.listTargetHero:Count() do
		--- @type ClientEffect
		local fxImpact = self:GetClientEffect(effectType, effectName)
		if fxImpact ~= nil then
			local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
			fxImpact:SetToHeroAnchor(clientTargetHero,false,true)
		end
	end
end

function ClientHero20006001ActiveSkill:DoAnimation()
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

function ClientHero20006001ActiveSkill:OnTriggerActionResult()
	self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_SUPPER_HARD)
	BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero20006001ActiveSkill:OnEndTurn()
	BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
	BaseSkillShow.OnEndTurn(self)
end



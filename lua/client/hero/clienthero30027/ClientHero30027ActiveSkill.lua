--- @class ClientHero30027ActiveSkill : BaseSkillShow
ClientHero30027ActiveSkill = Class(ClientHero30027ActiveSkill, BaseSkillShow)

function ClientHero30027ActiveSkill:DeliverSetFrameAction()
	self:RemoveAllCCEffect()
	local pos = PositionConfig.GetBattleCentralPosition()
	if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
		pos = pos - U_Vector3.right * 1.5
	else
		pos = pos + U_Vector3.right * 1.5
	end
	self:AddFrameAction(20, function()
		self.clientHero.clientHeroMovement:SetPosition(pos)
	end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero30027ActiveSkill:CastOnTarget(actionResults)
	BaseSkillShow.CastOnTarget(self, actionResults)
	self:DoAnimation()
	self:DoCoverBattle(2, 0.4, 0.5)

end

function ClientHero30027ActiveSkill:OnEndAnimation()
	if self.clientHero.heroModelType ~= HeroModelType.Full then
		BaseSkillShow.OnEndAnimation(self)
		return
	end

	self:DoMovePosition(self.clientHero.originPosition, function()
		BaseSkillShow.OnEndAnimation(self)
		self:OnEndTurn()
	end)
end

function ClientHero30027ActiveSkill:OnTriggerActionResult()
	self.clientBattleShowController:DoShake({ 1.3, 0.1, 0.4, 200, 0 })
	BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero30027ActiveSkill:OnEndTurn()
	BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
	BaseSkillShow.OnEndTurn(self)
end

function ClientHero30027ActiveSkill:OnCompleteActionTurn()

end

function ClientHero30027ActiveSkill:RemoveAllCCEffect()
	self.clientHero.clientHeroEffectMgr.hardCcEffectMgr:Release()
end
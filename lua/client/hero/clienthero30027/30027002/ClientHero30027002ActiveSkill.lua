--- @class ClientHero30027002ActiveSkill : ClientHero30027ActiveSkill
ClientHero30027002ActiveSkill = Class(ClientHero30027002ActiveSkill, ClientHero30027ActiveSkill)

function ClientHero30027002ActiveSkill:DeliverSetFrameAction()

end

function ClientHero30027002ActiveSkill:DeliverCtor()
	self.dragonFx = self.clientHero.components:FindChildByPath("Model/DragonFX")
	self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end

function ClientHero30027002ActiveSkill:OnEndAnimation()
	if self.clientHero.heroModelType ~= HeroModelType.Full then
		BaseSkillShow.OnEndAnimation(self)
		return
	end

	self:DoMovePosition(self.clientHero.originPosition, function()
		BaseSkillShow.OnEndAnimation(self)
		self:OnEndTurn()
		self.dragonFx.gameObject:SetActive(false)
	end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero30027002ActiveSkill:CastOnTarget(actionResults)
	BaseSkillShow.CastOnTarget(self, actionResults)
	local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
	self:AccostTarget(clientTargetHero, function ()
		self:DoAnimation()
	end,5)
	self:DoCoverBattle(2, 0.4, 0.5)
	self.dragonFx.gameObject:SetActive(true)
end
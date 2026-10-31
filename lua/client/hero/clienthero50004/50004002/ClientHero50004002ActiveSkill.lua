require "lua.client.hero.ClientHero50004.ClientHero50004ActiveSkill"
--- @class ClientHero50004002ActiveSkill : ClientHero50004ActiveSkill
ClientHero50004002ActiveSkill = Class(ClientHero50004002ActiveSkill, ClientHero50004ActiveSkill)

function ClientHero50004002ActiveSkill:DeliverSetFrameAction()
	local offsetX = 0.5
	local offSet = U_Vector2(offsetX, 0)
	if (self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID) then
		offSet = U_Vector2(-offsetX, 0)
	end
	self:AddFrameAction(6, function()
		self:DoMovePosition(PositionConfig.GetBattleCentralPosition() + offSet, nil, 0.26)
	end)
end

function ClientHero50004002ActiveSkill:OnEndAnimation()
	self:DoMovePosition(self.clientHero.originPosition, function()
		BaseSkillShow.OnEndAnimation(self)
		self:OnEndTurn()
	end)
end

function ClientHero50004002ActiveSkill:OnCompleteActionTurn()
end
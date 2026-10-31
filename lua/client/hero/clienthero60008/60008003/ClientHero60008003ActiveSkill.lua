require "lua.client.hero.ClientHero60008.60008002.ClientHero60008002ActiveSkill"
--- @class ClientHero60008003ActiveSkill : ClientHero60008002ActiveSkill
ClientHero60008003ActiveSkill = Class(ClientHero60008003ActiveSkill, ClientHero60008002ActiveSkill)

function ClientHero60008003ActiveSkill:MoveThenCast()
	--- @type BaseHero
	local baseTarget = self.listTargetHero:Get(1)
	local moveDest = PositionConfig.GetAccostOpponentLinePosition(baseTarget.teamId,
			baseTarget.positionInfo.isFrontLine,
			4)
	self:DoMovePosition(moveDest, function()
		self:DoAnimation()
	end)
end
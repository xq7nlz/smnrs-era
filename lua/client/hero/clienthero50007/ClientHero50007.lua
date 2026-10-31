require "lua.client.hero.ClientHero50007.ClientHero50007RangeAttack"
require "lua.client.hero.ClientHero50007.ClientHero50007ActiveSkill"

--- DarkPriest
--- @class ClientHero50007 : ClientHero
ClientHero50007 = Class(ClientHero50007, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50007:CreateInstance(heroModelType)
	return ClientHero50007(heroModelType)
end

function ClientHero50007:InitSkill()
	if self.heroModelType == HeroModelType.Dummy then
		return
	end
	if self.heroModelType >= HeroModelType.Basic then
		if self.skinId == 50007001 then
			require "lua.client.hero.ClientHero50007.50007001.ClientHero50007001RangeAttack"
			self.basicAttack = ClientHero50007001RangeAttack(self)
			self.basicAttack:SetFrameActionEvent(54, 70, 35, 29)
		elseif self.skinId == 50007002 then
			require "lua.client.hero.ClientHero50007.50007002.ClientHero50007002RangeAttack"
			self.basicAttack = ClientHero50007002RangeAttack(self)
			self.basicAttack:SetFrameActionEvent(54, 70, 35, 29)
		else
			self.basicAttack = ClientHero50007RangeAttack(self)
			self.basicAttack:SetFrameActionEvent(54, 70, 35, 29)
		end
	end
	if self.heroModelType >= HeroModelType.Full then
		if self.skinId == 50007001 then
			require "lua.client.hero.ClientHero50007.50007001.ClientHero50007001ActiveSkill"
			self.skillAttack = ClientHero50007001ActiveSkill(self)
			self.skillAttack:SetFrameActionEvent(110, 140, 65, 45)
		elseif self.skinId == 50007002 then
			require "lua.client.hero.ClientHero50007.50007002.ClientHero50007002ActiveSkill"
			self.skillAttack = ClientHero50007002ActiveSkill(self)
			self.skillAttack:SetFrameActionEvent(110, 140, 65, 45)
		else
			self.skillAttack = ClientHero50007ActiveSkill(self)
			self.skillAttack:SetFrameActionEvent(110, 140, 70, 45)
		end
	end
end

return ClientHero50007
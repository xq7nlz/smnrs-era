require "lua.client.hero.ClientHero20006.ClientHero20006RangeAttack"
require "lua.client.hero.ClientHero20006.ClientHero20006ActiveSkill"

--- @class ClientHero20006 : ClientHero
ClientHero20006 = Class(ClientHero20006, ClientHero)

--- @return ClientHero20006
--- @param heroModelType HeroModelType
function ClientHero20006:CreateInstance(heroModelType)
	return ClientHero20006(heroModelType)
end

function ClientHero20006:InitSkill()
	if self.heroModelType == HeroModelType.Dummy then
		return
	end
	if self.heroModelType >= HeroModelType.Basic then
		if self.skinId == 20006001 then
			require "lua.client.hero.ClientHero20006.20006001.ClientHero20006001RangeAttack"
			self.basicAttack = ClientHero20006001RangeAttack(self)
			self.basicAttack:SetFrameActionEvent(55, 56, 41, 26)
		else
			self.basicAttack = ClientHero20006RangeAttack(self)
			self.basicAttack:SetFrameActionEvent(55, 56, 41, 26)
		end
	end
	if self.heroModelType >= HeroModelType.Full then
		if self.skinId == 20006001 then
			require "lua.client.hero.ClientHero20006.20006001.ClientHero20006001ActiveSkill"
			self.skillAttack = ClientHero20006001ActiveSkill(self)
			self.skillAttack:SetFrameActionEvent(101, 101, 60, 41)
		else
			self.skillAttack = ClientHero20006ActiveSkill(self)
			self.skillAttack:SetFrameActionEvent(100, 101, 60, 41)
		end
	end
end

function ClientHero20006:InitAnimationComponent()
	ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero20006:PlayStartAnimation()
	ClientHero.PlayStartAnimation(self)
	ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero20006

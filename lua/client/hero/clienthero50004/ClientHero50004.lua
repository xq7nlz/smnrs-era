require "lua.client.hero.ClientHero50004.ClientHero50004ActiveSkill"
require "lua.client.hero.ClientHero50004.ClientHero50004BaseAttack"

--- Grimm
--- @class ClientHero50004 : ClientHero
ClientHero50004 = Class(ClientHero50004, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50004:CreateInstance(heroModelType)
	return ClientHero50004(heroModelType)
end

function ClientHero50004:PlayStartAnimation()
	ClientHero.PlayStartAnimation(self)
	if (self.skinId == 50004001) then
		ClientHero.PlayAnimation(self, "fx", true, 0)
	end
end

function ClientHero50004:InitAnimationComponent()
	if (self.skinId == 50004001) then
		ClientHero.InitAnimationComponent(self, 1)
	else
		ClientHero.InitAnimationComponent(self)
	end
end

function ClientHero50004:InitSkill()
	if self.heroModelType == HeroModelType.Dummy then
		return
	end
	if self.heroModelType >= HeroModelType.Basic then
		self.basicAttack = ClientHero50004BaseAttack(self, true)
		if (self.skinId == 50004001) then
			self.basicAttack:SetFrameActionEvent(69, 70, 28, -1)
		else
			self.basicAttack:SetFrameActionEvent(55, 60, 28, -1)
		end
	end
	if self.heroModelType >= HeroModelType.Full then
		self.skillAttack = ClientHero50004ActiveSkill(self)
		if (self.skinId == 50004001) then
			self.skillAttack:SetFrameActionEvent(95, 96, 65, 50)
		elseif (self.skinId == 50004002) then
			require "lua.client.hero.ClientHero50004.50004002.ClientHero50004002ActiveSkill"
			self.skillAttack = ClientHero50004002ActiveSkill(self)
			self.skillAttack:SetFrameActionEvent(95, 96, 65, 50)
		else
			self.skillAttack:SetFrameActionEvent(80, 90, 65, 50)
		end
	end
end

return ClientHero50004
--- Mist
--- @class ClientHero10005 : ClientHero
ClientHero10005 = Class(ClientHero10005, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero10005:CreateInstance(heroModelType)
	return ClientHero10005(heroModelType)
end

function ClientHero10005:InitSkill()
	if self.heroModelType == HeroModelType.Dummy then
		return
	end
	if self.heroModelType >= HeroModelType.Basic then
		require "lua.client.hero.ClientHero10005.ClientHero10005RangeAttack"
		if self.skinId == 10005001 then
			require "lua.client.hero.ClientHero10005.10005001.ClientHero10005001RangeAttack"
			self.basicAttack = ClientHero10005001RangeAttack(self)
			self.basicAttack:SetFrameActionEvent(58, 59, 20, 15)
		elseif self.skinId == 10005002 then
			require "lua.client.hero.ClientHero10005.10005002.ClientHero10005002RangeAttack"
			self.basicAttack = ClientHero10005002RangeAttack(self)
			self.basicAttack:SetFrameActionEvent(72, 100, 35, 31)
		else
			self.basicAttack = ClientHero10005RangeAttack(self)
			self.basicAttack:SetFrameActionEvent(72, 73, 36, 31)
		end
	end
	if self.heroModelType >= HeroModelType.Full then
		require "lua.client.hero.ClientHero10005.ClientHero10005ActiveSkill"
		if self.skinId == 10005001 then
			require "lua.client.hero.ClientHero10005.10005001.ClientHero10005001ActiveSkill"
			self.skillAttack = ClientHero10005001ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(90, 91, 39, 34)

        elseif self.skinId == 10005002 then
			require "lua.client.hero.ClientHero10005.10005002.ClientHero10005002ActiveSkill"
			self.skillAttack = ClientHero10005002ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(90, 100, 50, 46)

        else
			self.skillAttack = ClientHero10005ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(90, 91, 39, 34)

        end
	end
end

function ClientHero10005:InitAnimationComponent()
	ClientHero.InitAnimationComponent(self, 3)
end

function ClientHero10005:PlayStartAnimation()
	ClientHero.PlayStartAnimation(self)
	ClientHero.PlayAnimation(self, "fx", true, 0)
	ClientHero.PlayAnimation(self, "ao", true, 1)
	ClientHero.PlayAnimation(self, "toc", true, 2)
end

return ClientHero10005
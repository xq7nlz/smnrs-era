require "lua.client.hero.ClientHero60010.ClientHero60010RangeAttack"
require "lua.client.hero.ClientHero60010.ClientHero60010ActiveSkill"

--- Diadora
--- @class ClientHero60010 : ClientHero
ClientHero60010 = Class(ClientHero60010, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60010:CreateInstance(heroModelType)
    return ClientHero60010(heroModelType)
end

function ClientHero60010:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then

        if self.skinId == 60010001 then
            require "lua.client.hero.ClientHero60010.ClientHero60010001.ClientHero60010001RangeAttack"
            self.basicAttack = ClientHero60010001RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(50, 51, 30, 24) --dung config
        elseif self.skinId == 60010002 then
            require "lua.client.hero.ClientHero60010.ClientHero60010002.ClientHero60010002RangeAttack"
            self.basicAttack = ClientHero60010002RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(50, 51, 30, 24)
        else
            self.basicAttack = ClientHero60010RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(50, 51, 35, 30) -- base
        end
    end
    if self.heroModelType >= HeroModelType.Full then
        if self.skinId == 60010001 then
            require "lua.client.hero.ClientHero60010.ClientHero60010001.ClientHero60010001ActiveSkill"
            self.skillAttack = ClientHero60010001ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(80, 81, 48, 24)
        elseif self.skinId == 60010002 then
            require "lua.client.hero.ClientHero60010.ClientHero60010002.ClientHero60010002ActiveSkill"
            self.skillAttack = ClientHero60010002ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(80, 81, 48, 10)
        else
            self.skillAttack = ClientHero60010ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(80, 81, 54, 26)
        end

    end
end

function ClientHero60010:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero60010:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero60010
require "lua.client.hero.ClientHero50011.ClientHero50011RangeAttack"
require "lua.client.hero.ClientHero50011.ClientHero50011ActiveSkill"

--- Ignatius
--- @class ClientHero50011 : ClientHero
ClientHero50011 = Class(ClientHero50011, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50011:CreateInstance(heroModelType)
    return ClientHero50011(heroModelType)
end

function ClientHero50011:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        if self.skinId == 50011001 then
            require "lua.client.hero.ClientHero50011.ClientHero50011001.ClientHero50011001RangeAttack"
            self.basicAttack = ClientHero50011001RangeAttack(self)
        elseif self.skinId == 50011002 then
            require "lua.client.hero.ClientHero50011.ClientHero50011002.ClientHero50011002RangeAttack"
            self.basicAttack = ClientHero50011002RangeAttack(self)
        else
            self.basicAttack = ClientHero50011RangeAttack(self)
        end
        self.basicAttack:SetFrameActionEvent(52, 51, 29, 24)
    end
    if self.heroModelType >= HeroModelType.Full then
        if self.skinId == 50011001 then
            require "lua.client.hero.ClientHero50011.ClientHero50011001.ClientHero50011001ActiveSkill"
            self.skillAttack = ClientHero50011001ActiveSkill(self)
        elseif self.skinId == 50011002 then
            require "lua.client.hero.ClientHero50011.ClientHero50011002.ClientHero50011002ActiveSkill"
            self.skillAttack = ClientHero50011002ActiveSkill(self)
        else
            self.skillAttack = ClientHero50011ActiveSkill(self)
        end
        self.skillAttack:SetFrameActionEvent(85, 86, 52, 0)
    end
end

function ClientHero50011:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero50011:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero50011
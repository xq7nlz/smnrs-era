require "lua.client.hero.ClientHero50006.ClientHero50006RangeAttack"
require "lua.client.hero.ClientHero50006.ClientHero50006ActiveSkill"

--- Enule
--- @class ClientHero50006 : ClientHero
ClientHero50006 = Class(ClientHero50006, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50006:CreateInstance(heroModelType)
    return ClientHero50006(heroModelType)
end

function ClientHero50006:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        if self.skinId == 50006001 then
            require "lua.client.hero.ClientHero50006.50006001.ClientHero50006001RangeAttack"
            self.basicAttack = ClientHero50006001RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(60, 61, -1, 20)
        elseif self.skinId == 50006002 then
            require "lua.client.hero.ClientHero50006.50006002.ClientHero50006002RangeAttack"
            self.basicAttack = ClientHero50006002RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(60, 61, -1, 20)
        elseif self.skinId == 50006003 then
            require "lua.client.hero.ClientHero50006.50006003.ClientHero50006003RangeAttack"
            self.basicAttack = ClientHero50006003RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(60, 61, -1, 20)
        else
            self.basicAttack = ClientHero50006RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(60, 61, -1, 20)
        end
    end
    if self.heroModelType >= HeroModelType.Full then
        if self.skinId == 50006001 then
            require "lua.client.hero.ClientHero50006.50006001.ClientHero50006001ActiveSkill"
            self.skillAttack = ClientHero50006001ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(85, 86, -1, 53)
        elseif self.skinId == 50006002 then
            require "lua.client.hero.ClientHero50006.50006002.ClientHero50006002ActiveSkill"
            self.skillAttack = ClientHero50006002ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(105, 106, -1, 53)
        elseif self.skinId == 50006003 then
            require "lua.client.hero.ClientHero50006.50006003.ClientHero50006003ActiveSkill"
            self.skillAttack = ClientHero50006003ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(85, 86, -1, 53)
        else
            self.skillAttack = ClientHero50006ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(85, 86, -1, 53)
        end
    end
end

function ClientHero50006:InitAnimationComponent()
    ClientHero.InitAnimationComponent(self, 1)
end

function ClientHero50006:PlayStartAnimation()
    ClientHero.PlayStartAnimation(self)
    ClientHero.PlayAnimation(self, "fx", true, 0)
end

return ClientHero50006
require "lua.client.hero.ClientHero10004.ClientHero10004RangeAttack"
require "lua.client.hero.ClientHero10004.ClientHero10004ActiveSkill"

--- Pasthera
--- @class ClientHero10004 : ClientHero
ClientHero10004 = Class(ClientHero10004, ClientHero)

--- @param clientBattleShow ClientBattleShowController
--- @return ClientHero10004
function ClientHero10004:CreateInstance(clientBattleShow)
    return ClientHero10004(clientBattleShow)
end

function ClientHero10004:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        if self.skinId == 10004001 then
            require "lua.client.hero.ClientHero10004.10004001.ClientHero10004001RangeAttack"
            self.basicAttack = ClientHero10004001RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(45, 50, 26, 21)
        elseif self.skinId == 10004002 then
            require "lua.client.hero.ClientHero10004.10004002.ClientHero10004002RangeAttack"
            self.basicAttack = ClientHero10004002RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(45, 50, 26, 21)
        elseif self.skinId == 10004003 then
            require "lua.client.hero.ClientHero10004.10004003.ClientHero10004003RangeAttack"
            self.basicAttack = ClientHero10004003RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(45, 50, 26, 21)
        else
            self.basicAttack = ClientHero10004RangeAttack(self)
            self.basicAttack:SetFrameActionEvent(45, 50, 26, 21)
        end
    end
    if self.heroModelType >= HeroModelType.Full then
        if self.skinId == 10004001 then
            require "lua.client.hero.ClientHero10004.10004001.ClientHero10004001ActiveSkill"
            self.skillAttack = ClientHero10004001ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(70, 90, 55, 10)
        elseif self.skinId == 10004002 then
            require "lua.client.hero.ClientHero10004.10004002.ClientHero10004002ActiveSkill"
            self.skillAttack = ClientHero10004002ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(70, 90, 52, 43)
        elseif self.skinId == 10004003 then
            require "lua.client.hero.ClientHero10004.10004003.ClientHero10004003ActiveSkill"
            self.skillAttack = ClientHero10004003ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(70, 90, 52, 0)
        else
            self.skillAttack = ClientHero10004ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(70, 80, 50, 10)
        end
    end
end

return ClientHero10004
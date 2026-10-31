require "lua.client.hero.ClientHero50001.ClientHero50001ActiveSkill"
require "lua.client.hero.ClientHero50001.ClientHero50001RangeAttack"

--- Entia
--- @class ClientHero50001 : ClientHero
ClientHero50001 = Class(ClientHero50001, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50001:CreateInstance(heroModelType)
    return ClientHero50001(heroModelType)
end

function ClientHero50001:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        if self.skinId == 50001001 then
            require "lua.client.hero.ClientHero50001.50001001.ClientHero50001001RangeAttack"
            self.basicAttack = ClientHero50001001RangeAttack(self)
        else
            self.basicAttack = ClientHero50001RangeAttack(self)
        end
        self.basicAttack:SetFrameActionEvent(55, 56, -1, 25)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50001ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(78, 79, 50, 20)
    end
end

return ClientHero50001
require "lua.client.hero.ClientHero50020.ClientHero50020ActiveSkill"
require "lua.client.hero.ClientHero50020.ClientHero50020BaseAttack"

--- Edmund
--- @class ClientHero50020 : ClientHero
ClientHero50020 = Class(ClientHero50020, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50020:CreateInstance(heroModelType)
    return ClientHero50020(heroModelType)
end

function ClientHero50020:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(50, 51, 22, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50020ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(95, 96, 50, -1)
    end
end

return ClientHero50020
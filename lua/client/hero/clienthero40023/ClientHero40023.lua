require "lua.client.hero.ClientHero40023.ClientHero40023ActiveSkill"
require "lua.client.hero.ClientHero40023.ClientHero40023BaseAttack"

--- Hound Master
--- @class ClientHero40023 : ClientHero
ClientHero40023 = Class(ClientHero40023, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40023:CreateInstance(heroModelType)
    return ClientHero40023(heroModelType)
end

function ClientHero40023:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero40023BaseAttack(self)
        self.basicAttack:SetFrameActionEvent(41, 42, 25, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40023ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(41, 42, 28, 25)
    end
end

return ClientHero40023
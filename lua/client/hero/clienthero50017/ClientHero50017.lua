require "lua.client.hero.ClientHero50017.ClientHero50017ActiveSkill"

--- Berton
--- @class ClientHero50017 : ClientHero
ClientHero50017 = Class(ClientHero50017, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero50017:CreateInstance(heroModelType)
    return ClientHero50017(heroModelType)
end

function ClientHero50017:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(54, 55, 18, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero50017ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(65, 66, 38, -1)
    end
end

return ClientHero50017
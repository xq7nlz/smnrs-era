require "lua.client.hero.ClientHero20017.ClientHero20017ActiveSkill"

--- Rufus
--- @class ClientHero20017 : ClientHero
ClientHero20017 = Class(ClientHero20017, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero20017:CreateInstance(heroModelType)
    return ClientHero20017(heroModelType)
end

function ClientHero20017:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(22, 23, 9, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero20017ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(36, 37, 24, -1)
    end
end

return ClientHero20017
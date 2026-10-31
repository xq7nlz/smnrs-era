require "lua.client.hero.ClientHero40004.ClientHero40004ActiveSkill"
require "lua.client.hero.ClientHero40004.ClientHero40004MeleeAttack"

--- Cernunos
--- @class ClientHero40004 : ClientHero
ClientHero40004 = Class(ClientHero40004, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40004:CreateInstance(heroModelType)
    return ClientHero40004(heroModelType)
end

function ClientHero40004:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero40004MeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(55, 56, 21, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero40004ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(80, 81, 53, 6)
    end
end

return ClientHero40004
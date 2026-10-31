require "lua.client.hero.ClientHero60020.ClientHero60020ActiveSkill"

--- DarkDwarf
--- @class ClientHero60020 : ClientHero
ClientHero60020 = Class(ClientHero60020, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60020:CreateInstance(heroModelType)
    return ClientHero60020(heroModelType)
end

function ClientHero60020:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = BaseMeleeAttack(self)
        self.basicAttack:SetFrameActionEvent(48, 49, 21, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero60020ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(73, 74, 46, 41)
    end
end

return ClientHero60020
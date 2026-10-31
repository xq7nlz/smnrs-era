require "lua.client.hero.ClientHero30016.ClientHero30016RangeAttack"
require "lua.client.hero.ClientHero30016.clientHero30016ActiveSkill"

--- Skeleton Bowman
--- @class ClientHero30016 : ClientHero
ClientHero30016 = Class(ClientHero30016, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero30016:CreateInstance(heroModelType)
    return ClientHero30016(heroModelType)
end

function ClientHero30016:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        self.basicAttack = ClientHero30016RangeAttack(self)
        self.basicAttack:SetFrameActionEvent(57, 58, 18, -1)
    end
    if self.heroModelType >= HeroModelType.Full then
        self.skillAttack = ClientHero30016ActiveSkill(self)
        self.skillAttack:SetFrameActionEvent(67, 68, 46, 41)
    end
end

return ClientHero30016
require "lua.client.hero.ClientHero40003.ClientHero40003ActiveSkill"
require "lua.client.hero.ClientHero40003.ClientHero40003RangeAttack"

--- Arryl
--- @class ClientHero40003 : ClientHero
ClientHero40003 = Class(ClientHero40003, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero40003:CreateInstance(heroModelType)
    return ClientHero40003(heroModelType)
end

function ClientHero40003:InitSkill()
    if self.heroModelType == HeroModelType.Dummy then
        return
    end
    if self.heroModelType >= HeroModelType.Basic then
        if self.skinId == 40003001 then
            require "lua.client.hero.ClientHero40003.40003001.ClientHero40003001RangeAttack"
            self.basicAttack = ClientHero40003001RangeAttack(self)
        else
            self.basicAttack = ClientHero40003RangeAttack(self)
        end
        self.basicAttack:SetFrameActionEvent(54, 55, 35, 30)
    end
    if self.heroModelType >= HeroModelType.Full then
        if self.skinId == 40003001 then
            require "lua.client.hero.ClientHero40003.40003001.ClientHero40003001ActiveSkill"
            self.skillAttack = ClientHero40003001ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(75, 115, 96, -1)
        else
            self.skillAttack = ClientHero40003ActiveSkill(self)
            self.skillAttack:SetFrameActionEvent(75, 90, 81, -1)
        end
    end
end

return ClientHero40003
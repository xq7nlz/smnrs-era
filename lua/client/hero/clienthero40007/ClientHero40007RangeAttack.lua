--- @class ClientHero40007RangeAttack : BaseRangeAttack
ClientHero40007RangeAttack = Class(ClientHero40007RangeAttack, BaseRangeAttack)

--- @param clientHero ClientHero
function ClientHero40007RangeAttack:Ctor(clientHero)
    BaseRangeAttack.Ctor(self, clientHero)
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        return
    end
end

function ClientHero40007RangeAttack:OnCastEffect()

end
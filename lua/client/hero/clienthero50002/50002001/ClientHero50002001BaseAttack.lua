--- @class ClientHero50002001BaseAttack : BaseSkillShow
ClientHero50002001BaseAttack = Class(ClientHero50002001BaseAttack, BaseMeleeAttack)

function ClientHero50002001BaseAttack:SetOffsetAccostX()
    BaseSkillShow.SetOffsetAccostX(self, 2.6)
end

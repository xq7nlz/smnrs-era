--- @class ClientHero30001BaseAttack : BaseMeleeAttack
ClientHero30001BaseAttack = Class(ClientHero30001BaseAttack, BaseMeleeAttack)

function ClientHero30001BaseAttack:SetOffsetAccostX()
    BaseSkillShow.SetOffsetAccostX(self, 3.5)
end


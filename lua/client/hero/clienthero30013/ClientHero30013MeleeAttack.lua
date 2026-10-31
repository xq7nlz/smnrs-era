--- @class ClientHero30013MeleeAttack : BaseSkillShow
ClientHero30013MeleeAttack = Class(ClientHero30013MeleeAttack, BaseMeleeAttack)

function ClientHero30013MeleeAttack:SetOffsetAccostX()
    BaseSkillShow.SetOffsetAccostX(self, 3)
end
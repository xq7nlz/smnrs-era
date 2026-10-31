--- @class ClientHero50002MeleeAttack : BaseSkillShow
ClientHero50002MeleeAttack = Class(ClientHero50002MeleeAttack, BaseMeleeAttack)

function ClientHero50002MeleeAttack:SetOffsetAccostX()
    BaseSkillShow.SetOffsetAccostX(self, 2.6)
end
--- @class ClientHero60006MeleeAttack : BaseSkillShow
ClientHero60006MeleeAttack = Class(ClientHero60006MeleeAttack, BaseMeleeAttack)

function ClientHero60006MeleeAttack:SetOffsetAccostX()
    BaseSkillShow.SetOffsetAccostX(self, ClientConfigUtils.OFFSET_ACCOST_X * 1.4)
end
--- @class ClientHero20011MeleeAttack : BaseMeleeAttack
ClientHero20011MeleeAttack = Class(ClientHero20011MeleeAttack, BaseMeleeAttack)

function ClientHero20011MeleeAttack:DoActionOnListTarget()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    self:AccostTarget(clientTargetHero, function ()
        self:DoAnimation()
    end, 4.2)
end
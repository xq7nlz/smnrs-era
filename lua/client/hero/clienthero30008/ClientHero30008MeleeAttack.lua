--- @class ClientHero30008MeleeAttack : BaseMeleeAttack
ClientHero30008MeleeAttack = Class(ClientHero30008MeleeAttack, BaseMeleeAttack)

function ClientHero30008MeleeAttack:OnTriggerActionResult()
    BaseMeleeAttack.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_NORMAL)
end
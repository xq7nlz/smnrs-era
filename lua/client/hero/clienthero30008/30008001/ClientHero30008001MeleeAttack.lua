--- @class ClientHero30008001MeleeAttack : BaseMeleeAttack
ClientHero30008001MeleeAttack = Class(ClientHero30008001MeleeAttack, BaseMeleeAttack)

function ClientHero30008001MeleeAttack:OnTriggerActionResult()
    BaseMeleeAttack.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_NORMAL)
end
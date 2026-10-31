--- @class ClientHero20014RangeAttack : BaseMeleeAttack
ClientHero20014RangeAttack = Class(ClientHero20014RangeAttack, BaseRangeAttack)

function ClientHero20014RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
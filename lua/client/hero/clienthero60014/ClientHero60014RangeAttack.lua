--- @class ClientHero60014RangeAttack : BaseRangeAttack
ClientHero60014RangeAttack = Class(ClientHero60014RangeAttack, BaseRangeAttack)

function ClientHero60014RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
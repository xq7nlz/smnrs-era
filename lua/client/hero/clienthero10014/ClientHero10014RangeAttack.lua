--- @class ClientHero10014RangeAttack : BaseRangeAttack
ClientHero10014RangeAttack = Class(ClientHero10014RangeAttack, BaseRangeAttack)

function ClientHero10014RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
--- @class ClientHero60026RangeAttack : BaseRangeAttack
ClientHero60026RangeAttack = Class(ClientHero60026RangeAttack, BaseRangeAttack)

function ClientHero60026RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
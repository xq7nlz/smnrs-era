--- @class ClientHero60016RangeAttack : BaseRangeAttack
ClientHero60016RangeAttack = Class(ClientHero60016RangeAttack, BaseRangeAttack)

function ClientHero60016RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
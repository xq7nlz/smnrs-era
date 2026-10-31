--- @class ClientHero30026RangeAttack : BaseRangeAttack
ClientHero30026RangeAttack = Class(ClientHero30026RangeAttack, BaseRangeAttack)

function ClientHero30026RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
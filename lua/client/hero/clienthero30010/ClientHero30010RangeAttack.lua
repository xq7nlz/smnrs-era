--- @class ClientHero30010RangeAttack : BaseRangeAttack
ClientHero30010RangeAttack = Class(ClientHero30010RangeAttack, BaseRangeAttack)

function ClientHero30010RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
--- @class ClientHero30021RangeAttack : BaseRangeAttack
ClientHero30021RangeAttack = Class(ClientHero30021RangeAttack, BaseRangeAttack)

function ClientHero30021RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
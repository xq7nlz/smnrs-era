--- @class ClientHero30004RangeAttack : BaseRangeAttack
ClientHero30004RangeAttack = Class(ClientHero30004RangeAttack, BaseRangeAttack)

function ClientHero30004RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
--- @class ClientHero60004RangeAttack : BaseRangeAttack
ClientHero60004RangeAttack = Class(ClientHero60004RangeAttack, BaseRangeAttack)

function ClientHero60004RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
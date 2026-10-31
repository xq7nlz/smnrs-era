--- @class ClientHero60025RangeAttack : BaseRangeAttack
ClientHero60025RangeAttack = Class(ClientHero60025RangeAttack, BaseRangeAttack)

function ClientHero60025RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
--- @class ClientHero40025RangeAttack : BaseRangeAttack
ClientHero40025RangeAttack = Class(ClientHero40025RangeAttack, BaseRangeAttack)

function ClientHero40025RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

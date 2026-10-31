--- @class ClientHero40022RangeAttack : BaseRangeAttack
ClientHero40022RangeAttack = Class(ClientHero40022RangeAttack, BaseRangeAttack)

function ClientHero40022RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
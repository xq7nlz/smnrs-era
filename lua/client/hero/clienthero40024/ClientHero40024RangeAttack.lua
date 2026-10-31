--- @class ClientHero40024RangeAttack : BaseRangeAttack
ClientHero40024RangeAttack = Class(ClientHero40024RangeAttack, BaseRangeAttack)

function ClientHero40024RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
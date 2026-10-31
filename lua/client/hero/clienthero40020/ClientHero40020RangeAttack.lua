--- @class ClientHero40020RangeAttack : BaseRangeAttack
ClientHero40020RangeAttack = Class(ClientHero40020RangeAttack, BaseRangeAttack)

function ClientHero40020RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
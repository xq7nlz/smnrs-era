--- @class ClientHero40017RangeAttack : BaseRangeAttack
ClientHero40017RangeAttack = Class(ClientHero40017RangeAttack, BaseRangeAttack)

function ClientHero40017RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
--- @class ClientHero20026RangeAttack : BaseRangeAttack
ClientHero20026RangeAttack = Class(ClientHero20026RangeAttack, BaseRangeAttack)

function ClientHero20026RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
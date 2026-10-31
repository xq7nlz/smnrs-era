--- @class ClientHero10005RangeAttack : BaseRangeAttack
ClientHero10005RangeAttack = Class(ClientHero10005RangeAttack, BaseRangeAttack)

function ClientHero10005RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
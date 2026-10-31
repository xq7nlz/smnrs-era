--- @class ClientHero30007RangeAttack : BaseRangeAttack
ClientHero30007RangeAttack = Class(ClientHero30007RangeAttack, BaseRangeAttack)

function ClientHero30007RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
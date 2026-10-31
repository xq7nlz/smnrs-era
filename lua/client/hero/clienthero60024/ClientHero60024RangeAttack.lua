--- @class ClientHero60024RangeAttack : BaseRangeAttack
ClientHero60024RangeAttack = Class(ClientHero60024RangeAttack, BaseRangeAttack)

function ClientHero60024RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_2").position
end
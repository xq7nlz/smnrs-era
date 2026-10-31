--- @class ClientHero60018RangeAttack : BaseRangeAttack
ClientHero60018RangeAttack = Class(ClientHero60018RangeAttack, BaseRangeAttack)

function ClientHero60018RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
--- @class ClientHero40001RangeAttack : BaseRangeAttack
ClientHero40001RangeAttack = Class(ClientHero40001RangeAttack, BaseRangeAttack)

function ClientHero40001RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
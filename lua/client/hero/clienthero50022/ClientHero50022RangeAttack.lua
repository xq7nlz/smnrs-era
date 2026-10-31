--- @class ClientHero50022RangeAttack : BaseRangeAttack
ClientHero50022RangeAttack = Class(ClientHero50022RangeAttack, BaseRangeAttack)

function ClientHero50022RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

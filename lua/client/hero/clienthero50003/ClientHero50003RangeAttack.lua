--- @class ClientHero50003RangeAttack : BaseRangeAttack
ClientHero50003RangeAttack = Class(ClientHero50003RangeAttack, BaseRangeAttack)

function ClientHero50003RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
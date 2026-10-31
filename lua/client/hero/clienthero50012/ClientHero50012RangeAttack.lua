--- @class ClientHero50012RangeAttack : BaseRangeAttack
ClientHero50012RangeAttack = Class(ClientHero50012RangeAttack, BaseRangeAttack)

function ClientHero50012RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
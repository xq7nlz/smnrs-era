--- @class ClientHero20002RangeAttack : BaseRangeAttack
ClientHero20002RangeAttack = Class(ClientHero20002RangeAttack, BaseRangeAttack)

function ClientHero20002RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
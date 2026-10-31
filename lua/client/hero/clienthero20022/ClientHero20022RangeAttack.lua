--- @class ClientHero20022RangeAttack : BaseRangeAttack
ClientHero20022RangeAttack = Class(ClientHero20022RangeAttack, BaseRangeAttack)

function ClientHero20022RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
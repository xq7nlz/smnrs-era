--- @class ClientHero10022RangeAttack : BaseRangeAttack
ClientHero10022RangeAttack = Class(ClientHero10022RangeAttack, BaseRangeAttack)

function ClientHero10022RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
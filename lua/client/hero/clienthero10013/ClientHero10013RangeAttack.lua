--- @class ClientHero10013RangeAttack : BaseRangeAttack
ClientHero10013RangeAttack = Class(ClientHero10013RangeAttack, BaseRangeAttack)

function ClientHero10013RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
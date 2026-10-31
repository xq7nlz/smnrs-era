--- @class ClientHero20007RangeAttack : BaseRangeAttack
ClientHero20007RangeAttack = Class(ClientHero20007RangeAttack, BaseRangeAttack)

function ClientHero20007RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
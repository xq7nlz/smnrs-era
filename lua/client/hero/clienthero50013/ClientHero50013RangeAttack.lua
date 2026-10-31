--- @class ClientHero50013RangeAttack : BaseRangeAttack
ClientHero50013RangeAttack = Class(ClientHero50013RangeAttack, BaseRangeAttack)

function ClientHero50013RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
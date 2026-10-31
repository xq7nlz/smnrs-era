--- @class ClientHero50009RangeAttack : BaseRangeAttack
ClientHero50009RangeAttack = Class(ClientHero50009RangeAttack, BaseRangeAttack)

function ClientHero50009RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
--- @class ClientHero50015RangeAttack : BaseRangeAttack
ClientHero50015RangeAttack = Class(ClientHero50015RangeAttack, BaseRangeAttack)

function ClientHero50015RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
--- @class ClientHero50011RangeAttack : BaseRangeAttack
ClientHero50011RangeAttack = Class(ClientHero50011RangeAttack, BaseRangeAttack)

function ClientHero50011RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
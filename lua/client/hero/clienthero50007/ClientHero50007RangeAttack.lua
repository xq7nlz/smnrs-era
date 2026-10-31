--- @class ClientHero50007RangeAttack : BaseRangeAttack
ClientHero50007RangeAttack = Class(ClientHero50007RangeAttack, BaseRangeAttack)

function ClientHero50007RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_2").position
end
--- @class ClientHero30025RangeAttack : BaseRangeAttack
ClientHero30025RangeAttack = Class(ClientHero30025RangeAttack, BaseRangeAttack)

function ClientHero30025RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
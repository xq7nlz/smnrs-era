--- @class ClientHero40019RangeAttack : BaseRangeAttack
ClientHero40019RangeAttack = Class(ClientHero40019RangeAttack, BaseRangeAttack)

function ClientHero40019RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
    self.projectileName = self.projectileName .. "_" .. self.clientHero.skinName
end
--- @class ClientHero40005RangeAttack : BaseSkillShow
ClientHero40005RangeAttack = Class(ClientHero40005RangeAttack, BaseRangeAttack)

function ClientHero40005RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end
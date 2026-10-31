--- @class ClientHero50003001RangeAttack : BaseRangeAttack
ClientHero50003001RangeAttack = Class(ClientHero50003001RangeAttack, BaseRangeAttack)

function ClientHero50003001RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end
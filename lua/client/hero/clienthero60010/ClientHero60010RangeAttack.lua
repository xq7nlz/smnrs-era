--- @class ClientHero60010RangeAttack : BaseRangeAttack
ClientHero60010RangeAttack = Class(ClientHero60010RangeAttack, BaseRangeAttack)

function ClientHero60010RangeAttack:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position")
   -- self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end
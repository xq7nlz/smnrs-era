--- @class ClientHero10005001ActiveSkill : ClientHero10005ActiveSkill
ClientHero10005001ActiveSkill = Class(ClientHero10005001ActiveSkill, ClientHero10005ActiveSkill)

function ClientHero10005001ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_skill").position
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_projectile")
end
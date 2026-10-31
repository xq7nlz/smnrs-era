--- @class ClientHero20009001ActiveSkill : ClientHero20009ActiveSkill
ClientHero20009001ActiveSkill = Class(ClientHero20009001ActiveSkill, ClientHero20009ActiveSkill)

function ClientHero20009001ActiveSkill:DeliverCtor()
    ClientHero20009ActiveSkill.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_projectile")
end
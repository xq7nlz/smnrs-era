--- @class ClientHero50006001ActiveSkill : ClientHero50006ActiveSkill
ClientHero50006001ActiveSkill = Class(ClientHero50006001ActiveSkill, ClientHero50006ActiveSkill)

function ClientHero50006001ActiveSkill:DeliverCtor()
    ClientHero50006ActiveSkill.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_projectile")
end
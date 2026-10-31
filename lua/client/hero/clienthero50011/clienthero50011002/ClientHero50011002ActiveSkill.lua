--- @class ClientHero50011002ActiveSkill : ClientHero50011ActiveSkill
ClientHero50011002ActiveSkill = Class(ClientHero50011002ActiveSkill, ClientHero50011ActiveSkill)

function ClientHero50011002ActiveSkill:DeliverCtor()
    self.effectName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_exploision")
end
--- @class ClientHero50011001ActiveSkill : ClientHero50011ActiveSkill
ClientHero50011001ActiveSkill = Class(ClientHero50011001ActiveSkill, ClientHero50011ActiveSkill)

function ClientHero50011001ActiveSkill:DeliverCtor()
    self.effectName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_exploision")
end
--- @class ClientHero40003001ActiveSkill : ClientHero40003ActiveSkill
ClientHero40003001ActiveSkill = Class(ClientHero40003001ActiveSkill, ClientHero40003ActiveSkill)

function ClientHero40003001ActiveSkill:DeliverCtor()
    ClientHero40003ActiveSkill.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_projectile")
end

--- @param index number
function ClientHero40003001ActiveSkill:OnCastEffect(index)
end
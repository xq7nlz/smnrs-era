--- @class ClientHero10004001ActiveSkill : ClientHero10004ActiveSkill
ClientHero10004001ActiveSkill = Class(ClientHero10004001ActiveSkill, ClientHero10004ActiveSkill)

function ClientHero10004001ActiveSkill:DeliverCtor()
    self.effSkillName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_eff_skill")
end

function ClientHero10004001ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(55, function()
        self:CastImpactFromConfig()
    end)
end

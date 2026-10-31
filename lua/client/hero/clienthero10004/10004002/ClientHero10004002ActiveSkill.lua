--- @class ClientHero10004002ActiveSkill : ClientHero10004ActiveSkill
ClientHero10004002ActiveSkill = Class(ClientHero10004002ActiveSkill, ClientHero10004ActiveSkill)

function ClientHero10004002ActiveSkill:DeliverCtor()
    self.effSkillName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_eff_skill")
end

function ClientHero10004002ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(55, function()
        self:CastImpactFromConfig()
    end)
end

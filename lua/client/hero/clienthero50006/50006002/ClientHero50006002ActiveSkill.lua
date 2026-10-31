--- @class ClientHero50006002ActiveSkill : ClientHero50006ActiveSkill
ClientHero50006002ActiveSkill = Class(ClientHero50006002ActiveSkill, ClientHero50006ActiveSkill)

function ClientHero50006002ActiveSkill:DeliverCtor()
    ClientHero50006ActiveSkill.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_projectile")
end

function ClientHero50006002ActiveSkill:OnCastEffect()
    ClientHero50006ActiveSkill.OnCastEffect(self)
    self:SetEnvironment()
end

function ClientHero50006002ActiveSkill:SetEnvironment()
    local effectName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_environment")
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
    effect:SetPosition(PositionConfig.GetBattleCentralPosition())
    effect:Play()
end
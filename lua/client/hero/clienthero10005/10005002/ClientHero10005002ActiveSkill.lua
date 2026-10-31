--- @class ClientHero10005002ActiveSkill : ClientHero10005ActiveSkill
ClientHero10005002ActiveSkill = Class(ClientHero10005002ActiveSkill, ClientHero10005ActiveSkill)

function ClientHero10005002ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_skill").position
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_projectile")
end

function ClientHero10005002ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, ClientConfigUtils.BODY_ANCHOR)
end
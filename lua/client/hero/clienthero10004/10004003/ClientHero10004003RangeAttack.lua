--- @class ClientHero10004003RangeAttack : ClientHero10004RangeAttack
ClientHero10004003RangeAttack = Class(ClientHero10004003RangeAttack, ClientHero10004RangeAttack)

function ClientHero10004003RangeAttack:DeliverCtor()
    ClientHero10004RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
    self.fxImpactConfig.skill_impact_name = "hero_10004_skin_id_10004003_attack_impact"
end

--- @param actionResults List<BaseActionResult>
function ClientHero10004003RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero10004003RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName,
            5 / ClientConfigUtils.FPS,
            nil, self.projectileLaunchPos.position)
end
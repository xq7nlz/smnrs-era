--- @class ClientHero10004002RangeAttack : ClientHero10004RangeAttack
ClientHero10004002RangeAttack = Class(ClientHero10004002RangeAttack, ClientHero10004RangeAttack)

function ClientHero10004002RangeAttack:DeliverCtor()
    ClientHero10004RangeAttack.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_attack_projectile")
end

--- @param actionResults List<BaseActionResult>
function ClientHero10004002RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero10004002RangeAttack:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName,
            5 / ClientConfigUtils.FPS,
            nil, self.projectileLaunchPos.position)
end
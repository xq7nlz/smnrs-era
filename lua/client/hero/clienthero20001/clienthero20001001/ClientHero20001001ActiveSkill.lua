--- @class ClientHero20001001ActiveSkill : ClientHero20001ActiveSkill
ClientHero20001001ActiveSkill = Class(ClientHero20001001ActiveSkill, ClientHero20001ActiveSkill)

function ClientHero20001001ActiveSkill:DeliverCtor()
    ClientHero20001ActiveSkill.DeliverCtor(self)
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_projectile")
end

--- @param actionResults List<BaseActionResult>
function ClientHero20001001ActiveSkill:CastOnTarget(actionResults)
    ClientHero20001ActiveSkill.CastOnTarget(self, actionResults)
    self:SetEnvironment()
end

function ClientHero20001001ActiveSkill:SetEnvironment()
    local effectName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_environment")
    --XDebug.Log("EFFECT NAME " .. effectName)
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
    effect:SetPosition(PositionConfig.GetBattleCentralPosition())
    effect:Play()
end
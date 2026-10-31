--- @class ClientHero30007002ActiveSkill : ClientHero30007ActiveSkill
ClientHero30007002ActiveSkill = Class(ClientHero30007002ActiveSkill, ClientHero30007ActiveSkill)

--- @param actionResults List<BaseActionResult>
function ClientHero30007002ActiveSkill:CastOnTarget(actionResults)
    ClientHero30007ActiveSkill.CastOnTarget(self, actionResults)
    self:SetEnvironment()
end

function ClientHero30007002ActiveSkill:SetEnvironment()
    local effectName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_environment")
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
    effect:SetPosition(PositionConfig.GetBattleCentralPosition())
    effect:Play()
end
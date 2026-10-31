--- @class ClientHero60010001ActiveSkill : ClientHero60010ActiveSkill
ClientHero60010001ActiveSkill = Class(ClientHero60010001ActiveSkill, ClientHero60010ActiveSkill)

function ClientHero60010001ActiveSkill:DeliverCtor()
    ClientHero60010ActiveSkill.DeliverCtor(self)

end

--- @param actionResults List<BaseActionResult>
function ClientHero60010001ActiveSkill:CastOnTarget(actionResults)
    ClientHero60010ActiveSkill.CastOnTarget(self, actionResults)
    self:SetEnvironment()
end

function ClientHero60010001ActiveSkill:SetEnvironment()
    local effectName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_environment")
    -- XDebug.Log("EFFECT NAME " .. effectName)
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
    effect:SetPosition(PositionConfig.GetBattleCentralPosition())
    effect:Play()
end
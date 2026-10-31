--- @class ClientHero30001001ActiveSkill : ClientHero30001ActiveSkill
ClientHero30001001ActiveSkill = Class(ClientHero30001001ActiveSkill, ClientHero30001ActiveSkill)

function ClientHero30001001ActiveSkill:DeliverCtor()
    ClientHero30001ActiveSkill.DeliverCtor(self)
end

--- @param actionResults List<BaseActionResult>
function ClientHero30001001ActiveSkill:CastOnTarget(actionResults)
    self.clientHero:EnableSmokeEffectFx(false)
    ClientHero30001ActiveSkill.CastOnTarget(self, actionResults)
    self:SetEnvironment()
end

function ClientHero30001001ActiveSkill:SetEnvironment()
    local effectName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_environment")
   -- XDebug.Log("EFFECT NAME " .. effectName)
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
    effect:SetPosition(PositionConfig.GetBattleCentralPosition())
    effect:Play()
end

function ClientHero30001001ActiveSkill:OnCompleteActionTurn()
    self.clientHero:EnableSmokeEffectFx(true)
    ClientHero30001ActiveSkill.OnCompleteActionTurn()
end
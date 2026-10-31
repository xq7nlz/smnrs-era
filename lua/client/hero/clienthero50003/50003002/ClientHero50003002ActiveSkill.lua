--- @class ClientHero50003002ActiveSkill : BaseSkillShow
ClientHero50003002ActiveSkill = Class(ClientHero50003002ActiveSkill, BaseSkillShow)

function ClientHero50003002ActiveSkill:DeliverCtor()
    self.fxImpactConfig.skill_impact_name = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_impact")
end

--- @param actionResults List<BaseActionResult>
function ClientHero50003002ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.3)

    self:CastImpactFromConfig()
    self:SetEnvironment()
end

function ClientHero50003002ActiveSkill:OnCastEffect()

end

function ClientHero50003002ActiveSkill:DoAnimation()
    self.clientHero:PlayAnimation(self.animName, false, self.clientHero.mainTrackIndex)
    self.clientHero:PlayAnimationEffectByFrame(self.animName)
    self:PlayFrameAction(self.listFrameAction)
end

function ClientHero50003002ActiveSkill:CastImpactFromConfig()
    if self.fxImpactConfig ~= nil then
        for i = 1, self.listTargetHero:Count() do
            --- @type ClientEffect
            local fxImpact = self:GetClientEffect(self.fxImpactConfig.skill_impact_type, self.fxImpactConfig.skill_impact_name)
            if fxImpact ~= nil then
                local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
                fxImpact:SetToHeroAnchor(clientTargetHero)
            end
        end
    end
end

function ClientHero50003002ActiveSkill:SetEnvironment()
    local effectName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_background")
    -- XDebug.Log("EFFECT NAME " .. effectName)
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
    effect:SetPosition(PositionConfig.GetBattleCentralPosition())
    effect:Play()
end

function ClientHero50003002ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    self.clientHero:TriggerActionResult()
    self:CastSfxImpactFromConfig()
end

function ClientHero50003002ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
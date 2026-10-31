--- @class ClientHero60011ActiveSkill : BaseSkillShow
ClientHero60011ActiveSkill = Class(ClientHero60011ActiveSkill, BaseSkillShow)

function ClientHero60011ActiveSkill:DeliverCtor()
    self.effSkill = string.format("hero_%d_eff_skill_%s", self.baseHero.id, self.clientHero.skinName)
    if self.fxImpactConfig ~= nil then
        self.fxImpactConfig.skill_impact_name = string.format("%s_%s", self.fxImpactConfig.skill_impact_name, self.clientHero.skinName)
    end
end

function ClientHero60011ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(35, function()
        self:CastImpactFromConfig()
        self:CastSfxImpactFromConfig()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero60011ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.4, 1.5, 0.3)

end

function ClientHero60011ActiveSkill:OnCastEffect()
    for i = 1, self.listTargetHero:Count() do
        local effect = self:GetEffect(AssetType.HeroBattleEffect, self.effSkill)
        if effect ~= nil then
            local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            effect:SetToHeroAnchor(self.clientHero)
            effect.configTable.targetSkill.position = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
        end
    end
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName
function ClientHero60011ActiveSkill:GetEffect(effectType, effectName)
    local effect = zg.battleEffectMgr:GetClientEffect(effectType, effectName)
    if effect ~= nil then
        if effect.isInited == false or effect.configTable.targetSkill == nil then
            local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
            effect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
            effect:AddConfigField("targetSkill",  effect:FindChildByPath("Model/SkeletonUtility-Root/root/TargetSkill"))
            effect.isInited = true
        end
        return effect
    end
    return nil
end

function ClientHero60011ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    self.clientHero:TriggerActionResult()
    --BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero60011ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
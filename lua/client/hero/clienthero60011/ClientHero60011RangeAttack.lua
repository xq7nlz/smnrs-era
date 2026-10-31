--- @class ClientHero60011RangeAttack : BaseRangeAttack
ClientHero60011RangeAttack = Class(ClientHero60011RangeAttack, BaseRangeAttack)

function ClientHero60011RangeAttack:DeliverCtor()
    self.effAttack = string.format("hero_%d_eff_attack_%s", self.baseHero.id, self.clientHero.skinName)
    if self.fxImpactConfig ~= nil then
        self.fxImpactConfig.skill_impact_name = string.format("%s_%s", self.fxImpactConfig.skill_impact_name, self.clientHero.skinName)
    end
end

function ClientHero60011RangeAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero60011RangeAttack:OnCastEffect()
    for i = 1, self.listTargetHero:Count() do
        local effect = self:GetEffect(AssetType.HeroBattleEffect, self.effAttack)
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
function ClientHero60011RangeAttack:GetEffect(effectType, effectName)
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

function ClientHero60011RangeAttack:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
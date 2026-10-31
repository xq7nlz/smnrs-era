--- @class ClientHero10025ActiveSkill : BaseSkillShow
ClientHero10025ActiveSkill = Class(ClientHero10025ActiveSkill, BaseSkillShow)

--- @param actionResults List<BaseActionResult>
function ClientHero10025ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1.4, 0.3)

end

function ClientHero10025ActiveSkill:OnCastEffect()
    local effect = self:GetSkillEffect(self.fxImpactConfig.skill_impact_type, self.fxImpactConfig.skill_impact_name)
    --- @type ClientHero
    local clientTargetHero
    if effect ~= nil then
        local listTargetPosition = List()
        for i = 1, self.listTargetHero:Count() do
            clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            listTargetPosition:Add(clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR))
        end
        if listTargetPosition:Count() == 2 then
            effect.configTable.target1.position = listTargetPosition:Get(1)
            effect.configTable.target2.position = listTargetPosition:Get(2)
        elseif listTargetPosition:Count() == 1 then
            effect.configTable.target1.position = listTargetPosition:Get(1)
            effect.configTable.target2.position = listTargetPosition:Get(1)
        end
    end
end

function ClientHero10025ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    --self:CastSfxImpactFromConfig()
    --self.clientHero:TriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName string
function ClientHero10025ActiveSkill:GetSkillEffect(effectType, effectName)
    local effect = zg.battleEffectMgr:GetClientEffect(effectType, effectName)
    if effect ~= nil then
        if effect.isInited == false or effect.configTable.target1 == nil then
            local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
            effect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
            effect:AddConfigField("target1", effect:FindChildByPath("view (1)/SkeletonUtility-Root/target1"))
            effect:AddConfigField("target2", effect:FindChildByPath("view (1)/SkeletonUtility-Root/target2"))
            effect.isInited = true
        end
        effect:Play()
        return effect
    end
    return nil
end

function ClientHero10025ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
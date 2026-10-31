--- @class ClientHero50003ActiveSkill : BaseSkillShow
ClientHero50003ActiveSkill = Class(ClientHero50003ActiveSkill, BaseSkillShow)

function ClientHero50003ActiveSkill:DeliverCtor()
    self.effectName = self.clientHero:GetEffectNameByFormat("hero_%d_eff_skill_%s")
end

--- @param actionResults List<BaseActionResult>
function ClientHero50003ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.3)


    self:CastImpactFromConfig()
end

function ClientHero50003ActiveSkill:OnCastEffect()
    for i = 1, self.listTargetHero:Count() do
        local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
        if clientTargetHero ~= nil then
            local effect = self:GetEffect(AssetType.HeroBattleEffect, self.effectName)
            if effect ~= nil then
                effect:SetToHeroAnchor(self.clientHero)
                effect.configTable.moveSkill.position = clientTargetHero.components:GetHeroAnchor(ClientConfigUtils.FOOT_ANCHOR).position
                effect:Play()
            end
        end
    end
end

function ClientHero50003ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    self.clientHero:TriggerActionResult()
    self:CastSfxImpactFromConfig()
end

function ClientHero50003ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName string
function ClientHero50003ActiveSkill:GetEffect(effectType, effectName)
    local effect = zg.battleEffectMgr:GetClientEffect(effectType, effectName)
    if effect ~= nil then
        if effect.isInited == false or effect.configTable.moveSkill == nil then
            local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
            effect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
            effect.configTable.moveSkill = effect:FindChildByPath("model/SkeletonUtility-Root/root/move_skill")
            effect.isInited = true
        end
        effect:Play()
        return effect
    end
    return nil
end
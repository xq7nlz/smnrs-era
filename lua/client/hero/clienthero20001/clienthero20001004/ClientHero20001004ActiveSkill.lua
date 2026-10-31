--- @class ClientHero20001004ActiveSkill : ClientHero20001ActiveSkill
ClientHero20001004ActiveSkill = Class(ClientHero20001004ActiveSkill, ClientHero20001ActiveSkill)

function ClientHero20001004ActiveSkill:DeliverCtor()
    ClientHero20001ActiveSkill.DeliverCtor(self)
    self.effectName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_eff")
end

function ClientHero20001004ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(25, function()
        self.fxImpactConfig.skill_impact_name = "hero_20001_skin_id_20001004_skill_impact"
        self:CastImpactFromConfig()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero20001004ActiveSkill:CastOnTarget(actionResults)
    ClientHero20001ActiveSkill.CastOnTarget(self, actionResults)
end

function ClientHero20001004ActiveSkill:OnCastEffect()
    for i = 1, self.listTargetHero:Count() do
        local effect = self:GetEffect(AssetType.HeroBattleEffect, self.effectName)
        if effect ~= nil then
            --- @type BaseHero
            local targetHero = self.listTargetHero:Get(i)
            --- @type ClientHero
            local clientHero = self.clientBattleShowController:GetClientHeroByBaseHero(targetHero)
            effect:SetToHeroAnchor(self.clientHero)
            effect.configTable.target.position = clientHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
        end
    end
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName string
function ClientHero20001004ActiveSkill:GetEffect(effectType, effectName)
    local effect = zg.battleEffectMgr:GetClientEffect(effectType, effectName)
    if effect ~= nil then
        if effect.isInited == false or effect.configTable.startSkill == nil then
            local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
            effect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
            effect.configTable.target = effect:FindChildByPath("Model/SkeletonUtility-Root/root/target")
            effect.isInited = true
        end
        return effect
    end
    return nil
end

function ClientHero20001004ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    self:CastSfxImpactFromConfig()
    self.clientHero:TriggerActionResult()
end
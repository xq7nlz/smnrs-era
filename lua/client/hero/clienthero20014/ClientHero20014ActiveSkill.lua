--- @class ClientHero20014ActiveSkill : BaseSkillShow
ClientHero20014ActiveSkill = Class(ClientHero20014ActiveSkill, BaseSkillShow)

function ClientHero20014ActiveSkill:DeliverCtor()
    self.fxSkillName = string.format("hero_%s_eff_skill", self.baseHero.id)
    self.posAnchor = self.clientHero.components:FindChildByPath("Model/pos")
end

--- @param actionResults List<BaseActionResult>
function ClientHero20014ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.7, 1, 0.5)

end

function ClientHero20014ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero20014ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end


function ClientHero20014ActiveSkill:OnCastEffect()
    for i = 1, self.listTargetHero:Count() do
        local target = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
        local fxSkill = self:GetEffect(AssetType.HeroBattleEffect, self.fxSkillName)
        fxSkill:SetToHeroAnchor(self.clientHero)
        fxSkill:SetPosition(self.posAnchor.position)
        fxSkill.configTable.target.position = target.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    end
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName
function ClientHero20014ActiveSkill:GetEffect(effectType, effectName)
    local effect = zg.battleEffectMgr:GetClientEffect(effectType, effectName)
    if effect ~= nil then
        if effect.isInited == false or effect.configTable.targetSkill == nil then
            local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
            effect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
            effect:AddConfigField("target",  effect:FindChildByPath("Model/SkeletonUtility-Root/target"))
            effect.isInited = true
        end
        return effect
    end
    return nil
end
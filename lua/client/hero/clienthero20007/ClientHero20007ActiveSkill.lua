--- @class ClientHero20007ActiveSkill : BaseSkillShow
ClientHero20007ActiveSkill = Class(ClientHero20007ActiveSkill, BaseSkillShow)

function ClientHero20007ActiveSkill:DeliverCtor()
    self.moveBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/move")
end

function ClientHero20007ActiveSkill:DeliverCtor()
    self.effectName = self.clientHero:GetEffectNameByFormat("hero_%d_skill_fox")
end

--- @param actionResults List<BaseActionResult>
function ClientHero20007ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(2, 1, 0.3)
end

function ClientHero20007ActiveSkill:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
end

function ClientHero20007ActiveSkill:OnCastEffect()
    local listTailTarget = List()
    for i = 1, self.listTargetHero:Count() do
        local clientTarget = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
        if listTailTarget:IsContainValue(clientTarget) == false then
            listTailTarget:Add(clientTarget)
            local skillFx = self:GetEffect(AssetType.HeroBattleEffect, self.effectName)
            if skillFx ~= nil then
                skillFx:SetToHeroAnchor(self.clientHero)
                skillFx.configTable.targetSkill.position = clientTarget.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
                skillFx.config.skeletonAnimation.AnimationState:SetAnimation(0, "eff_fox" .. listTailTarget:Count(), false)
            end
        end
    end
end

function ClientHero20007ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName string
function ClientHero20007ActiveSkill:GetEffect(effectType, effectName)
    local effect = zg.battleEffectMgr:GetClientEffect(effectType, effectName)
    if effect ~= nil then
        if effect.isInited == false or effect.configTable.mainEffFire == nil then
            local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
            effect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
            effect.configTable.targetSkill = effect:FindChildByPath("Model/SkeletonUtility-Root/root/TargetSkill")
            effect.isInited = true
        end
        return effect
    end
    return nil
end
--- @class ClientHero20022ActiveSkill : BaseSkillShow
ClientHero20022ActiveSkill = Class(ClientHero20022ActiveSkill, BaseSkillShow)

function ClientHero20022ActiveSkill:DeliverCtor()
    self.animName = "skill_1"
    self.effectName = string.format("hero_%d_skill_hand_%s", self.baseHero.id, self.clientHero.skinName)
end

--- @param actionResults List<BaseActionResult>
function ClientHero20022ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 0.8, 0.3)

end

function ClientHero20022ActiveSkill:OnCastEffect()
    local clientTargetHero
    --- @type ClientEffect
    local effectHand
    local targetPosition
    for i = 1, self.listTargetHero:Count() do
        clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
        effectHand = self:GetEffectHand(AssetType.HeroBattleEffect, self.effectName)
        effectHand:SetToHeroAnchor(self.clientHero)
        targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
        effectHand.configTable.moveBone.position = targetPosition - U_Vector3.right * MathUtils.Sign(targetPosition.x)
    end
end

function ClientHero20022ActiveSkill:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName string
function ClientHero20022ActiveSkill:GetEffectHand(effectType, effectName)
    --- @type ClientEffect
    local effect = zg.battleEffectMgr:GetClientEffect(effectType, effectName)
    if effect == nil then
        assert(false, "There is no client effect ", effectType, effectName)
        return nil
    end
    if effect.isInited == false or effect.configTable.moveBone == nil then
        local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
        effect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
        effect:AddConfigField("moveBone", effect:FindChildByPath("view (1)/SkeletonUtility-Root/root/move_skill"))
        effect.isInited = true
    end
    return effect
end

function ClientHero20022ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
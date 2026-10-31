--- @class ClientHero40016ActiveSkill : BaseSkillShow
ClientHero40016ActiveSkill = Class(ClientHero40016ActiveSkill, BaseSkillShow)

function ClientHero40016ActiveSkill:DeliverCtor()
    self.effectName = string.format("hero_%d_eff_skill_%s", self.baseHero.id, self.clientHero.skinName)
    self.moveSkillBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/move_skill")
    self.offset = U_Vector2(1.5, 0.5)
end

--- @param actionResults List<BaseActionResult>
function ClientHero40016ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    if self.listTargetHero:Count() == 0 then
        BaseSkillShow.OnTriggerActionResult(self)
        BaseSkillShow.OnEndTurn(self)
        return
    end
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1, 0.3)


    self.clientHero.animation:EnableVisual(false)
end

function ClientHero40016ActiveSkill:OnCastEffect()
    --- @type ClientHero
    local clientTargetHero
    --- @type ClientEffect
    local effect
    --- @type UnityEngine_Vector3
    local targetPosition
    for i = 1, self.listTargetHero:Count() do
        effect = self:GetCloneEffect(AssetType.HeroBattleEffect, self.effectName)
        if effect ~= nil then
            clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
            if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
                targetPosition.x = targetPosition.x - self.offset.x
            else
                targetPosition.x = targetPosition.x + self.offset.x
            end
            targetPosition.y = targetPosition.y + self.offset.y
            effect:SetToHeroAnchor(self.clientHero)
            effect.configTable.moveBone.position = targetPosition
        end
    end
end

function ClientHero40016ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero40016ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    self.clientHero.animation:EnableVisual(true)
    BaseSkillShow.OnEndTurn(self)
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName string
function ClientHero40016ActiveSkill:GetCloneEffect(effectType, effectName)
    --- @type ClientEffect
    local effect = zg.battleEffectMgr:GetClientEffect(effectType, effectName)
    if effect == nil then
        assert(false, "There is no client effect ", effectType, effectName)
        return nil
    end
    if effect.isInited == false
    or effect.configTable.moveBone == nil or effect.configTable.moveBone == nil then
        local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
        effect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
        effect:AddConfigField("moveBone", effect:FindChildByPath("GameObject/SkeletonUtility-Root/root/move_skill"))
        effect.isInited = true
    end
    return effect
end

function ClientHero40016ActiveSkill:BreakSkillAction()
    self.clientHero.animation:EnableVisual(true)
    BaseSkillShow.BreakSkillAction(self)
end
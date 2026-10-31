--- @class ClientHero30003ActiveSkill : BaseSkillShow
ClientHero30003ActiveSkill = Class(ClientHero30003ActiveSkill, BaseSkillShow)

function ClientHero30003ActiveSkill:DeliverCtor()
    self.effectName = string.format("hero_%d_eff_skill", self.baseHero.id)
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_2")
    self.offset = U_Vector2(0.5, 0)
    self.targetXich = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/target_xich")

    self.trackingCoroutine = nil
end

--- @param actionResults List<BaseActionResult>
function ClientHero30003ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 2, 0.3)
    --self:CastImpactFromConfig() --hoangpl
end

function ClientHero30003ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
    if ( self.listTargetHero ~= nil) then
        for i = 1, self.listTargetHero:Count() do
            self.clientBattleShowController:ShowAddOrStealStatEffect(ActionResultType.STEAL_STAT,self.baseHero,self.listTargetHero:Get(i),StatType.HP,function()
                self.clientBattleShowController:ShowHealingEffect(self.clientBattleShowController:GetClientHeroByBaseHero(self.baseHero))
            end)
        end
    end
    --self:CastSfxImpactFromConfig() --hoangpl
end

function ClientHero30003ActiveSkill:OnEndTurn()
    self:StopTracking()

    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero30003ActiveSkill:OnCastEffect()
    --- @type ClientHero
    local clientTargetHero
    --- @type ClientEffect
    local effect
    --- @type UnityEngine_Vector3
    local targetPosition
    local listBoneHandAnchor = List()
    for i = 1, self.listTargetHero:Count() do
        effect = self:GetCloneEffect(AssetType.HeroBattleEffect, self.effectName)
        if effect ~= nil then
            clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
            if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
                targetPosition.x = targetPosition.x - self.offset.x
            else
                targetPosition.x = targetPosition.x + self.offset.x
            end
            targetPosition.y = targetPosition.y + self.offset.y
            effect:SetToHeroAnchor(clientTargetHero)
            effect.configTable.bondHand.position = self.projectileLaunchPos.position
            effect.configTable.moveTarget.position = targetPosition
            listBoneHandAnchor:Add(effect.configTable.bondHand)
        end
    end
    self:DoFollowFxCoroutine(listBoneHandAnchor:GetItems())
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName string
function ClientHero30003ActiveSkill:GetCloneEffect(effectType, effectName)
    --- @type ClientEffect
    local effect = zg.battleEffectMgr:GetClientEffect(effectType, effectName)
    if effect == nil then
        assert(false, "There is no client effect ", effectType, effectName)
        return nil
    end
    if effect.isInited == false
            or effect.configTable.bondHand == nil or effect.configTable.moveTarget == nil then
        local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
        effect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
        effect:AddConfigField("bondHand", effect:FindChildByPath("GameObject/SkeletonUtility-Root/root/bone_hand"))
        effect:AddConfigField("moveTarget", effect:FindChildByPath("GameObject/SkeletonUtility-Root/root/move_target"))
        effect.isInited = true
    end
    return effect
end

--- @param listBoneHandAnchor table
function ClientHero30003ActiveSkill:DoFollowFxCoroutine(listBoneHandAnchor)
    self:StopTracking()

    self.trackingCoroutine = Coroutine.start(function()
        while true do
            coroutine.waitforendofframe()
            --- @param v UnityEngine_Transform
            for k, v in pairs(listBoneHandAnchor) do
                v.position = self.targetXich.position
            end
        end
    end)
end

function ClientHero30003ActiveSkill:StopTracking()
    if self.trackingCoroutine then
        Coroutine.stop(self.trackingCoroutine)
        self.trackingCoroutine = nil
    end
end
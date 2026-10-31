--- @class ClientHero40005ActiveSkill : BaseSkillShow
ClientHero40005ActiveSkill = Class(ClientHero40005ActiveSkill, BaseSkillShow)

function ClientHero40005ActiveSkill:DeliverCtor()
    self.effectName = string.format("hero_%d_eff_skill", self.baseHero.id)
    self.impactName = string.format("hero_%d_skillfx", self.baseHero.id)

    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        self.projectileLaunchPos = Vector2(-2.5, 4)
    elseif self.baseHero.teamId == BattleConstants.DEFENDER_TEAM_ID then
        self.projectileLaunchPos = Vector2(2.5, 4)
    end

    self.boneFxGlow = self.clientHero.components:FindChildByPath("Model/fxglow")
    local pos = self.clientHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    pos.x = self.projectileLaunchPos.x
    pos.y = self.projectileLaunchPos.y
    self.boneFxGlow.transform.position = pos

    self.delayBambo = 0.15

    self._bambooTweener = nil
end

--- @param actionResults List<BaseActionResult>
function ClientHero40005ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 2, 1)

end

function ClientHero40005ActiveSkill:OnCastEffect()
    self:SetUpBambooTimingAction()
end

function ClientHero40005ActiveSkill:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
end

function ClientHero40005ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero40005ActiveSkill:SetUpBambooTimingAction()
    ClientConfigUtils.KillCoroutine(self._bambooTweener)
    self._bambooTweener = Coroutine.start(function()
        local listTargets = self.listTargetHero
        for i = 1, listTargets:Count() do
            Coroutine.start(function()
                local delay = self.delayBambo * (i - 1)
                local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(listTargets:Get(i))
                coroutine.waitforseconds(delay)
                local effect = self:GetEffect(AssetType.HeroBattleEffect, self.effectName)
                if effect ~= nil then
                    effect:SetToHeroAnchor(clientTargetHero)
                    effect.configTable.startSkill.position = self.boneFxGlow.position
                end

                coroutine.waitforseconds(1.5)
                local effImpact = self:GetClientEffect(AssetType.HeroBattleEffect, self.impactName)
                effImpact:SetToHeroAnchor(clientTargetHero)
            end)
        end
    end)
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName string
function ClientHero40005ActiveSkill:GetEffect(effectType, effectName)
    local effect = zg.battleEffectMgr:GetClientEffect(effectType, effectName)
    if effect ~= nil then
        if effect.isInited == false or effect.configTable.startSkill == nil then
            local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
            effect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
            effect.configTable.startSkill = effect:FindChildByPath("Model/SkeletonUtility-Root/root/start_skill")
            effect.isInited = true
        end
        return effect
    end
    return nil
end
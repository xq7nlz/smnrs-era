--- @class ClientHero40017ActiveSkill : BaseSkillShow
ClientHero40017ActiveSkill = Class(ClientHero40017ActiveSkill, BaseSkillShow)

function ClientHero40017ActiveSkill:DeliverCtor()
    self.boneDauLau = self.clientHero.components:FindChildByPath("Model/launch_position")
    self.impactName = string.format("hero_%d_impactskill", self.baseHero.id)
    self.effectName = string.format("hero_%d_skill_eff", self.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero40017ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1, 0.3)

end

function ClientHero40017ActiveSkill:OnCastEffect()
    local clientTargetHero
    for i = 1, self.listTargetHero:Count() do
        clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
        self:CastLazer(self.boneDauLau.position, clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR))
    end
end

function ClientHero40017ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero40017ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero40017ActiveSkill:CastLazer(fromPos, toPos)
    local impact1 = self:GetClientEffect(AssetType.HeroBattleEffect, self.impactName)
    impact1:SetPosition(fromPos)
    impact1:LookAtPosition(fromPos)
    impact1:DoMoveTween(toPos, 0.17)
    impact1:SetActive(true)

    local impact2 = self:GetClientEffect(AssetType.HeroBattleEffect, self.impactName)
    impact2:SetPosition(fromPos)
    impact2:LookAtPosition(fromPos)
    impact2:SetActive(true)

    local effect = self:GetEffect(AssetType.HeroBattleEffect, self.effectName)
    if effect ~= nil then
        effect.configTable.lazer.startWidth = 1
        effect.configTable.lazer:SetPosition(0, fromPos)
        effect.configTable.lazer:SetPosition(1, fromPos)

        effect:MoveLineRendererPointIndexToPosition(effect.configTable.lazer, 0, toPos, 0.14, 0, nil)
        effect:TweenLineRendererWidth(effect.configTable.lazer, 0, 0.15, 0.5, function()
            effect:Release()
            impact1:Release()
            impact2:Release()
        end)
    end
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName string
function ClientHero40017ActiveSkill:GetEffect(effectType, effectName)
    local effect = zg.battleEffectMgr:GetClientEffect(effectType, effectName)
    if effect ~= nil then
        if effect.isInited == false or effect.configTable.lazer == nil then
            local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
            effect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
            effect.configTable.lazer = effect.config.gameObject:GetComponent(ComponentName.UnityEngine_LineRenderer)
            effect.isInited = true
        end
        effect:Play()
        return effect
    end
    return nil
end
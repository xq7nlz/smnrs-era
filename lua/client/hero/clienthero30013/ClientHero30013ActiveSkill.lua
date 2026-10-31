--- @class ClientHero30013ActiveSkill : BaseSkillShow
ClientHero30013ActiveSkill = Class(ClientHero30013ActiveSkill, BaseSkillShow)

function ClientHero30013ActiveSkill:DeliverCtor()
    self.boneDauLau = self.clientHero.components:FindChildByPath("Model/dau_lau")
    self.impactName = string.format("hero_%d_impactskill", self.baseHero.id)
    self.effectName = string.format("hero_%d_eff_skill", self.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero30013ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 0.8, 0.5)

end

function ClientHero30013ActiveSkill:OnCastEffect()
    local clientTargetHero
    for i = 1, self.listTargetHero:Count() do
        clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
        self:CastLazer(self.boneDauLau.position, clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR))
    end
end

function ClientHero30013ActiveSkill:CastLazer(fromPos, toPos)
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
function ClientHero30013ActiveSkill:GetEffect(effectType, effectName)
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

function ClientHero30013ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
--- @class ClientHero30008ActiveSkill : BaseSkillShow
ClientHero30008ActiveSkill = Class(ClientHero30008ActiveSkill, BaseSkillShow)

function ClientHero30008ActiveSkill:DeliverCtor()
    self.fxSkillName = string.format("hero_%s_fx_skill", self.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero30008ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1.5, 0.5, 0.5, ClientConfigUtils.DEFAULT_COVER_ALPHA)

end

function ClientHero30008ActiveSkill:OnCastEffect()
    --- @type ClientEffect
    local effect = self:GetEffect(AssetType.HeroBattleEffect, self.fxSkillName)
    effect:SetToHeroAnchor(self.clientHero)
    --- @type BaseHero
    local target = self.listTargetHero:Get(1)
    --- @type PositionInfo
    local posInfo = target.positionInfo
    --- @type HeroDataService
    local heroDataService = ResourceMgr.GetServiceConfig():GetBattle():GetHeroDataService()
    --- @type FormationData
    local formationData = heroDataService.formationDataEntries:Get(posInfo.formationId)
    local numberOfTargetInLine = formationData.frontLine
    if posInfo.isFrontLine ~= true then
        numberOfTargetInLine = formationData.backLine
    end
    local firstPos = PositionConfig.GetPosition(target.teamId, posInfo.formationId, posInfo.isFrontLine, 1)
    local secPos = PositionConfig.GetPosition(target.teamId, posInfo.formationId, posInfo.isFrontLine, numberOfTargetInLine)
    effect.configTable.targetBot.position = firstPos
    effect.configTable.targetTop.position = secPos
    local centerPos = PositionConfig.GetCenterTeamPosition(target.teamId)
    effect.configTable.targetBetween.position = centerPos

    Coroutine.start(function ()
        coroutine.waitforseconds(43 / ClientConfigUtils.FPS)
        self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
        coroutine.waitforseconds(6 / ClientConfigUtils.FPS)
        self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
        coroutine.waitforseconds(6 / ClientConfigUtils.FPS)
        self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    end)
end

function ClientHero30008ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

--- @return {targetTop : UnityEngine_Transform, targetBot:UnityEngine_Transform, targetBetween:UnityEngine_Transform}
function ClientHero30008ActiveSkill:GetEffect(effectType, effectName)
    local effect = zg.battleEffectMgr:GetClientEffect(AssetType.HeroBattleEffect, self.fxSkillName)
    if effect == nil then
        assert(false, "There is no client effect ", effectType, effectName)
        return nil
    end
    if effect.isInited == false or effect.configTable.moveSkill == nil then
        local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
        effect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
        effect:AddConfigField("targetTop", effect:FindChildByPath("model/SkeletonUtility-Root/root/target_top"))
        effect:AddConfigField("targetBot", effect:FindChildByPath("model/SkeletonUtility-Root/root/target_bot"))
        effect:AddConfigField("targetBetween", effect:FindChildByPath("model/SkeletonUtility-Root/root/target_between"))
        effect.isInited = true
    end
    return effect
end
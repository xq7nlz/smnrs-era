--- @class ClientHero10006ActiveSkill : BaseSkillShow
ClientHero10006ActiveSkill = Class(ClientHero10006ActiveSkill, BaseSkillShow)

function ClientHero10006ActiveSkill:DeliverCtor()
    self.projectileName = string.format("hero_%d_skill_background", self.baseHero.id)
    self.targetMoveSkillBonePos = self:SetTargetMoveSkill()
end

--- @param actionResults List<BaseActionResult>
function ClientHero10006ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.7, 0.5, 0.3)
end

function ClientHero10006ActiveSkill:OnCastEffect()
    local projectile = self:GetClientEffect(AssetType.HeroBattleEffect, self.projectileName)
    if projectile ~= nil then
        projectile:SetPosition(self.targetMoveSkillBonePos)
        projectile:Play()
    end
end

function ClientHero10006ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero10006ActiveSkill:SetTargetMoveSkill()
    local bonePos
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        bonePos = PositionConfig.GetCenterTeamPosition(BattleConstants.DEFENDER_TEAM_ID)
    else
        bonePos = PositionConfig.GetCenterTeamPosition(BattleConstants.ATTACKER_TEAM_ID)
    end
    return bonePos
end

function ClientHero10006ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    self.clientHero.animation:UpdateLayer(self.clientHero.originPosition.y)
    BaseSkillShow.OnEndTurn(self)
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName string
function ClientHero10006ActiveSkill:GetEffect(effectType, effectName)
    --- @type ClientEffect
    local effect = self:GetClientEffect(effectType, effectName)
    if effect == nil then
        assert(false, "There is no client effect ", effectType, effectName)
        return nil
    end
    if effect.isInited == false or effect.configTable.moveSkill == nil then
        local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
        effect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
        effect:AddConfigField("moveSkill", effect:FindChildByPath("model/SkeletonUtility-Root/root/move_skill"))
        effect.isInited = true
    end
    return effect
end
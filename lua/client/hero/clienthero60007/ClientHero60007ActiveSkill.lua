--- @class ClientHero60007ActiveSkill : BaseSkillShow
ClientHero60007ActiveSkill = Class(ClientHero60007ActiveSkill, BaseSkillShow)

function ClientHero60007ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_skill")
    self.projectileName = string.format("hero_%d_%s", self.baseHero.id, ClientConfigUtils.DEFAULT_SKILL_PROJECTILE)
    self.fxSkillName = string.format("hero_%d_fx_skill", self.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero60007ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.3)

end

function ClientHero60007ActiveSkill:OnCastEffect()
    for i = 1, self.listTargetHero:Count() do
        local effect = self:GetEffect(AssetType.HeroBattleEffect, self.effAttack)
        if effect ~= nil then
            local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            effect:SetPosition(self.projectileLaunchPos.position)
            effect.configTable.target.position = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
            effect:Play()
        end
    end
end

function ClientHero60007ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero60007ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero60007ActiveSkill:GetEffect()
    local effect = zg.battleEffectMgr:GetClientEffect(AssetType.HeroBattleEffect, self.fxSkillName)
    if effect ~= nil then
        if effect.isInited == false or effect.configTable.targetSkill == nil then
            local luaConfigFile = ResourceMgr.GetEffectLuaConfig(self.fxSkillName)
            effect:InitRef(AssetType.HeroBattleEffect, self.fxSkillName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
            effect:AddConfigField("target", effect:FindChildByPath("visual/SkeletonUtility-Root/target"))
            effect.isInited = true
        end
        return effect
    end
    return nil
end
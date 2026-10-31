--- @class ClientHero40020ActiveSkill : BaseSkillShow
ClientHero40020ActiveSkill = Class(ClientHero40020ActiveSkill, BaseSkillShow)

function ClientHero40020ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_skill_position").position
    self.projectileName = string.format("hero_%d_skill_projectile", self.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero40020ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 0.8, 0.5)

end

function ClientHero40020ActiveSkill:OnCastEffect()
    --- @type ClientEffect
    local effect
    --- @type ClientHero
    local clientTargetHero
    for i = 1, self.listTargetHero:Count() do
        effect = self:GetEffect(AssetType.HeroBattleEffect, self.projectileName)
        if effect ~= nil then
            clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            effect.configTable.lightningStart.position = self.projectileLaunchPos
            effect.configTable.lightningEnd.position = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
        end
    end
end

--- @return ClientEffect
--- @param effectType number
--- @param effectName string
function ClientHero40020ActiveSkill:GetEffect(effectType, effectName)
    local effect = zg.battleEffectMgr:GetClientEffect(effectType, effectName)
    if effect ~= nil then
        if effect.isInited == false or effect.lightningStart == nil then
            local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
            effect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
            effect:AddConfigField("lightningStart", effect:FindChildByPath("lightning_start"))
            effect:AddConfigField("lightningEnd", effect:FindChildByPath("lightning_end"))
            effect.isInited = true
        end
        effect:Play()
    end
    return effect
end

function ClientHero40020ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
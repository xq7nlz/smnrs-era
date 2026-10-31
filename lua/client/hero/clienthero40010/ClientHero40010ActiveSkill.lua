--- @class ClientHero40010ActiveSkill : BaseSkillShow
ClientHero40010ActiveSkill = Class(ClientHero40010ActiveSkill, BaseSkillShow)

function ClientHero40010ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position").position
end

--- @param actionResults List<BaseActionResult>
function ClientHero40010ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1.3, 0.5)

end

function ClientHero40010ActiveSkill:OnCastEffect()
    local opponentTeamId = 0
    if self.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        opponentTeamId = BattleConstants.DEFENDER_TEAM_ID
    else
        opponentTeamId = BattleConstants.ATTACKER_TEAM_ID
    end
    local bounceToPosition = PositionConfig.GetCenterTeamPosition(opponentTeamId)
    local projectile = self:GetProjectile(AssetType.HeroBattleEffect, self.projectileName)
    projectile.configTable.bounceBezier:DoBounceTarget(projectile.config.transform, self.projectileLaunchPos, bounceToPosition, 1, function()
        self:OnTriggerActionResult()
        SmartPool.Instance:DespawnGameObject(AssetType.GeneralBattleEffect, "bounce_bezier", projectile.configTable.bounceBezier.transform)
        projectile:Release()
    end, 2)
end

function ClientHero40010ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

--- @return ClientEffect
--- @param effectType number
--- @param effectName string
function ClientHero40010ActiveSkill:GetProjectile(effectType, effectName)
    local effect = self:GetClientEffect(effectType, effectName)
    local bounceBezierObject = SmartPool.Instance:SpawnGameObject(AssetType.GeneralBattleEffect, "bounce_bezier")
    effect:AddConfigField("bounceBezier", bounceBezierObject:GetComponent(ComponentName.BezierSpline))
    effect:Play()
    return effect
end

function ClientHero40010ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
--- @class ClientHero10002ActiveSkill : BaseSkillShow
ClientHero10002ActiveSkill = Class(ClientHero10002ActiveSkill, BaseSkillShow)

function ClientHero10002ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/bone_gun_shooter/launch_position")
    self.targetPosition = nil
    self.fxExplosionName = string.format("hero_%s_explosion", self.baseHero.id)
    self.skillTargetBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/skill_target")
    self.launchSkillBone = self.clientHero.components:FindChildByPath("Model/launch_skill_position")

    --- @type ClientEffect
    self.projectile = nil
end

function ClientHero10002ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(76, function()
        self:CastImpactFromConfig()
    end)
end

--- @param actionResults List<BaseActionResult>
function ClientHero10002ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1.2, 0.7, 0.3)

    if self.clientHero.baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        self.targetPosition = PositionConfig.GetCenterTeamPosition(BattleConstants.DEFENDER_TEAM_ID)
    else
        self.targetPosition = PositionConfig.GetCenterTeamPosition(BattleConstants.ATTACKER_TEAM_ID)
    end
    self.targetPosition = self.targetPosition + U_Vector3.up * 10
    self.skillTargetBone.position = self.targetPosition
end

function ClientHero10002ActiveSkill:OnCastEffect()
    local pos = PositionConfig.GetOpponentCenterTeamPosition(self.baseHero.teamId)

    self.projectile = self:GetProjectile(AssetType.HeroBattleEffect, self.projectileName)
    self.projectile.configTable.bounceBezier:DoBounceTarget(self.projectile.config.transform, self.projectileLaunchPos.position, pos, 30 / ClientConfigUtils.FPS,
            function()
                self:ReleaseProjectile()

                local explosionFx = self:GetClientEffect(AssetType.HeroBattleEffect, self.fxExplosionName)
                explosionFx:SetPosition(pos)
                explosionFx:Play()
            end, 5)
end

function ClientHero10002ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_NORMAL)
    self:CastSfxImpactFromConfig()
    self.clientHero:TriggerActionResult()
end

function ClientHero10002ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero10002ActiveSkill:BreakSkillAction()
    BaseSkillShow.BreakSkillAction(self)
    self:ReleaseProjectile(true)
end

--- @return ClientEffect
--- @param effectType number
--- @param effectName string
function ClientHero10002ActiveSkill:GetProjectile(effectType, effectName)
    local effect = self:GetClientEffect(effectType, effectName)
    local bounceBezierObject = SmartPool.Instance:SpawnGameObject(AssetType.GeneralBattleEffect, "bounce_bezier")
    effect:AddConfigField("bounceBezier", bounceBezierObject:GetComponent(ComponentName.BezierSpline))
    effect:Play()
    return effect
end

--- @param killAction boolean
function ClientHero10002ActiveSkill:ReleaseProjectile(killAction)
    if self.projectile ~= nil then
        SmartPool.Instance:DespawnGameObject(AssetType.GeneralBattleEffect, "bounce_bezier", self.projectile.configTable.bounceBezier.transform)
        self.projectile.configTable.bounceBezier:StopBounceTweener()
        self.projectile:Release()
        if killAction == true then
            self.projectile:KillAction()
        end
        self.projectile = nil
    end
end
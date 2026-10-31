--- @class ClientHero30008001ActiveSkill : BaseSkillShow
ClientHero30008001ActiveSkill = Class(ClientHero30008001ActiveSkill, BaseSkillShow)

function ClientHero30008001ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position")
    self.projectileName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_skill_projectile")
end

--- @param actionResults List<BaseActionResult>
function ClientHero30008001ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
    self:DoCoverBattle(1.5, 0.5, 0.5, ClientConfigUtils.DEFAULT_COVER_ALPHA)
end

function ClientHero30008001ActiveSkill:OnCastEffect()

    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName,
            20 / ClientConfigUtils.FPS,
            ClientConfigUtils.FOOT_ANCHOR,
            self.projectileLaunchPos.position)

    Coroutine.start(function()
        coroutine.waitforseconds(43 / ClientConfigUtils.FPS)
        self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
        coroutine.waitforseconds(6 / ClientConfigUtils.FPS)
        self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
        coroutine.waitforseconds(6 / ClientConfigUtils.FPS)
        self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    end)
end

--- @param effectType string
--- @param effectName string
--- @param flyTime number
--- @param targetAnchorId number
function ClientHero30008001ActiveSkill:CastNewProjectileOnTargets(effectType, effectName, flyTime, targetAnchorId, launchPos)
    flyTime = flyTime or ClientConfigUtils.PROJECTILE_FRY_TIME
    targetAnchorId = targetAnchorId or ClientConfigUtils.BODY_ANCHOR
    launchPos = launchPos or self.projectileLaunchPos
    effectName = effectName or self.projectileName
    --- @type ClientHero
    local clientTargetHero
    --- @type ClientEffect
    local targetPosition
    local projectile = self:GetProjectile(AssetType.HeroBattleEffect, self.projectileName)
    for i = 1, self.listTargetHero:Count() do
        if projectile ~= nil then
            clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            if clientTargetHero ~= nil then

                targetPosition = clientTargetHero.components:GetAnchorPosition(targetAnchorId)
                projectile.configTable.bounceBezier:DoBounceTarget(projectile.config.transform, self.projectileLaunchPos.position, targetPosition, 1, function()
                    self:OnTriggerActionResult()
                    SmartPool.Instance:DespawnGameObject(AssetType.GeneralBattleEffect, "bounce_bezier", projectile.configTable.bounceBezier.transform)
                    projectile:Release()
                end, 1.7)

            end
        end
    end
end

--- @return ClientEffect
--- @param effectType number
--- @param effectName string
function ClientHero30008001ActiveSkill:GetProjectile(effectType, effectName)
    local effect = self:GetClientEffect(effectType, effectName)
    local bounceBezierObject = SmartPool.Instance:SpawnGameObject(AssetType.GeneralBattleEffect, "bounce_bezier")
    effect:AddConfigField("bounceBezier", bounceBezierObject:GetComponent(ComponentName.BezierSpline))
    effect:Play()
    return effect
end

function ClientHero30008001ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

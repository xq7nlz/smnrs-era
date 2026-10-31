--- @class ClientHero50001RangeAttack : BaseRangeAttack
ClientHero50001RangeAttack = Class(ClientHero50001RangeAttack, BaseRangeAttack)

function ClientHero50001RangeAttack:DeliverCtor()
    --- @type ClientEffect
    self.projectile = nil
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position")
end

function ClientHero50001RangeAttack:OnCastEffect()
    local bounceToPosition = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1)).components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    self.projectile = self:GetProjectile(AssetType.HeroBattleEffect, self.projectileName)
    self.projectile.configTable.bounceBezier:DoBounceTarget(self.projectile.config.transform, self.projectileLaunchPos.position, bounceToPosition, 0.7, function()
        self:OnTriggerActionResult()
        self:ReleaseProjectile()
    end)
end

--- @return ClientEffect
--- @param effectType number
--- @param effectName string
function ClientHero50001RangeAttack:GetProjectile(effectType, effectName)
    local effect = self:GetClientEffect(effectType, effectName)
    local bounceBezierObject = SmartPool.Instance:SpawnGameObject(AssetType.GeneralBattleEffect, "bounce_bezier")
    effect:AddConfigField("bounceBezier", bounceBezierObject:GetComponent(ComponentName.BezierSpline))
    effect:Play()
    return effect
end

function ClientHero50001RangeAttack:BreakSkillAction()
    BaseRangeAttack.BreakSkillAction(self)
    self:ReleaseProjectile(true)
end

--- @param killAction boolean
function ClientHero50001RangeAttack:ReleaseProjectile(killAction)
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
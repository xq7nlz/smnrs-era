--- @class ClientHero50018RangeAttack : BaseRangeAttack
ClientHero50018RangeAttack = Class(ClientHero50018RangeAttack, BaseRangeAttack)

function ClientHero50018RangeAttack:DeliverCtor()
    --- @type ClientEffect
    self.projectile = nil
    self.projectileLaunchPos = self.clientHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
end

function ClientHero50018RangeAttack:OnCastEffect()
    local clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
    local targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
    self.projectile = self:GetEffect(AssetType.HeroBattleEffect, self.projectileName)
    self.projectile.configTable.bounceBezier:DoBounceTarget(self.projectile.config.transform, self.projectileLaunchPos, targetPosition, 0.7, function ()
        self:OnTriggerActionResult()
        self:ReleaseProjectile()
    end)
end

--- @return ClientEffect
--- @param effectType number
--- @param effectName string
function ClientHero50018RangeAttack:GetEffect(effectType, effectName)
    local effect = self:GetClientEffect(effectType, effectName)
    local bounceBezierObject = SmartPool.Instance:SpawnGameObject(AssetType.GeneralBattleEffect, "bounce_bezier")
    effect:AddConfigField("bounceBezier", bounceBezierObject:GetComponent(ComponentName.BezierSpline))
    effect:Play()
    return effect
end

function ClientHero50018RangeAttack:BreakSkillAction()
    BaseRangeAttack.BreakSkillAction(self)
    self:ReleaseProjectile(true)
end

--- @param killAction boolean
function ClientHero50018RangeAttack:ReleaseProjectile(killAction)
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
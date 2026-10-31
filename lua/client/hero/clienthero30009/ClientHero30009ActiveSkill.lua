--- @class ClientHero30009ActiveSkill : BaseSkillShow
ClientHero30009ActiveSkill = Class(ClientHero30009ActiveSkill, BaseSkillShow)

function ClientHero30009ActiveSkill:DeliverCtor()
    --- @type ClientEffect
    self.projectile = nil
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/skill_launch_position")
end

--- @param actionResults List<BaseActionResult>
function ClientHero30009ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1.3, 0.3)

end

function ClientHero30009ActiveSkill:OnCastEffect()
    local clientTargetHero
    local targetPosition

    for i = 1, self.listTargetHero:Count() do
        clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
        targetPosition = clientTargetHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
        self.projectile = self:GetProjectile(AssetType.HeroBattleEffect, self.projectileName)
        self.projectile.configTable.bounceBezier:DoBounceTarget(self.projectile.config.transform, self.projectileLaunchPos.position, targetPosition, 1.5, function()
            self:ReleaseProjectile()
        end, 5)
    end
end

function ClientHero30009ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

--- @return ClientEffect
--- @param effectType number
--- @param effectName string
function ClientHero30009ActiveSkill:GetProjectile(effectType, effectName)
    local effect = self:GetClientEffect(effectType, effectName)
    local bounceBezierObject = SmartPool.Instance:SpawnGameObject(AssetType.GeneralBattleEffect, "bounce_bezier")
    effect:AddConfigField("bounceBezier", bounceBezierObject:GetComponent(ComponentName.BezierSpline))
    effect:Play()
    return effect
end

function ClientHero30009ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero30009ActiveSkill:BreakSkillAction()
    BaseSkillShow.BreakSkillAction(self)
    self:ReleaseProjectile(true)
end

--- @param killAction boolean
function ClientHero30009ActiveSkill:ReleaseProjectile(killAction)
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
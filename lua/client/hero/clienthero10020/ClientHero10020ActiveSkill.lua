--- @class ClientHero10020ActiveSkill : BaseSkillShow
ClientHero10020ActiveSkill = Class(ClientHero10020ActiveSkill, BaseSkillShow)

function ClientHero10020ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    self.projectileLaunchPos = Vector2(self.projectileLaunchPos.x, 14)

    self.delayProjectile = 0.15
    self.fxImpactName = string.format("hero_%d_skill_impact", self.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero10020ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.7, 1, 0.5)

end

function ClientHero10020ActiveSkill:OnCastEffect()
    Coroutine.start(function()
        local delay = 0
        local clientTargetHero
        for i = 1, self.listTargetHero:Count() do
            delay = self.delayProjectile * (i - 1)
            clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            self:CastProjectileFromSky(self.projectileLaunchPos, clientTargetHero)
            coroutine.waitforseconds(delay)
        end
    end)
end

function ClientHero10020ActiveSkill:OnTriggerActionResult()
    self.clientHero:TriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
end

--- @param fromPos Vector2
--- @param toTargetHero ClientHero
function ClientHero10020ActiveSkill:CastProjectileFromSky(fromPos, toTargetHero)
    local projectile = self:GetClientEffect(AssetType.HeroBattleEffect, self.projectileName)
    local fxImpact
    if projectile ~= nil then
        local targetPosition = toTargetHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
        projectile:SetPosition(self.projectileLaunchPos)
        projectile:LookAtPosition(targetPosition)
        projectile:DoMoveTween(targetPosition, ClientConfigUtils.PROJECTILE_FRY_TIME, function()
            projectile:Release()
            fxImpact = self:GetClientEffect(AssetType.HeroBattleEffect, self.fxImpactName)
            fxImpact:SetToHeroAnchor(toTargetHero)
            self:CastSfxImpactFromConfig()
        end)
        projectile:Play()
    end
end

function ClientHero10020ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
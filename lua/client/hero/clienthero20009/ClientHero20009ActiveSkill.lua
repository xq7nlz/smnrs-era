--- @class ClientHero20009ActiveSkill : BaseSkillShow
ClientHero20009ActiveSkill = Class(ClientHero20009ActiveSkill, BaseSkillShow)

function ClientHero20009ActiveSkill:DeliverCtor()
    self.targetFxBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/target_fx")
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position")
end

--- @param actionResults List<BaseActionResult>
function ClientHero20009ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1.5, 0.8, 0.4)
end

function ClientHero20009ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero20009ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

function ClientHero20009ActiveSkill:OnCastEffect()
    local opponentPos = PositionConfig.GetOpponentCenterTeamPosition(self.baseHero.teamId)

    self.targetFxBone.position = opponentPos
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect,
            self.projectileName, 5 / ClientConfigUtils.FPS, self.projectileLaunchPos.position, opponentPos)
end

--- @param effectType string
--- @param effectName string
--- @param flyTime number
function ClientHero20009ActiveSkill:CastNewProjectileOnTargets(effectType, effectName, flyTime, launchPos, opponentPos)
    local projectile = self:GetClientEffect(effectType, effectName)
    projectile:SetPosition(launchPos)
    projectile:LookAtPosition(opponentPos)
    projectile:DoMoveTween(opponentPos, flyTime, function()
        projectile:Release()
    end)
    projectile:Play()
end

function ClientHero20009ActiveSkill:CastImpactFromConfig()
    BaseSkillShow.CastImpactFromConfig(self)

    --- @type ClientEffect
    local fxImpact
    if (self.clientHero.skinId == 20009001) then
        fxImpact = self:GetClientEffect(AssetType.HeroBattleEffect, "hero_20009_skin_id_20009001_skill_explosion")
        else
        fxImpact = self:GetClientEffect(AssetType.HeroBattleEffect, "hero_20009_skill_explosion")
    end
    fxImpact:SetPosition(self.targetFxBone.position)
    fxImpact:Play()
end
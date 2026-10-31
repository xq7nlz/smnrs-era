--- @class ClientHero20001ActiveSkill : BaseSkillShow
ClientHero20001ActiveSkill = Class(ClientHero20001ActiveSkill, BaseSkillShow)

function ClientHero20001ActiveSkill:DeliverCtor()
    self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_skill_position")
end

--- @param actionResults List<BaseActionResult>
function ClientHero20001ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 1, 0.3)

end

function ClientHero20001ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName,
            20 / ClientConfigUtils.FPS,
            ClientConfigUtils.FOOT_ANCHOR,
            self.projectileLaunchPos.position)
end

function ClientHero20001ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero20001ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end

--- @param effectType string
--- @param effectName string
--- @param flyTime number
--- @param targetAnchorId number
function ClientHero20001ActiveSkill:CastNewProjectileOnTargets(effectType, effectName, flyTime, targetAnchorId, launchPos)
    flyTime = flyTime or ClientConfigUtils.PROJECTILE_FRY_TIME
    targetAnchorId = targetAnchorId or ClientConfigUtils.FOOT_ANCHOR
    launchPos = launchPos or self.projectileLaunchPos.position
    effectName = effectName or self.projectileName
    --- @type ClientHero
    local clientTargetHero
    --- @type ClientEffect
    local targetPosition
    for i = 1, self.listTargetHero:Count() do
        local projectile = self:GetClientEffect(effectType, effectName)
        if projectile ~= nil then
            clientTargetHero = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(i))
            targetPosition = clientTargetHero.components:GetAnchorPosition(targetAnchorId)
            projectile:SetPosition(launchPos)
            projectile.config.transform.rotation = self.clientHero.components:Rotation()
            projectile:DoMoveTween(targetPosition, flyTime, function ()
                projectile:Release()
            end)
            projectile:Play()
        end
    end
end
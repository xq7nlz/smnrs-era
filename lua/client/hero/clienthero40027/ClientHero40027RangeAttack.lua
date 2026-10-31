--- @class ClientHero40027RangeAttack : BaseRangeAttack
ClientHero40027RangeAttack = Class(ClientHero40027RangeAttack, BaseRangeAttack)

function ClientHero40027RangeAttack:DeliverCtor()
    self.projectileLaunchHumanPos = self.clientHero.components:FindChildByPath("Model/launch_position")
    self.projectileLaunchDragonPos = self.clientHero.components:FindChildByPath("DragonForm/launch_position")
    self.isAfterTransform = true
end

function ClientHero40027RangeAttack:OnCastEffect()
    if self.clientHero.isDragonForm then
        local opponentPos = PositionConfig.GetOpponentCenterTeamPosition(self.baseHero.teamId)
        self.projectileName = "hero_40027_attack_cast_dragon"
        self:CastDragonBreathOnTargets(AssetType.HeroBattleEffect,
                self.projectileName, self.projectileLaunchDragonPos.position, opponentPos)
    else
        self.projectileName = "hero_40027_attack_projectile_human"
        self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName,
                10 / ClientConfigUtils.FPS, nil, self.projectileLaunchHumanPos.position)
    end
end

function ClientHero40027RangeAttack:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero40027RangeAttack:PlaySoundAttack()
    if self.clientHero.isDragonForm then
        zg.audioMgr:PlaySound("Hero/40027", "sfx_hero_40027_dragon_atk")
    else
        zg.audioMgr:PlaySound("Hero/40027", "sfx_hero_40027_airyuu_atk")
    end
end

function ClientHero40027RangeAttack:PlaySoundAttackImpact()
    if self.clientHero.isDragonForm then
        zg.audioMgr:PlaySound("Hero/40027", "sfx_hero_40027_dragon_atk_impact")
    else
        zg.audioMgr:PlaySound("Hero/40027", "sfx_hero_40027_airyuu_atk_impact")
    end
end

--- @param frameAnimLength number
--- @param frameEndTurn number
--- @param frameActionResult number
--- @param frameEffect number
--- @param isAfterTransform boolean
function ClientHero40027RangeAttack:SetFrameActionEvent(frameAnimLength, frameEndTurn, frameActionResult, frameEffect, frameTransform, isAfterTransform)
    self.isAfterTransform = isAfterTransform
    self:AddFrameAction(frameAnimLength + frameTransform, function()
        self:OnEndAnimation()
    end)
    if self.clientHero.heroModelType ~= HeroModelType.Full then
        return
    end
    self:AddFrameAction(frameEndTurn + frameTransform, function()
        self:OnCompleteActionTurn()
    end)
    self:AddFrameAction(frameActionResult + frameTransform, function()
        self:OnTriggerActionResult()
        self:PlaySoundAttackImpact()
    end)
    self:AddFrameAction(frameEffect + frameTransform, function()
        self:DoCoverBattle((frameEffect + frameTransform) * AnimationConstants.FRAME_LENGTH, 1, 0.3)
        self:OnCastEffect()
    end)

    self:SetAttackImpact(frameActionResult, frameTransform)

    self:AddFrameAction(frameTransform, function()
        self.clientHero:PlayAnimation(self.animName, false, self.clientHero.mainTrackIndex)
    end)
    self:AddFrameAction(frameTransform + 15, function()
        self.clientHero:PlayAnimationEffectByFrame(self.animName)
        self:PlaySoundAttack()
    end)
    if self.isAfterTransform then
        self:AddFrameAction(frameEndTurn + frameTransform + 15, function()
            self.listFrameAction:Clear()
            self:SetFrameActionEvent(frameAnimLength, frameEndTurn, frameActionResult, frameEffect, 0, false)
            self.isAfterTransform = false;
        end)
    end

end

function ClientHero40027RangeAttack:SetAttackImpact(frameActionResult, frameTransform)
    local impactFrame = 0
    if self.clientHero.isDragonForm then
        impactFrame = frameActionResult + frameTransform - 30
        self.fxImpactName = self.clientHero:GetEffectNameByFormat("hero_%s_attack_impact_dragon")
    else
        impactFrame = frameActionResult + frameTransform
        self.fxImpactName = self.clientHero:GetEffectNameByFormat("hero_%s_attack_impact_human")
    end
    self:AddFrameAction(impactFrame, function()
        self:CastNewClientImpactOnTargets(AssetType.HeroBattleEffect, self.fxImpactName)
    end)
end

--- @param listFrameAction List
function ClientHero40027RangeAttack:PlayFrameAction(listFrameAction)
    ClientConfigUtils.KillCoroutine(self.actionCoroutine)
    self.actionCoroutine = Coroutine.start(function()
        coroutine.waitforseconds(listFrameAction:Get(1).frame * AnimationConstants.FRAME_LENGTH)
        listFrameAction:Get(1):action()
        for i = 2, listFrameAction:Count() do
            local action = listFrameAction:Get(i)
            local action2 = listFrameAction:Get(i - 1)
            if action and action2 then
                local waitTime = (action.frame - action2.frame) * AnimationConstants.FRAME_LENGTH
                coroutine.waitforseconds(waitTime)
                action:action()
            end
        end
        self.actionCoroutine = nil
    end)
end

--- @param effectType string
--- @param effectName string
--- @param flyTime number
function ClientHero40027RangeAttack:CastDragonBreathOnTargets(effectType, effectName, launchPos, opponentPos)
    local poisonBreath = self:GetClientEffect(effectType, effectName)
    poisonBreath:SetPosition(launchPos)
    poisonBreath:LookAtPosition(opponentPos)
    poisonBreath:Play()
end

function ClientHero40027RangeAttack:DoAnimation()
    self.clientHero:PlayAnimation(self.animName, false, self.clientHero.mainTrackIndex)
    local frameToAttack
    local frameToAttackImpact
    if self.clientHero.skinId == 40027001 then
        frameToAttack = 15
        frameToAttackImpact = 29
    else
        frameToAttack = 15
        frameToAttackImpact = 40
    end
    self:AddFrameAction(frameToAttack, function()
        self:PlaySoundAttack()
    end)
    self:AddFrameAction(frameToAttackImpact, function()
        self:PlaySoundAttackImpact()
    end)
    self:PlayFrameAction(self.listFrameAction)
end
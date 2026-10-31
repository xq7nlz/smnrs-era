require "lua.client.hero.ClientHero40027.ClientHero40027RangeAttack"
--- @class ClientHero40027001RangeAttack : ClientHero40027RangeAttack
ClientHero40027001RangeAttack = Class(ClientHero40027001RangeAttack, ClientHero40027RangeAttack)

function ClientHero40027001RangeAttack:DeliverCtor()
    self.projectileLaunchHumanPos = self.clientHero.components:FindChildByPath("Model/launch_position")
    self.projectileLaunchDragonPos = self.clientHero.components:FindChildByPath("DragonForm/launch_position")
    self.isAfterTransform = true
end

function ClientHero40027001RangeAttack:OnCastEffect()
    if self.clientHero.isDragonForm then
        local opponentPos = PositionConfig.GetOpponentCenterTeamPosition(self.baseHero.teamId)
        self.projectileName = "hero_40027_skin_id_40027001_attack_cast_dragon"
        self:CastDragonBreathOnTargets(AssetType.HeroBattleEffect,
                self.projectileName, self.projectileLaunchDragonPos.position, opponentPos)
    else
        self.projectileName = "hero_40027_skin_id_40027001_attack_projectile_human"
        self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName,
                10 / ClientConfigUtils.FPS, nil, self.projectileLaunchHumanPos.position)
    end
end

function ClientHero40027001RangeAttack:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
    --TODO: Play sound
    if self.clientHero.isDragonForm then
        --zg.audioMgr:PlaySound("Hero/40027", "sfx_hero_40027_dragon_atk_impact")
    else
        --zg.audioMgr:PlaySound("Hero/40027", "sfx_hero_40027_atk_impact")
    end
end

function ClientHero40027001RangeAttack:SetAttackImpact(frameActionResult, frameTransform)
    local impactFrame = 0
    if self.clientHero.isDragonForm then
        impactFrame = frameActionResult + frameTransform - 30
        self.fxImpactName = self.clientHero:GetEffectNameByFormat("hero_40027_skin_id_40027001_attack_impact_dragon")
    else
        impactFrame = frameActionResult + frameTransform
        self.fxImpactName = self.clientHero:GetEffectNameByFormat("hero_40027_skin_id_40027001_attack_impact_human")
    end
    self:AddFrameAction(impactFrame, function()
        self:CastNewClientImpactOnTargets(AssetType.HeroBattleEffect, self.fxImpactName)
    end)
end

require "lua.client.hero.ClientHero40027.ClientHero40027ActiveSkill"
--- @class ClientHero40027001ActiveSkill : ClientHero40027ActiveSkill
ClientHero40027001ActiveSkill = Class(ClientHero40027001ActiveSkill, ClientHero40027ActiveSkill)

function ClientHero40027001ActiveSkill:PlayEffect(effectName)
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
    effect:Play()
end

function ClientHero40027001ActiveSkill:SetEnvironment()
    self:PlayEffect("hero_40027_skin_id_40027001_skill_environment")
end

function ClientHero40027001ActiveSkill:SetTransformConvert()
    self:PlayEffect("hero_40027_skin_id_40027001_transform_convert")
end

---Condensation when transforming
function ClientHero40027001ActiveSkill:SetSkillEggEnergy()
    local effectName = "hero_40027_skin_id_40027001_skill_egg_energy"
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
    effect:SetParent(self.clientHero.eggBone.transform)
    effect:Play()
    effect.config.transform.position = U_Vector3(0, 0, 0)
end

---Break ground when completed transform
function ClientHero40027001ActiveSkill:SetSkillImpact()
    local pos = PositionConfig.GetBattleCentralPosition()
    local effectName = "hero_40027_skin_id_40027001_skill_impact"
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
    effect.config.transform.position = pos
    effect:Play()
end

function ClientHero40027001ActiveSkill:DeliverSetFrameAction()
    local pos = PositionConfig.GetBattleCentralPosition() - U_Vector3(0, 0.5, 0)
    self:AddFrameAction(0, function()
        self.moveTween = self.clientHero.clientHeroMovement:DoMovePosition(pos, nil, 0.2, DOTweenEase.Linear)
    end)

    self:AddFrameAction(0, function()
        self:SetEnvironment()
    end)

    self:AddFrameAction(54, function()
        self:SetSkillEggEnergy()
    end)

    self:AddFrameAction(100, function()
        self:SetSkillImpact()
        self:PlaySoundTransformToDragonImpact()
    end)

end

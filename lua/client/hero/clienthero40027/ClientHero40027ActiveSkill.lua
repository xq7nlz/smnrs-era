require "lua.client.hero.ClientHero40027.Client40027HeroAnimation"
--- @class ClientHero40027ActiveSkill : BaseSkillShow
ClientHero40027ActiveSkill = Class(ClientHero40027ActiveSkill, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero40027ActiveSkill:Ctor(clientHero, isBasicAttack)
    --- @type boolean
    self.isDragonForm = false
    BaseSkillShow.Ctor(self, clientHero, isBasicAttack)
end

function ClientHero40027ActiveSkill:DeliverCtor()

end

function ClientHero40027ActiveSkill:OnEndAnimation()
    BaseSkillShow.OnEndAnimation(self)
end

--- @param actionResults List<BaseActionResult>
function ClientHero40027ActiveSkill:CastOnTarget(actionResults)
    self:GetListTargetFromActions(actionResults)
    self:DoAnimation()
    self:DoCoverBattle(150 * AnimationConstants.FRAME_LENGTH, 1, 0.3)
end

function ClientHero40027ActiveSkill:SetEnvironment()
    local effectName = self.clientHero:GetEffectNameByFormat("hero_%s_skill_environment")
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
    effect:Play()
end

function ClientHero40027ActiveSkill:SetImpact()
    local pos = PositionConfig.GetBattleCentralPosition()
    local effectName = self.clientHero:GetEffectNameByFormat("hero_%s_skill_impact")
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
    effect.config.transform.position = pos
    effect:Play()
end

function ClientHero40027ActiveSkill:SetEggEffect()
    local effectName = self.clientHero:GetEffectNameByFormat("hero_%s_skill_egg_energy")
    local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
    effect:SetParent(self.clientHero.eggBone.transform)
    effect:Play()
    effect.config.transform.position = U_Vector3(0, 0, 0)
end

function ClientHero40027ActiveSkill:DoAnimation()
    self.clientHero:SwitchModel(AiryuuForm.Dragon)
    self:PlayFrameAction(self.listFrameAction)
end

function ClientHero40027ActiveSkill:PlaySoundTransformToDragonImpact()
    zg.audioMgr:PlaySound("Hero/40027", "sfx_hero_40027_skill_impact")
end

function ClientHero40027ActiveSkill:DeliverSetFrameAction()
    local pos = PositionConfig.GetBattleCentralPosition() - U_Vector3(0, 2, 0)
    self:AddFrameAction(0, function()
        self.moveTween = self.clientHero.clientHeroMovement:DoMovePosition(pos, nil, 0.2, DOTweenEase.Linear)
    end)
    --self:AddFrameAction(105, function()
    --    self:SetEnvironment()
    --end)
    self:AddFrameAction(71, function()
        self:SetEggEffect()
    end)

    self:AddFrameAction(109, function()
        self:SetImpact()
        self:PlaySoundTransformToDragonImpact()
    end)
end

--- @class ClientHero30019ActiveSkill : BaseSkillShow
ClientHero30019ActiveSkill = Class(ClientHero30019ActiveSkill, BaseSkillShow)

function ClientHero30019ActiveSkill:DeliverCtor()
    self.effectName = string.format("hero_%d_skill_shooter", self.baseHero.id)
end

--- @param actionResults List<BaseActionResult>
function ClientHero30019ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(1, 1, 0.3)

end

function ClientHero30019ActiveSkill:DeliverSetFrameAction()
    self:AddFrameAction(40, function()
        local effect = self:GetClientEffect(AssetType.HeroBattleEffect, self.effectName)
        effect:SetToHeroAnchor(self.clientHero)
    end)
end

function ClientHero30019ActiveSkill:OnCastEffect()
    self.projectileLaunchPos = self.clientHero.components:GetAnchorPosition(ClientConfigUtils.TORSO_ANCHOR)
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, 5.0 / ClientConfigUtils.FPS)
end

function ClientHero30019ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero30019ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
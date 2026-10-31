--- @class ClientHero20021ActiveSkill : BaseSkillShow
ClientHero20021ActiveSkill = Class(ClientHero20021ActiveSkill, BaseSkillShow)

function ClientHero20021ActiveSkill:DeliverCtor()
    self.projectileName = string.format("hero_%d_%s", self.baseHero.id, ClientConfigUtils.DEFAULT_ATTACK_PROJECTILE)
    self.projectileLaunchAnchor = self.clientHero.components:FindChildByPath("Model/bone_skin_1_cung")
end

--- @param actionResults List<BaseActionResult>
function ClientHero20021ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()

    self:DoCoverBattle(0.5, 0.7, 0.3)

end

function ClientHero20021ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, nil, self.projectileLaunchAnchor.position)
end

function ClientHero20021ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero20021ActiveSkill:OnEndTurn()
    BaseSkillShow.ChangeListTargetLayer(self, ClientConfigUtils.BATTLE_LAYER_ID)
    BaseSkillShow.OnEndTurn(self)
end
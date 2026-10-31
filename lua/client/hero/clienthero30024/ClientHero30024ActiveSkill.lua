--- @class ClientHero30024ActiveSkill : BaseSkillShow
ClientHero30024ActiveSkill = Class(ClientHero30024ActiveSkill, BaseSkillShow)

function ClientHero30024ActiveSkill:Ctor(clientHero, isBasicAttack)
    BaseSkillShow.Ctor(self, clientHero, isBasicAttack)
    self.projectileLaunchPos = self.clientHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
end

--- @param actionResults List<BaseActionResult>
function ClientHero30024ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero30024ActiveSkill:OnTriggerActionResult()
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_MEDIUM)
    BaseSkillShow.OnTriggerActionResult(self)
end

function ClientHero30024ActiveSkill:OnCastEffect()
    self:CastNewProjectileOnTargets(AssetType.HeroBattleEffect, self.projectileName, nil, ClientConfigUtils.FOOT_ANCHOR)
end
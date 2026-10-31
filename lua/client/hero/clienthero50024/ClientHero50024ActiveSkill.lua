--- @class ClientHero50024ActiveSkill : BaseSkillShow
ClientHero50024ActiveSkill = Class(ClientHero50024ActiveSkill, BaseSkillShow)

--- @param actionResults List<BaseActionResult>
function ClientHero50024ActiveSkill:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end

function ClientHero50024ActiveSkill:OnTriggerActionResult()
    BaseSkillShow.OnTriggerActionResult(self)
    self.clientBattleShowController:DoShake(ClientConfigUtils.SHAKE_HARD)
end
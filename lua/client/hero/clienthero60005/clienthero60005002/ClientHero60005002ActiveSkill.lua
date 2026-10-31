--- @class ClientHero60005002ActiveSkill : ClientHero60005ActiveSkill
ClientHero60005002ActiveSkill = Class(ClientHero60005002ActiveSkill, ClientHero60005ActiveSkill)

function ClientHero60005002ActiveSkill:DeliverCtor()
	ClientHero60005ActiveSkill.DeliverCtor(self)
end

function ClientHero60005002ActiveSkill:SetEnvironment()
	local effectName = self.clientHero:GetEffectNameByFormat("hero_%s_%s_environment")
	local effect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
	effect:SetPosition(PositionConfig.GetBattleCentralPosition())
	effect:Play()
end

--- @param actionResults List<BaseActionResult>
function ClientHero60005002ActiveSkill:CastOnTarget(actionResults)
	BaseSkillShow.CastOnTarget(self, actionResults)
	self:DoAnimation()
	self:DoCoverBattle(1.6, 0.5, 0.4)
	self:SetEnvironment()
end
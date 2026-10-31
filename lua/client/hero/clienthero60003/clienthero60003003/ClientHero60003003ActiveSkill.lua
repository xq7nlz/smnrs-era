require "lua.client.hero.ClientHero60003.ClientHero60003002.ClientHero60003002ActiveSkill"
--- @class ClientHero60003003ActiveSkill : ClientHero60003002ActiveSkill
ClientHero60003003ActiveSkill = Class(ClientHero60003003ActiveSkill, ClientHero60003002ActiveSkill)
function ClientHero60003003ActiveSkill:OnCastEffect()
	local effect = self:GetSkillEffect()
	effect:SetToHeroAnchor(self.clientHero)
	local target = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(1))
	effect.configTable.targetSkill1.position = target.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
	if self.listTargetHero:Count() > 1 then
		target = self.clientBattleShowController:GetClientHeroByBaseHero(self.listTargetHero:Get(2))
	end
	effect.configTable.targetSkill2.position = target.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
end
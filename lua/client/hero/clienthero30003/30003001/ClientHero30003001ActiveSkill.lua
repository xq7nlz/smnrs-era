require "lua.client.hero.ClientHero30003.ClientHero30003ActiveSkill"
--- @class ClientHero30003001ActiveSkill : ClientHero30003ActiveSkill
ClientHero30003001ActiveSkill = Class(ClientHero30003001ActiveSkill, ClientHero30003ActiveSkill)

function ClientHero30003001ActiveSkill:DeliverCtor()
	self.effectName = string.format("hero_%d_skin_id_%d_eff_skill", self.baseHero.id,self.clientHero.skinId)
	self.projectileLaunchPos = self.clientHero.components:FindChildByPath("Model/launch_position_2")
	self.offset = U_Vector2(0.5, 0)
	self.targetXich = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/target_xich")

	self.trackingCoroutine = nil
end
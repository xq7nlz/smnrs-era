require "lua.client.hero.ClientHero60005.ClientHero60005ActiveSkill"
require "lua.client.hero.ClientHero60005.ClientHero60005BaseAttack"

--- Hound Master
--- @class ClientHero60005 : ClientHero
ClientHero60005 = Class(ClientHero60005, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60005:CreateInstance(heroModelType)
	return ClientHero60005(heroModelType)
end

--- @param baseHero BaseHero
--- @param overridePosition UnityEngine_Vector3
function ClientHero60005:Init(baseHero, overridePosition)
	ClientHero.Init(self, baseHero, overridePosition)
end

function ClientHero60005:InitSkill()
	self.weaponFx = self.components:FindChildByPath("Model/weapon/FX_Slash_05p").gameObject
	if self.heroModelType == HeroModelType.Dummy then
		self.weaponFx:SetActive(self.heroModelType ~= 0)
		return
	end
	if self.heroModelType >= HeroModelType.Basic then
		if self.skinId == 60005001 then
			require "lua.client.hero.ClientHero60005.ClientHero60005001.ClientHero60005001BaseAttack"
			self.basicAttack = ClientHero60005001BaseAttack(self)
			self.basicAttack:SetFx(self.weaponFx)
			self.basicAttack:SetFrameActionEvent(80, 96, 58, -1)
		elseif self.skinId == 60005002 then
				require "lua.client.hero.ClientHero60005.ClientHero60005002.ClientHero60005002BaseAttack"
				self.basicAttack = ClientHero60005002BaseAttack(self)
				self.basicAttack:SetFx(self.weaponFx)
				self.basicAttack:SetFrameActionEvent(80, 96, 58, -1)
		else
			self.basicAttack = ClientHero60005BaseAttack(self)
			self.basicAttack:SetFx(self.weaponFx)
			self.basicAttack:SetFrameActionEvent(80, 96, 58, -1)
		end
	end
	if self.heroModelType >= HeroModelType.Full then
		if self.skinId == 60005001 then
			require "lua.client.hero.ClientHero60005.ClientHero60005001.ClientHero60005001ActiveSkill"
			self.skillAttack = ClientHero60005001ActiveSkill(self)
			self.skillAttack:SetFx(self.weaponFx)
			self.skillAttack:SetFrameActionEvent(80, 95, 58, -1)
		elseif self.skinId == 60005002 then
			require "lua.client.hero.ClientHero60005.ClientHero60005002.ClientHero60005002ActiveSkill"
			self.skillAttack = ClientHero60005002ActiveSkill(self)
			self.skillAttack:SetFx(self.weaponFx)
			self.skillAttack:SetFrameActionEvent(80, 95, 58, -1)
		else

			self.skillAttack = ClientHero60005ActiveSkill(self)
			self.skillAttack:SetFx(self.weaponFx)
			self.skillAttack:SetFrameActionEvent(80, 95, 58, -1)
		end
	end
end

function ClientHero60005:InitAnimationComponent()
	ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero60005:PlayStartAnimation()
	ClientHero.PlayStartAnimation(self)
	ClientHero.PlayAnimation(self, "fx", true, 0)
end

--- @param effectLogType EffectLogType
function ClientHero60005:OnCompleteGettingFreezed(effectLogType)
	self.animation:EnableAnim(false)
	self.animation:KillTweenerShaderFloat()
	self.animation:ChangeShaderByName(ClientConfigUtils.SPINE_CUSTOM_SHADER)
	local texture
	if effectLogType == EffectLogType.FREEZE then
		texture = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.iconBattleEffect, "ice", ComponentName.UnityEngine_Texture)
	elseif effectLogType == EffectLogType.PETRIFY then
		texture = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.iconBattleEffect, "stone", ComponentName.UnityEngine_Texture)
	end
	self.animation:SetShaderTextureFieldById(ClientConfigUtils.FIELD_MIX_TEX_ID, texture)
	self.animation:SetShaderFieldFloatById(ClientConfigUtils.FIELD_FILL_PHASE_ID, 1)
	self.animation:SetShaderFieldFloatById(ClientConfigUtils.FIELD_FILL_MIX_ID, 1)
	self.weaponFx.gameObject:SetActive(false)
end

--- @param effectLogType EffectLogType
function ClientHero60005:RemoveFreezedByType(effectLogType)
	self.animation:EnableAnim(true)
	self.animation:SetShaderFieldFloatById(ClientConfigUtils.FIELD_FILL_PHASE_ID, 0)
	self.animation:SetShaderFieldFloatById(ClientConfigUtils.FIELD_FILL_MIX_ID, 0)
	self.weaponFx.gameObject:SetActive(true)
end
return ClientHero60005
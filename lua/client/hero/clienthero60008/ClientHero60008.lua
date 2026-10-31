require "lua.client.hero.ClientHero60008.ClientHero60008ActiveSkill"
require "lua.client.hero.ClientHero60008.ClientHero60008BaseAttack"

--- Hound Master
--- @class ClientHero60008 : ClientHero
ClientHero60008 = Class(ClientHero60008, ClientHero)

--- @param heroModelType HeroModelType
function ClientHero60008:CreateInstance(heroModelType)
	return ClientHero60008(heroModelType)
end

function ClientHero60008:InitSkill()
	if self.heroModelType == HeroModelType.Dummy then
		return
	end
	if self.heroModelType >= HeroModelType.Basic then
		if self.skinId == 60008001 then
			self.basicAttack = ClientHero60008BaseAttack(self)
			self.basicAttack:SetFrameActionEvent(45, 46, 27, -1)
		elseif self.skinId == 60008002 then
			require "lua.client.hero.ClientHero60008.60008002.ClientHero60008002BaseAttack"
			self.basicAttack = ClientHero60008002BaseAttack(self)
			self.basicAttack:SetFrameActionEvent(56, 57, 20, -1)
		elseif self.skinId == 60008003 then
			require "lua.client.hero.ClientHero60008.60008003.ClientHero60008003BaseAttack"
			self.basicAttack = ClientHero60008003BaseAttack(self)
			self.basicAttack:SetFrameActionEvent(45, 46, 24, -1)
		else
			self.basicAttack = ClientHero60008BaseAttack(self)
			self.basicAttack:SetFrameActionEvent(45, 46, 27, -1)
		end
	end
	if self.heroModelType >= HeroModelType.Full then
		if self.skinId == 60008001 then
			self.skillAttack = ClientHero60008ActiveSkill(self)
			self.skillAttack:SetFrameActionEvent(80, 95, 58, -1)
		elseif self.skinId == 60008002 then
			require "lua.client.hero.ClientHero60008.60008002.ClientHero60008002ActiveSkill"
			self.skillAttack = ClientHero60008002ActiveSkill(self)
			self.skillAttack:SetFrameActionEvent(85, 86, 38, -1)
		elseif self.skinId == 60008003 then
			require "lua.client.hero.ClientHero60008.60008003.ClientHero60008003ActiveSkill"
			self.skillAttack = ClientHero60008003ActiveSkill(self)
			self.skillAttack:SetFrameActionEvent(80, 95, 59, -1)
		else
			self.skillAttack = ClientHero60008ActiveSkill(self)
			self.skillAttack:SetFrameActionEvent(80, 95, 58, -1)
		end
	end
end

function ClientHero60008:InitAnimationComponent()
	ClientHero.InitAnimationComponent(self, 2)
end

function ClientHero60008:PlayStartAnimation()
	ClientHero.PlayStartAnimation(self)
	ClientHero.PlayAnimation(self, "fx", true, 0)
	if self.skinId == 60008002 then
		ClientHero.PlayAnimation(self, "fx2", true, 1)
	end
end

--- @param effectLogType EffectLogType
function ClientHero60008:OnCompleteGettingFreezed(effectLogType)
	self.animation:EnableAnim(false)
	self.animation:KillTweenerShaderFloat()
	self.animation:ChangeShaderByName(ClientConfigUtils.SPINE_CUSTOM_SHADER)
	local texture
	if self.skinId == 60008003 then
		--- @type UnityEngine_GameObject
		self.weapon_fx = self.components:FindChildByPath("Model/weapon_fx").gameObject
	end
	if effectLogType == EffectLogType.FREEZE then
		if self.weapon_fx ~= nil then
			self.weapon_fx:SetActive(false)
		end
		texture = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.iconBattleEffect, "ice", ComponentName.UnityEngine_Texture)
	elseif effectLogType == EffectLogType.PETRIFY then
		if self.weapon_fx ~= nil then
			self.weapon_fx:SetActive(false)
		end
		texture = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.iconBattleEffect,
				"stone", ComponentName.UnityEngine_Texture)
	end
	self.animation:SetShaderTextureFieldById(ClientConfigUtils.FIELD_MIX_TEX_ID, texture)
	self.animation:SetShaderFieldFloatById(ClientConfigUtils.FIELD_FILL_PHASE_ID, 1)
	self.animation:SetShaderFieldFloatById(ClientConfigUtils.FIELD_FILL_MIX_ID, 1)
end

--- @param effectLogType EffectLogType
function ClientHero60008:RemoveFreezedByType(effectLogType)
	self.animation:EnableAnim(true)
	self.animation:SetShaderFieldFloatById(ClientConfigUtils.FIELD_FILL_PHASE_ID, 0)
	self.animation:SetShaderFieldFloatById(ClientConfigUtils.FIELD_FILL_MIX_ID, 0)
    if self.weapon_fx ~= nil then
        self.weapon_fx:SetActive(true)
    end
end

return ClientHero60008
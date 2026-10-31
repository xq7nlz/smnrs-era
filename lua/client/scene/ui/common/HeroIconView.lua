local SIZE_FRAME_HERO_ICON = U_Vector2(148, 148)
local SIZE_HERO_ICON = U_Vector2(135, 135)
--- @class HeroIconView : MotionIconView
HeroIconView = Class(HeroIconView, MotionIconView)

--- @return void
--- @param transform UnityEngine_RectTransform
function HeroIconView:Ctor(transform)
	MotionIconView.Ctor(self, transform)
end

--- @return void
function HeroIconView:SetPrefabName()
	self.prefabName = 'hero_icon_info'
	self.uiPoolType = UIPoolType.HeroIconView
end

--- @return void
--- @param transform UnityEngine_Transform
function HeroIconView:SetConfig(transform)
	MotionIconView.SetConfig(self, transform)
	--- @type HeroIconConfig
	self.config = UIBaseConfig(transform)
end

--- @return void
--- @param iconData ItemIconData
function HeroIconView:SetIconData(iconData)
	if iconData == nil then
		XDebug.Error("HeroIconView:SetIconData NIL")
		return
	end
	--- @type ItemIconData
	self.iconData = iconData
	if self.iconData.type == ResourceType.Hero then
		self:UpdateViewHero()
	elseif self.iconData.type == ResourceType.HeroFragment then
		self:UpdateViewHeroFragment()
	elseif self.iconData.type == ResourceType.EvolveFoodMaterial then
		self:UpdateViewHeroFood()
	elseif self.iconData.type == ResourceType.Money then
		self:UpdateViewMoneyType()
	end
	self:SetAlpha(1)
end

--- @return void
function HeroIconView:SetDataMainHero(summonerId, summonerStar, summonerLevel)
	if self.config.fragmentIcon ~= nil then
		self.config.fragmentIcon.gameObject:SetActive(false)
	end

	if self.config.iconRank ~= nil then
		self.config.iconRank.gameObject:SetActive(false)
	end

	local tier = ClientConfigUtils.GetTierByStar(summonerStar)
	local borderSprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconHeroCardBorder,
			"border_small_5")
	--self:_SetFactionById(ClientConfigUtils.GetFactionIdByHeroId(heroId))
	self:_SetFactionById(nil)
	self:_SetQuantity(nil)
	self:_SetHeroIcon(summonerId, tier)
	self:_SetTextLevel(summonerLevel)
	self:_SetStar(summonerStar)

	self.config.frame.sprite = borderSprite
	self:FillSizeHeroView()
end

--- @return void
function HeroIconView:SetAvatar(avatar, level)

end

--- @return void
---@param heroFoodType HeroFoodType
---@param star number
---@param number number
function HeroIconView:_SetDataHeroFood(heroFoodType, star, number)
	self.config.heroIcon.sprite = ResourceLoadUtils.LoadHeroesFoodIcon(heroFoodType)
	if self.config.fragmentIcon ~= nil then
		self.config.fragmentIcon.gameObject:SetActive(false)
	end
	self:_SetFactionById(ClientConfigUtils.GetFactionHeroFoodType(heroFoodType))
	self:_SetTextLevel(nil)
	self:_SetFrameById(1)
	self:_SetQuantity(number)
	self:_SetStar(star)
end

---@param listener function
function HeroIconView:AddListener(listener)
	self:EnableButton(true)
	self.config.button.onClick:RemoveAllListeners()
	self.config.button.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		if listener then
			listener()
		end
	end)
end

--- @return void
function HeroIconView:RemoveAllListeners()
	self:EnableButton(false)
	self.config.button.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function HeroIconView:EnableButton(enabled)
	UIUtils.SetInteractableButton(self.config.button, enabled)
	self.config.frame.raycastTarget = enabled
end

--- @return void
--- @param enabled boolean
function HeroIconView:EnableRaycast(enabled)
	self.config.frame.raycastTarget = enabled
end

--- @return void
function HeroIconView:UpdateViewHero()
	local heroTier = ResourceMgr.GetHeroesConfig():GetHeroTier():GetHeroTier(self.iconData.heroId)
	self:_SetHeroCardBorderByTier(heroTier)

	self:_SetFactionById(self.iconData.faction)
	self:_SetHeroIconById(self.iconData.heroId, self.iconData.star, self.iconData.skinId)
	self:_SetTextLevel(self.iconData.level)
	self:_SetStar(self.iconData.star)
	self:_SetQuantity(self.iconData.quantity)
	self:_SetFrameById(1)
	if self.config.fragmentIcon ~= nil then
		self.config.fragmentIcon.gameObject:SetActive(false)
	end
	if self.iconData.star ~= nil and self.iconData.star > 0 then
		self:SetSizeHeroView()
	else
		self:SetSizeFragment()
	end
	if self.iconData.hp ~= nil then
		self:ActiveHpBar(self.iconData.hp)
	end

	if self.iconData.star ~= nil and self.iconData.star >= 13 then
		--self:ActiveStarCard(true)
		self:ActiveFxHeroCard(true)
	end
end

--- @return void
function HeroIconView:UpdateViewMoneyType()
	self:_SetFactionById(self.iconData.faction)
	self:_SetMoneyTypeIcon(self.iconData.itemId)
	self:_SetTextLevel(nil)
	self:_SetStar(nil)
	self:_SetQuantity(self.iconData.quantity)
	self:_SetFrameById(1)
	if self.config.iconRank ~= nil then
		self.config.iconRank.gameObject:SetActive(false)
	end
	if self.config.fragmentIcon ~= nil then
		self.config.fragmentIcon.gameObject:SetActive(false)
	end
	if self.iconData.star ~= nil and self.iconData.star > 0 then
		self:SetSizeHeroView()
	else
		self:SetSizeFragment()
	end
	if self.iconData.hp ~= nil then
		self:ActiveHpBar(self.iconData.hp)
	end

	if self.iconData.star ~= nil and self.iconData.star >= 13 then
		--self:ActiveStarCard(true)
		self:ActiveFxHeroCard(true)
	end
end

--- @return void
function HeroIconView:UpdateViewHeroFragment()
	local idFragment = self.iconData.itemId
	local heroId = ClientConfigUtils.GetHeroIdByFragmentId(idFragment)
	local faction = ClientConfigUtils.GetFactionFragmentIdByHeroId(idFragment)
	local star = ClientConfigUtils.GetHeroFragmentStar(idFragment)

	local heroTier = ResourceMgr.GetHeroesConfig():GetHeroTier():GetHeroTier(heroId)

	if ClientConfigUtils.IsFragmentRedBorder(idFragment) == true then
		local borderSprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconHeroCardBorder,
				"border_small_5")
		self.config.frame.sprite = borderSprite
	else
		self:_SetHeroFragmentCardBorderByTier(heroTier)
	end
	self:_SetHeroIconById(heroId, star)
	self:_SetFactionById(faction)
	self:_SetTextLevel(nil)
	self:_SetStar(star)
	self:_SetQuantity(self.iconData.quantity)
	self:_SetFrameById(1)
	if self.config.fragmentIcon ~= nil then
		self.config.fragmentIcon.gameObject:SetActive(true)
	end
	if self.config.iconRank ~= nil then
		self.config.iconRank.gameObject:SetActive(false)
	end
	self:SetSizeFragment()
end

--- @return void
function HeroIconView:SetSizeFragment()
	self.config.boder.sizeDelta = U_Vector2(self.config.boder.sizeDelta.x, self.config.boder.sizeDelta.x)
	self:FillSizeHeroView()
end

--- @return void
function HeroIconView:SetSizeHeroView()
	self.config.boder.sizeDelta = SIZE_FRAME_HERO_ICON
	self.config.heroIcon.rectTransform.sizeDelta = SIZE_HERO_ICON
	self:FillSizeHeroView()
end

--- @return void
function HeroIconView:FillSizeHeroView()
	if not Main.IsNull(self.config.heroIcon.sprite) then
		UIUtils.FillSizeHeroView(self.config.heroIcon)
	end
end

--- @return void
function HeroIconView:UpdateViewHeroFood()
	local idFragment = self.iconData.itemId
	local heroFoodType = ClientConfigUtils.GetHeroFoodTypeById(idFragment)
	local star = ClientConfigUtils.GetHeroFoodStarById(idFragment)

	self:_SetHeroFragmentCardBorderByTier(1)
	self:_SetDataHeroFood(heroFoodType, star, self.iconData.quantity)
	self:SetSizeFragment()
end

--- @return void
function HeroIconView:ReturnPool()
	MotionIconView.ReturnPool(self)
	self:SetSize(165, 165)

	if self.config ~= nil and self.config.classIcon ~= nil then
		self.config.classIcon.gameObject:SetActive(false)
	end
	--XDebug.Log("HeroIconView:ReturnPool" .. LogUtils.ToDetail(self.config.transform))
end

--- @param isActive boolean
function HeroIconView:SetActive(isActive)
	self.config.gameObject:SetActive(isActive)
end

--- @return void
function HeroIconView:ShowClassHero()
	if self.config ~= nil and self.config.classIcon ~= nil then
		local classId = ResourceMgr.GetHeroClassConfig():GetClass(self.iconData.heroId)
		self.config.classIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconClassHeroes, classId)
		self.config.classIcon.gameObject:SetActive(true)
	end
end

function HeroIconView:_SetHeroFragmentCardBorderByTier(tier)
	if self.config.iconRank ~= nil then
		self.config.iconRank.gameObject:SetActive(false)
	end

	--- @type UnityEngine_Sprite
	local borderSprite
	local spriteName = "border_small"
	if tier ~= nil and tier >= 6 then
		tier = 5
		spriteName = string.format("%s_%s", spriteName, tier)
	end
	borderSprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconHeroCardBorder, spriteName)
	self.config.frame.sprite = borderSprite
end

function HeroIconView:_SetHeroCardBorderByTier(tier)
	if self.config.iconRank == nil then
		return
	end
	self.config.iconRank.gameObject:SetActive(true)

	if tier == nil then
		self.config.iconRank.gameObject:SetActive(false)
	end
	--- @type UnityEngine_Sprite
	local borderSprite
	--- @type UnityEngine_Sprite
	local iconRankSprite
	local spriteName = "border_small_new"
	local iconRankSpriteName = "icon_border"

	if tier ~= nil and tier > 3 then
		spriteName = string.format("%s_%s", spriteName, tier)
		iconRankSpriteName = string.format("%s_%s", iconRankSpriteName, tier)
	else
		tier = 3
		spriteName = string.format("%s_%s", spriteName, tier)
		iconRankSpriteName = string.format("%s_%s", iconRankSpriteName, tier)
	end
	borderSprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconHeroCardBorder, spriteName)
	iconRankSprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconHeroCardBorder, iconRankSpriteName)
	self.config.frame.sprite = borderSprite

	self.config.iconRank.sprite = iconRankSprite
	self.config.iconRank:SetNativeSize()
end

function HeroIconView:_SetHeroCardBorderByIdFragment(idFragment)

	--- @type UnityEngine_Sprite
	local borderSprite
	local spriteName = "border_small"
	if idFragment ~= nil and idFragment >= 1000 then
		spriteName = string.format("%s_%s", spriteName, 5)
	end
	borderSprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconHeroCardBorder, spriteName)
	self.config.frame.sprite = borderSprite
end

--- @return void
--- @param id number
function HeroIconView:_SetFactionById(id)
	if id ~= nil and id > 0 and id < 7 then
		self.config.factionIcon.gameObject:SetActive(true)
		self.config.factionIcon.sprite = ResourceLoadUtils.LoadFactionIcon(id)
	else
		self.config.factionIcon.gameObject:SetActive(false)
	end
end

--- @return void
--- @param quantity number
function HeroIconView:_SetQuantity(quantity)
	if self.config.textNumber ~= nil then
		if quantity ~= nil and quantity > 0 then
			self.config.textNumber.gameObject:SetActive(true)
			self.config.textNumber.text = string.format("%d", quantity)
			UIUtils.SetTextTestValue(self.config, quantity)
		else
			self.config.textNumber.gameObject:SetActive(false)
		end
	end
end

--- @return void
--- @param id number
function HeroIconView:_SetHeroIconById(id, star, skinId)
	if ClientConfigUtils.IsFragmentRedBorder(id) then

		local sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.heroFragmentByStars, id)
		if sprite ~= nil then
			self.config.heroIcon.sprite = sprite
		else
            self.config.heroIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.heroFragmentByStars, 6)
		end
		self:ActiveEffectPool(EffectPoolType.HeroInfoFire, true, nil, nil, self.config.fxHeroIcon)
	elseif id == nil or id < HeroConstants.FACTION_HERO_ID_DELTA then
		if id == -1 or id == -2 then
			self.config.heroIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.heroFragmentByStars, id)
		else
			local index = math.min(star, 5)
			self.config.heroIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.heroFragmentByStars, index)
		end
	elseif skinId ~= nil and skinId > 0 then
		self.config.heroIcon.sprite = ResourceLoadUtils.LoadSkinIcon(skinId)
	else
		self:_SetHeroIcon(id, star)
	end
end

--- @return void
--- @param id number
function HeroIconView:_SetMoneyTypeIcon(id)
	self.config.heroIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconCurrencies, id)
end

--- @return void
--- @param id number
function HeroIconView:_SetHeroIcon(id, star)
	self.config.heroIcon.sprite = ResourceLoadUtils.LoadHeroCardsIcon(id, star)
end

--- @return void
--- @param star number
function HeroIconView:_SetStar(star)
	if star ~= nil and star > 0 then
		if self.config.bgStar ~= nil then
			self.config.bgStar:SetActive(true)
		end
		self.config.starImage.gameObject:SetActive(true)
		local starNumber = star % 6
		if starNumber == 0 then
			starNumber = 6
		end
		self.config.starImage.sprite = ResourceLoadUtils.LoadStarHero(star)
		UIUtils.SlideImageHorizontal(self.config.starImage, starNumber)
	else
		if self.config.bgStar ~= nil then
			self.config.bgStar:SetActive(false)
		end
		self.config.starImage.gameObject:SetActive(false)
	end

end

--- @return void
--- @param level number
function HeroIconView:_SetTextLevel(level)
	if self.config.txtLv ~= nil then
		if level ~= nil and level >= 0 then
			--self.config.txtLv.alignment = U_TextAlignmentOptions.MidlineRight
			self.config.txtLv.gameObject:SetActive(true)
			self.config.txtLv.text = string.format("%s.%s", "Lv", level)
		else
			self.config.txtLv.gameObject:SetActive(false)
		end
	end
end

--- @return void
--- @param id number
function HeroIconView:_SetFrameById(id)
	--self.config.frame.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.heroFrames, id)
end

--- @return void
function HeroIconView:ShowInfo()
	if self.iconData ~= nil then
		if self.iconData.type == ResourceType.Hero then
			--local heroResource = HeroResource.CreateInstance(nil, self.iconData.heroId, self.iconData.star, self.iconData.level)
			--PopupMgr.ShowPopup(UIPopupName.UIHeroSummonInfo, { ["heroResource"] = heroResource})
		else
			PopupMgr.ShowPopup(UIPopupName.UIItemPreview,
					{ ["data1"] = { ["type"] = self.iconData.type, ["id"] = self.iconData.itemId, ["rate"] = self.rate } })
		end
	end
end

--- @param isActive
function HeroIconView:ActiveFrameBoss(isActive)
	if isActive == true and self.frameBoss == nil then
		---@type UnityEngine_GameObject
		self.frameBoss = IconView._SpawnUIPool(UIPoolType.FrameBoss, self.config.transform)
		--- @type UnityEngine_RectTransform
		local rect = self.frameBoss:GetComponent(ComponentName.UnityEngine_RectTransform)
		rect.localEulerAngles = U_Vector3.zero
		rect.anchoredPosition3D = U_Vector3(7, 10, 0)
		rect:SetAsLastSibling()
		self.frameBoss.gameObject:SetActive(true)
	elseif isActive == false and self.frameBoss ~= nil then
		IconView.DespawnUIPool(UIPoolType.FrameBoss, self.frameBoss)
		self.frameBoss = nil
	end
end

function HeroIconView:ActiveStarCard(isActive)
	self:ActiveEffectPool(EffectPoolType.StarHeroInfo, isActive, nil, nil, self.config.starImage.transform)
end

function HeroIconView:ActiveFxHeroCard(isActive)
	local effectPoolType
	local faction = self.iconData.faction
	if faction == HeroFactionType.WATER then
		effectPoolType = EffectPoolType.HeroInfoWater
	elseif faction == HeroFactionType.FIRE then
		effectPoolType = EffectPoolType.HeroInfoFire
	elseif faction == HeroFactionType.ABYSS then
		effectPoolType = EffectPoolType.HeroInfoAbyss
	elseif faction == HeroFactionType.NATURE then
		effectPoolType = EffectPoolType.HeroInfoNature
	elseif faction == HeroFactionType.LIGHT then
		effectPoolType = EffectPoolType.HeroInfoLight
	elseif faction == HeroFactionType.DARK then
		effectPoolType = EffectPoolType.HeroInfoDark
	end
	self:ActiveEffectPool(effectPoolType, isActive, nil, nil, self.config.fxHeroIcon)
end

return HeroIconView


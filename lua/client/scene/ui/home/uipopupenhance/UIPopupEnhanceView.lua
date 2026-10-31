---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiPopupEnhance.UIPopupEnhanceConfig"

--- @class UIPopupEnhanceView : UIBaseView
UIPopupEnhanceView = Class(UIPopupEnhanceView, UIBaseView)

--- @return void
--- @param model UIPopupEnhanceModel
--- @param ctrl UIPopupEnhanceCtrl
function UIPopupEnhanceView:Ctor(model, ctrl)
	---@type UIPopupEnhanceConfig
	self.config = nil
	---@type HeroIconView
	self.hero1 = nil
	---@type HeroIconView
	self.hero2 = nil
	---@type ListSkillView
	self.listSkillView = nil
	---@type SkillHeroView[]
	self.skills = {}
	---@type List -- StatUpgradeView[]
	self.stats = List()
	---@type boolean
	self.isSummoner = false
	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIPopupEnhanceModel
	self.model = self.model
	--- @type UIPopupEnhanceCtrl
	self.ctrl = self.ctrl
end

--- @return void
function UIPopupEnhanceView:OnReadyCreate()
	---@type UIPopupEnhanceConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.listSkillView = ListSkillView(self.config.skillEnhance.transform, U_Vector2(0.5,-0.15), self.config.skillEnhance.transform)
	ResourceLoadUtils.LoadUIEffect("fx_ui_evolveenhance_light", self.config.fxUiEvolveenhanceLight)

	self.config.background.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
end

--- @return void
function UIPopupEnhanceView:InitHero(result)
	self.model.awaken = result.awaken
	self.model.heroResource = result.heroResource
	self.isSummoner = result.isSummoner

	if self.model.awaken == false then
		self:ShowEnhance()
	else
		self:ShowAwaken()
	end
end

--- @return void
function UIPopupEnhanceView:InitLocalization()
	self.config.localizeEnhance.text = LanguageUtils.LocalizeCommon("evolve")
	self.config.localizeSkill.text = LanguageUtils.LocalizeCommon("skill_enhance")
	self.config.localizeTapToClose.gameObject:SetActive(false)
end

--- @return void
function UIPopupEnhanceView:OnReadyShow(result)
	if result ~= nil then
		self:InitHero(result)
	end
end

--- @return void
function UIPopupEnhanceView:Hide()
	UIBaseView.Hide(self)
	if self.hero1 ~= nil then
		self.hero1:ReturnPool()
		self.hero1 = nil
	end
	if self.hero2 ~= nil then
		self.hero2:ReturnPool()
		self.hero2 = nil
	end
	---@param v StatUpgradeView
	for _, v in pairs(self.stats:GetItems()) do
		v:ReturnPool()
	end
	self.stats:Clear()
end

--- @return void
function UIPopupEnhanceView:ShowEnhance()
	--self.config.effectAwaken:SetActive(false)
	--self.config.effectEvolve:SetActive(true)
	self:UpdateUI()
end

--- @return void
function UIPopupEnhanceView:ShowAwaken()
	--self.config.effectAwaken:SetActive(true)
	--self.config.effectEvolve:SetActive(false)
	self:UpdateUI()
end

--- @return void
function UIPopupEnhanceView:UpdateUI()
	if self.isSummoner == true then
		self:UpdateUISummoner()
	else
		self:UpdateUIHero()
	end
end

--- @return StatUpgradeView
function UIPopupEnhanceView:GetNewStatView()
	local statView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.StatUpgradeView, self.config.stat)
	self.stats:Add(statView)
	return statView
end

--- @return void
function UIPopupEnhanceView:UpdateUIHero()
	---@type HeroResource
	local heroResource = self.model.heroResource
    local star2 = heroResource.heroStar
    local star1 = star2 - 1
	---@type HeroIconData
	local heroIconData1 = HeroIconData.CreateByHeroResource(heroResource)
	---@type HeroIconData
	local heroIconData2 = HeroIconData.CreateByHeroResource(heroResource)
	heroIconData1.star = star1

	---@type HeroLevelCapConfig
	local heroLevelCap1 = ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(star1)
	---@type HeroLevelCapConfig
	local heroLevelCap2 = ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(star2)

	local heroDataService = ResourceMgr.GetServiceConfig():GetHeroes()
	local heroSkillLevel1 = heroDataService:GetHeroSkillLevelData(star1)
	local heroSkillLevel2 = heroDataService:GetHeroSkillLevelData(star2)
	---@type HeroDataEntry
	local heroDataEntry = heroDataService:GetHeroDataEntry(heroResource.heroId)
	heroIconData1.level = heroLevelCap1.levelCap
	heroIconData2.level = heroLevelCap2.levelCap
	if self.hero1 == nil then
		self.hero1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.hero1)
	end
	if self.hero2 == nil then
		self.hero2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.hero2)
	end
	self.hero1:SetIconData(heroIconData1)
	self.hero2:SetIconData(heroIconData2)
    ---@type Dictionary
    local statDict1 = ClientConfigUtils.GetBaseStatHero(heroResource.heroId, heroResource.heroStar - 1, heroResource.heroLevel)
    ---@type Dictionary
    local statDict2 = ClientConfigUtils.GetBaseStatHero(heroResource.heroId, heroResource.heroStar, heroResource.heroLevel)
	self:GetNewStatView():SetData(LanguageUtils.LocalizeCommon("level_cap"), heroLevelCap1.levelCap, heroLevelCap2.levelCap)
	self:GetNewStatView():SetData(LanguageUtils.LocalizeStat(StatType.ATTACK), statDict1:Get(StatType.ATTACK), statDict2:Get(StatType.ATTACK))
	self:GetNewStatView():SetData(LanguageUtils.LocalizeStat(StatType.HP), statDict1:Get(StatType.HP), statDict2:Get(StatType.HP))
	self:GetNewStatView():SetData(LanguageUtils.LocalizeStat(StatType.SPEED), statDict1:Get(StatType.SPEED), statDict2:Get(StatType.SPEED))
	self:PlayEffectStat()

	self.listSkillView:SetDataHeroEvolve(heroResource, heroResource.heroStar - 1, true)
	local isContainSkill = false
	for i=1,4 do
		local lv1 = heroSkillLevel1.skillLevels:Get(i)
		local lv2 = heroSkillLevel2.skillLevels:Get(i)
		if heroDataEntry.allSkillDataDict:IsContainKey(i) and lv1 ~= lv2 then
			isContainSkill = true
			break
		end
	end
	if isContainSkill then
		self.config.panel.sizeDelta = U_Vector2(self.config.panel.sizeDelta.x, 888)
		self.config.skillEnhance:SetActive(true)
	else
		self.config.panel.sizeDelta = U_Vector2(self.config.panel.sizeDelta.x, 588)
		self.config.skillEnhance:SetActive(false)
	end
end

--- @return void
function UIPopupEnhanceView:UpdateUISummoner()
	---@type PlayerSummonerInBound
	local summonerInBound = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
	---@type BasicInfoInBound
	local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)

	if self.hero1 == nil then
		self.hero1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.hero1)
	end
	if self.hero2 == nil then
		self.hero2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.hero2)
	end
	self.hero1:SetDataMainHero(summonerInBound.summonerId, summonerInBound.star - 1)
	self.hero2:SetDataMainHero(summonerInBound.summonerId, summonerInBound.star)
    local statDict1 = ClientConfigUtils.GetStatSummoner(summonerInBound.summonerId, summonerInBound.star - 1, basicInfoInBound.level)
    local statDict2 = ClientConfigUtils.GetStatSummoner(summonerInBound.summonerId, summonerInBound.star, basicInfoInBound.level)
	self:GetNewStatView():SetData(LanguageUtils.LocalizeStat(StatType.ATTACK), statDict1:Get(StatType.ATTACK), statDict2:Get(StatType.ATTACK))
	self:GetNewStatView():SetData(LanguageUtils.LocalizeStat(StatType.SKILL_DAMAGE), statDict1:Get(StatType.SKILL_DAMAGE) * 100 .. "%", statDict2:Get(StatType.SKILL_DAMAGE) * 100 .. "%")
	self:GetNewStatView():SetData(LanguageUtils.LocalizeStat(StatType.PURE_DAMAGE), statDict1:Get(StatType.PURE_DAMAGE), statDict2:Get(StatType.PURE_DAMAGE))
	self:GetNewStatView():SetData(LanguageUtils.LocalizeStat(StatType.CRIT_DAMAGE), statDict1:Get(StatType.CRIT_DAMAGE) * 100 .. "%", statDict2:Get(StatType.CRIT_DAMAGE) * 100 .. "%")
	self:PlayEffectStat()

	self.listSkillView:SetDataSummoner(summonerInBound.summonerId, summonerInBound.star, false)
	self.config.panel.sizeDelta = U_Vector2(self.config.panel.sizeDelta.x, 888)
	self.config.skillEnhance:SetActive(true)
end

--- @return void
function UIPopupEnhanceView:PlayEffectStat()
	Coroutine.start(function ()
		--coroutine.waitforseconds(0.5)
		---@param v StatUpgradeView
		for _, v in ipairs(self.stats:GetItems()) do
			coroutine.waitforseconds(0.1)
			v:PlayEffect()
		end
	end)
end

--- @class UIIntroduceNewSkinView : UIBaseView
UIIntroduceNewSkinView = Class(UIIntroduceNewSkinView, UIBaseView)

--- @param model UIIntroduceNewSkinModel
function UIIntroduceNewSkinView:Ctor(model)
	--- @type UIIntroduceNewSkinConfig
	self.config = nil
	UIBaseView.Ctor(self, model)
	--- @type UIIntroduceNewSkinModel
	self.model = model
	--- @type number
	self.heroId = nil
	--- @type number
	self.skinId = nil
	--- @type WorldSpaceHeroView
	self.worldSpaceHeroView = nil
	---@type HeroResource
	self.heroResourcePreview = nil
	--- @type ItemsTableView
	self.itemsTableView = nil
end

function UIIntroduceNewSkinView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self.itemsTableView = ItemsTableView(self.config.itemListAnchor)

	self:InitButtons()
	self:ShowItemListInPack()
end

function UIIntroduceNewSkinView:InitButtons()
	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.bgClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonNavigate.onClick:AddListener(function()
		self:OnClickNavigateToBundleSkin()
	end)
end

function UIIntroduceNewSkinView:InitLocalization()
	self.config.textNavigate.text = LanguageUtils.LocalizeCommon("go_to_shop")
	self.config.textTitleSkin.text = LanguageUtils.LocalizeSkinName(self.skinId)
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("get_limited_skin_now")
end

--- @param data {callbackClose : function}
function UIIntroduceNewSkinView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self:InitPreviewHero()
	self:ShowPreviewHero()
end

--- @return void
--- Create view for preview hero
function UIIntroduceNewSkinView:InitPreviewHero()
	if self.worldSpaceHeroView == nil then
		---@type UnityEngine_Transform
		local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
		self.worldSpaceHeroView = WorldSpaceHeroView(trans)
		local renderTexture = U_RenderTexture(800, 800, 24, U_RenderTextureFormat.ARGB32)
		self.config.rawImageHero.texture = renderTexture
		self.worldSpaceHeroView:Init(renderTexture)
	end

	self.heroResourcePreview = HeroResource()
	self.heroResourcePreview:SetData(-1, self.heroId, 1, 1)
	self.heroResourcePreview.heroItem:Add(HeroItemSlot.SKIN, self.skinId)
end

--- @return void
--- Add hero and background to view preview hero
function UIIntroduceNewSkinView:ShowPreviewHero()
	self.worldSpaceHeroView:ShowHero(self.heroResourcePreview )
	self.worldSpaceHeroView.config.transform.position = U_Vector3(99000, 99000, 0)
	if self.worldSpaceHeroView ~= nil then
		self.worldSpaceHeroView.config.bg:SetActive(false)
	end
end

function UIIntroduceNewSkinView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
	self:OnReadyHide()
end

function UIIntroduceNewSkinView:OnClickNavigateToBundleSkin()
	zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	local data = { tab = EventKazetsuTab.BUNDLE }
	PopupMgr.ShowAndHidePopup(UIPopupName.UIEventKazetsu, data, self.model.uiName)
end

function UIIntroduceNewSkinView:ShowItemListInPack()
	self.newSkinConfig = ResourceMgr.GetEventConfig():GetNewSkinConfig()
	self.skinId = self.newSkinConfig:Get("skinId")
	self.heroId = self.newSkinConfig:Get("heroId")
	self.itemsTableView:SetData(RewardInBound.GetItemIconDataList(self.newSkinConfig:Get("listItem")))
	self.itemsTableView:EnableGlowBackground()
end

--- @return void
function UIIntroduceNewSkinView:Hide()
	UIBaseView.Hide(self)
	zg.playerData.remoteConfig.showedEventKazetsuTime = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay
	zg.playerData:SaveRemoteConfig()
end

--- @return void
function UIIntroduceNewSkinView:OnReadyHide()
	UIBaseView.OnReadyHide(self)
	if self.worldSpaceHeroView ~= nil then
		self.worldSpaceHeroView:OnHide()
		self.worldSpaceHeroView = nil
	end
end

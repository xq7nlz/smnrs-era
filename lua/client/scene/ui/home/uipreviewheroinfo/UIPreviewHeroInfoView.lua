require "lua.client.scene.ui.common.HeroEquipmentView"
require "lua.client.scene.ui.common.prefabHeroInfo.PrefabHeroInfo2View"

--- @class UIPreviewHeroInfoView : UIBaseView
UIPreviewHeroInfoView = Class(UIPreviewHeroInfoView, UIBaseView)

--- @param model UIPreviewHeroInfoModel
function UIPreviewHeroInfoView:Ctor(model)
	--- @type UIPreviewHeroInfoConfig
	self.config = nil
	--- @type HeroResource
	self.heroResource = nil
	--- @type HeroEquipmentView
	self.heroEquipmentView = nil
	---@type PrefabHeroInfo2View
	self.prefabHeroInfoView = nil
	--- @type WorldSpaceHeroView
	self.worldSpaceHeroView = nil

	UIBaseView.Ctor(self, model)
	--- @type UIPreviewHeroInfoModel
	self.model = model
end


function UIPreviewHeroInfoView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self.heroEquipmentView = HeroEquipmentView(self.config.heroEquipmentView)
	self.heroEquipmentView:EnableIconPlus(false)

	self.prefabHeroInfoView = PrefabHeroInfo2View(self.config.prefabHeroInfo2)

	self:InitButtons()
end


function UIPreviewHeroInfoView:InitButtons()
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.bgNone.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
end

function UIPreviewHeroInfoView:InitLocalization()
	self.heroEquipmentView:InitLocalization()
end

--- @param data {heroResource, onSelectItem, overrideStatDict}
function UIPreviewHeroInfoView:OnReadyShow(data)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)

	local heroResource = data.heroResource
	UIBaseView.OnReadyShow(self, heroResource)

	self.heroResource = heroResource

	self.heroEquipmentView:ShowItems(heroResource, data.onSelectItem)
	local disableIdleEffect = data.disableIdleEffect == true
	local power
	if data.overrideStatDict ~= nil then
		power = data.overrideStatDict:Get(StatType.POWER)
	end
	self.prefabHeroInfoView:SetData(heroResource, power, data.overrideStatDict)

	self:ShowHeroModel(heroResource,disableIdleEffect)
end

function UIPreviewHeroInfoView:ShowHeroModel(heroResource,disableIdleEffect)
	if self.worldSpaceHeroView == nil then
		---@type UnityEngine_Transform
		local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
		self.worldSpaceHeroView = WorldSpaceHeroView(trans)
		local renderTexture = U_RenderTexture(1000, 1000, 24, U_RenderTextureFormat.ARGB32)
		self.config.rawImage.texture = renderTexture
		self.worldSpaceHeroView:Init(renderTexture)
	end
	self.worldSpaceHeroView:ShowHero(heroResource,nil,disableIdleEffect)
	self.worldSpaceHeroView.config.transform.position = U_Vector3(100 , 100, 0)
	self.worldSpaceHeroView.config.bg:SetActive(false)
end

function UIPreviewHeroInfoView:Hide()
	UIBaseView.Hide(self)

	self.heroEquipmentView:OnHide()

	self.prefabHeroInfoView:OnHide()
	if self.worldSpaceHeroView ~= nil then
		self.worldSpaceHeroView:OnHide()
		self.worldSpaceHeroView = nil
	end
end
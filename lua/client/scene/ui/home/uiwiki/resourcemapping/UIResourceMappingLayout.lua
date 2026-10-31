local RESOURCE_MAPPING_PATH = "csv/wiki/mapping_resource.csv"
--- @class UIResourceMappingLayout
UIResourceMappingLayout = Class(UIResourceMappingLayout)

--- @return void
--- @param transform UnityEngine_Transform
--- @param view UIWikiView
function UIResourceMappingLayout:Ctor(view, transform)
	--- @type UICommunityTotalView
	self.view = view
	---@type UIResourceMappingConfig
	self.config = UIBaseConfig(transform)
	--- @type List
	self.listIconData = List()
	--- @type Dictionary
	self.listFeatureData = Dictionary()
	--- @type List
	self.listIconItem = List()
	self:ReadCsv()
	self:InitScrollResource()
	self:InitScrollMapping()
end

function UIResourceMappingLayout:ReadCsv()
	local dataParse = CsvReaderUtils.ReadAndParseLocalFile(RESOURCE_MAPPING_PATH)
	local listFeature = List()
	for _, data in ipairs(dataParse) do
		if data.res_type ~= nil then
			local iconData = RewardInBound.CreateByParams(data)
			if iconData ~=nil then
				listFeature = List()
				local featureType = tonumber(data.feature_type)
				if featureType ~= nil then
					listFeature:Add(tonumber(data.feature_type))
				end
				self.listFeatureData:Add(tonumber(data.res_id),listFeature)
				self.listIconData:Add(iconData)
			end
		else
			listFeature:Add(tonumber(data.feature_type))
		end
	end
end

function UIResourceMappingLayout:InitScrollResource()
	--- @param obj ResourceMappingResourceItemView
	--- @param index number
	local onCreateItem = function(obj, index)
		obj:DisableHighLight()
		obj:SetData(self.listIconData:Get(index + 1))
		if  self.currentItemId ~= nil then
			if obj.id == self.currentItemId then
				obj:EnableHighLight()
			end
		end
		obj:AddListener(function()
			self:ChangeFeature(obj.id)
			self:SetCurrent(obj)
		end)
		self.listIconItem:Add(obj)
	end
	self.uiScroll = UILoopScroll(self.config.scrollResource,
			UIPoolType.ResourceMappingResourceItemView, onCreateItem)
	self.uiScroll:SetUpMotion(MotionConfig(0, 0, 0, 0.02, 3))
end
--- @param obj ResourceMappingResourceItemView
function UIResourceMappingLayout:SetCurrent(obj)
	for i = 1, self.listIconItem:Count() do
		self.listIconItem:Get(i):DisableHighLight()
	end
	self.currentItemId= obj.id
	obj:EnableHighLight()
end

function UIResourceMappingLayout:InitScrollMapping()
	--- @param obj ResourceMappingResourceItemView
	--- @param index number
	local onCreateItem = function(obj, index)
		local currentItemId = 0
		if self.currentItemId  ~= nil then
			currentItemId = self.currentItemId
		else
			currentItemId = self.listIconData:Get(1).id
		end
		local feature = self.listFeatureData:Get(currentItemId):Get(index + 1)
		obj:SetData(feature)
		obj:AddListener(function()
			local onSuccess = function()
				PopupMgr.HidePopup(UIPopupName.UICommunityTotal)
			end
			--- @type FeatureConfigInBound
			local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
			local featureItemInBound = featureConfigInBound:GetFeatureConfigInBound(feature)
			if featureItemInBound.featureState == FeatureState.MAINTAIN then
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("feature_maintain"))
				return
			end
			FeatureMapping.GoToFeature(feature, true, onSuccess)
		end)
	end
	self.uiScrollFeature = UILoopScroll(self.config.scrollMapping,
			UIPoolType.ResourceMappingFeatureItemView, onCreateItem)
end

--- @return void
function UIResourceMappingLayout:Show()
	self.view:EnableEmpty(false)
	self.config.gemDescText.text = LanguageUtils.LocalizeCommon("desc_gem_feature")
	self.config.choseOne.text = LanguageUtils.LocalizeCommon("please_chose_one_resource")
	self.config.choseOne.gameObject:SetActive(true)
	self.uiScroll:Resize(self.listIconData:Count())
end

--- @return void
function UIResourceMappingLayout:ChangeFeature(id)
	self.config.choseOne.gameObject:SetActive(false)
	self.currentItemId = id
	local count  = self.listFeatureData:Get(id):Count()
	self.uiScrollFeature:Resize(count)
	if count > 0 then
		self.config.gemDescText.gameObject:SetActive(false)
	else
		if self.currentItemId == MoneyType.GEM then
			self.config.gemDescText.gameObject:SetActive(true)
		else
			self.config.choseOne.gameObject:SetActive(true)
		end
	end
end


--- @return void
function UIResourceMappingLayout:Hide()
	self.listIconItem:Clear()
    self.uiScroll:Hide()
	self.uiScrollFeature:Hide()
	self.currentItemId = nil
	self.config.gemDescText.gameObject:SetActive(false)
	self.config.choseOne.gameObject:SetActive(false)
end
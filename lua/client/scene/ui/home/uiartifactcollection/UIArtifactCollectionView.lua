require "lua.client.scene.ui.utils.uiSelect.UISelectCustomSprite"

--- @class UIArtifactCollectionView : UIBaseView
UIArtifactCollectionView = Class(UIArtifactCollectionView, UIBaseView)

--- @return void
--- @param model UIArtifactCollectionModel
function UIArtifactCollectionView:Ctor(model, ctrl)
	---@type UIArtifactCollectionConfig
	self.config = nil
	---@type UISelectRarityFilter
	self.selectType = nil
	---@type UILoopScroll
	self.uiScroll = nil

	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	---@type UIArtifactCollectionModel
	self.model = model
end

--- @return void
function UIArtifactCollectionView:OnReadyCreate()
	---@type UIArtifactCollectionConfig
	self.config = UIBaseConfig(self.uiTransform)

	-- Select faction
	local onChangeSelect = function (indexTab)
		if indexTab == nil then
			self.config.iconSelect.gameObject:SetActive(false)
		else
			self.config.iconSelect.gameObject:SetActive(true)
			self.config.iconSelect.transform.position = self.config.selectType:GetChild(indexTab - 1).position
		end
		self:Sort()
	end
	self.selectType = UISelectRarityFilter(self.config.selectType, nil, nil, onChangeSelect)
	--self.selectType:SetSprite()

	--- @param obj ItemIconView
	--- @param index number
	local onCreateItem = function(obj, index)
		local type = ResourceType.ItemArtifact
		local id = self.model.itemDic:Get(index + 1)
		obj:EnableButton(true)
		obj:SetIconData(ItemIconData.CreateInstance(type, id))
		obj:RemoveAllListeners()
		obj:AddListener(function ()
			PopupMgr.ShowPopup(UIPopupName.UIItemPreview, { ["data1"] = { ["type"] = type, ["id"] = id }})
		end)
	end
	self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.ItemIconView, onCreateItem)

	self.config.buttonBack.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.bgClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
end

--- @return void
function UIArtifactCollectionView:InitLocalization()
	self.config.titleArtifactCollection.text = LanguageUtils.LocalizeCommon("gallery")
end

--- @return void
function UIArtifactCollectionView:OnReadyShow()
	self.selectType:Select(nil)
end

--- @return void
function UIArtifactCollectionView:Sort()
	if self.selectType.indexTab ~= nil then
		self.model.itemDic = UIArtifactCollectionView.GetArtifactCollection( 1, self.selectType.indexTab)
	else
		self.model.itemDic = UIArtifactCollectionView.GetArtifactCollection(1)
	end
	self.uiScroll:Resize(self.model.itemDic:Count())
end

--- @return List <number>
function UIArtifactCollectionView.GetArtifactCollection(sort, rarity)
	local list = List()
	local cacheItem = Dictionary()
	---@param artifactDataEntry ArtifactDataEntry
	for k, artifactDataEntry in pairs(ResourceMgr.GetServiceConfig():GetItems().artifactDataEntries:GetItems()) do
		if (rarity == nil or artifactDataEntry.rarity == rarity) and k < 354310000 then
			local id = math.floor(k / 1000)
			if cacheItem:IsContainKey(id) == false or cacheItem:Get(id) < k then
				cacheItem:Add(id, k)
			end
		end
	end

	for _, id in pairs(cacheItem:GetItems()) do
		list:Add(id)
	end

	if sort == 1 then
		list:SortWithMethod(SortUtils._ArtifactSortRarityAndStar)
	elseif sort == -1 then
		list:SortWithMethod(SortUtils._ArtifactSortRarityAndStarFlip)
	end
	return list
end
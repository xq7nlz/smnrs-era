
--- @class UIDungeonCollectionBagView : UIBaseView
UIDungeonCollectionBagView = Class(UIDungeonCollectionBagView, UIBaseView)

--- @return void
--- @param model UIDungeonCollectionBagModel
function UIDungeonCollectionBagView:Ctor(model)
	--- @type UIDungeonCollectionBagConfig
	self.config = nil
	--- @type UILoopScroll
	self.uiScroll = nil
	--- @type List
	self.rewardList = nil

	UIBaseView.Ctor(self, model)
	--- @type UIDungeonCollectionBagModel
	self.model = model
end

--- @return void
function UIDungeonCollectionBagView:OnReadyCreate()
	---@type UIDungeonCollectionBagConfig
	self.config = UIBaseConfig(self.uiTransform)

	self:_InitButtonListener()
	self:_InitScrollView()
end

--- @return void
function UIDungeonCollectionBagView:InitLocalization()
	self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("collection_bag")
end

function UIDungeonCollectionBagView:_InitButtonListener()
	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
end

function UIDungeonCollectionBagView:_InitScrollView()
	--- @param obj DungeonBuffCardView
	--- @param index number
	local onUpdateItem = function(obj, index)
		---@type RewardInBound
		local reward = self.rewardList:Get(index + 1)
		obj:SetIconData(reward)
		obj:AddListener(nil, nil)
	end
	--- @type UILoopScroll
	self.uiScroll = UILoopScroll(self.config.loopScrollRect, UIPoolType.DungeonBuffCardView, onUpdateItem, onUpdateItem)
end

--- @return void
function UIDungeonCollectionBagView:OnReadyShow()
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	--- @type DungeonInBound
	self.server = zg.playerData:GetMethod(PlayerDataMethod.DUNGEON)
	self:SetRewardData()
	--self:FakeRewardData()
	self:UpdateView()
end

function UIDungeonCollectionBagView:UpdateView()
	local count = self.rewardList:Count()
	if count == 0 then
		self.config.empty:SetActive(true)
	else
		self.config.empty:SetActive(false)
		self.uiScroll:Resize(count)
		self.uiScroll:PlayMotion()
	end
end

function UIDungeonCollectionBagView:SetRewardData()
	self.rewardList = List()
	--- @param v RewardInBound
	for i, v in pairs(self.server.passiveBuff:GetItems()) do
		self.rewardList:Add(v)
	end
end

function UIDungeonCollectionBagView:FakeRewardData()
	local potionIdList = {1001, 1002, 1003, 1004, 1005, 1007, 2002, 2003, 2004, 2005, 2006, 2007, 2009, 2010, 2011, 2012, 2013, 3003, 3004, 3005, 3006, 3007, 3008, 3009, 4002, 4004, 4006, 4007 }
	self.rewardList = List()
	for _, v in ipairs(potionIdList) do
		self.rewardList:Add(RewardInBound.CreateBySingleParam(ResourceType.DungeonItemPassiveBuff, v, 3))
	end
end

function UIDungeonCollectionBagView:Hide()
	UIBaseView.Hide(self)
	self.uiScroll:Hide()
end


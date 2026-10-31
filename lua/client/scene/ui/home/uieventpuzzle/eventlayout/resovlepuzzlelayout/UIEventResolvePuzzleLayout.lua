require "lua.client.scene.ui.home.uiEventPuzzle.eventLayout.resovlePuzzleLayout.PuzzlePieceOpenResult"
--- @class UIEventResolvePuzzleLayout : UIEventPuzzleLayout
UIEventResolvePuzzleLayout = Class(UIEventResolvePuzzleLayout, UIEventPuzzleLayout)

--- @param view UIEventPuzzleView
---@param noti UnityEngine_GameObject
function UIEventResolvePuzzleLayout:Ctor(view, tab, anchor,noti)
	self.noti = noti
	self.anchor = anchor
	self.tab = tab
	---@type UIResolvePuzzleConfig
	self.layoutConfig = nil
	---@type PuzzlePieceOpenData
	self.puzzleData = nil
	--- @type List
	self.listPuzzleSlot = List()
	UIEventPuzzleLayout.Ctor(self, view, tab, anchor)
end

--- @param objectView UnityEngine_GameObject
function UIEventResolvePuzzleLayout:InitLayoutConfig(objectView)
	local inst = PrefabLoadUtils.Instantiate("event_resolve_puzzle_layout", self.anchor)
	UIEventPuzzleLayout.InitLayoutConfig(self, inst)
	self:InitButtons()
	self:InitScroll()
	self:InitLocalization()
end

function UIEventResolvePuzzleLayout:SetUpLayout()
	UIEventPuzzleLayout.SetUpLayout(self)
	self.anchor.gameObject:SetActive(true)
end

function UIEventResolvePuzzleLayout:InitData()
	self.puzzleData = self.eventModel:GetCurrentPuzzleData()
	self.layoutConfig.banner.sprite = ResourceLoadUtils.LoadPuzzleBanner(self.puzzleData.heroId)
end

function UIEventResolvePuzzleLayout:InitScroll()
	--- @param obj PuzzleSlotItemView
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type UnityEngine_UI_Image
		local itemIconData = ResourceLoadUtils.LoadPuzzleImage(dataIndex)
		obj:SetSlotState(self.eventModel:CheckUnlockSlot(dataIndex))
		obj:EnableButton()
		obj:SetImage(itemIconData)
		self.listPuzzleSlot:Add(obj)
	end
	self.scrollView = UILoopScroll(self.layoutConfig.scroll, UIPoolType.PuzzleSlotItem, onCreateItem)
end
--- @return boolean
function UIEventResolvePuzzleLayout:CheckUnlockPicture()
	for i = 1, self.listPuzzleSlot:Count() do
		if self.listPuzzleSlot:Get(i).isUnlock == false then
			return false
		end
	end
	self.layoutConfig.resolveButton.gameObject:SetActive(false)
	self.layoutConfig.claimButton.gameObject:SetActive(true)
end

--- @return boolean
function UIEventResolvePuzzleLayout:NextPicture()
	self:GetModelConfig()
	self.eventModel.completedSlot = self.eventModel.completedSlot + 1
	if self.eventModel.completedSlot == 4 then
		self.view:SelectTab(EventPuzzleTab.SELECT_HERO)
		return
	end
	self.eventModel:UpdateCurrentPuzzleData()
	self:OnShow()
end

function UIEventResolvePuzzleLayout:InitButtons()
	self.layoutConfig.resolveButton.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickOpen()
	end)
	self.layoutConfig.claimButton.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickClaim()
	end)
	self.layoutConfig.buttonShowReward.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickShowReward()
	end)
end

function UIEventResolvePuzzleLayout:InitLocalization()
	self.layoutConfig.resolveText.text = LanguageUtils.LocalizeCommon("open")
	self.layoutConfig.textClaim.text = LanguageUtils.LocalizeCommon("claim")
end

function UIEventResolvePuzzleLayout:OnShow()
	UIEventPuzzleLayout.OnShow(self)
	self:InitData()
	self:InitLocalization()
	self.scrollView:Resize(self.eventConfig:GetNumberOfPuzzlePiece())
	self.layoutConfig.resolveButton.gameObject:SetActive(true)
	self.layoutConfig.claimButton.gameObject:SetActive(false)
	--- @type MoneyBarView
	if 	self.puzzlePieceBarView == nil then
		self.puzzlePieceBarView = MoneyBarView()
		self.puzzlePieceBarView:SetConfig(self.layoutConfig.moneyAnchor)
	end
	self.puzzlePieceBarView:SetIconData(MoneyType.EVENT_PUZZLE_PIECE, nil, true, true)
	self.puzzlePieceBarView:SetText1(1)
	self:CheckUnlockPicture()
end

function UIEventResolvePuzzleLayout:UpdatePiece()
	self.puzzlePieceBarView:SetIconData(MoneyType.EVENT_PUZZLE_PIECE, nil, true, true)
	self.puzzlePieceBarView:SetText1(1)
end
function UIEventResolvePuzzleLayout:OnClickOpen()
	if InventoryUtils.GetMoney(MoneyType.EVENT_PUZZLE_PIECE) < self.eventConfig:GetResolvePuzzlePrice() then
		local firstReward = RewardInBound.CreateBySingleParam(ResourceType.Money,
				MoneyType.EVENT_PUZZLE_PIECE,
				self.eventConfig:GetResolvePuzzlePrice())
		return InventoryUtils.IsEnoughSingleResourceRequirement(firstReward, true)
	end

	local onReceived = function(result)
		--- @type PuzzlePieceOpenResult
		local puzzleData = PuzzlePieceOpenResult()
		--- @param buffer UnifiedNetwork_ByteBuf
		local onBufferReading = function(buffer)
			puzzleData:Serialize(buffer)
		end
		local onSuccess = function()
			self:GetModelConfig()
			self.eventModel:UnlockPuzzleState(puzzleData.pieceId)
			PopupUtils.ClaimAndShowRewardList(puzzleData.listRewards)
			self.listPuzzleSlot:Get(puzzleData.pieceId):SetSlotState(true)
			InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_PUZZLE_PIECE,1)
			self:CheckUnlockPicture()
			self:UpdatePiece()
			self.view:UpdateNotificationByTab(EventPuzzleTab.PUZZLE)
		end
		NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
	end
	NetworkUtils.Request(OpCode.EVENT_PUZZLE_PIECE_OPEN,
			UnknownOutBound.CreateInstance(PutMethod.Int,
					self.eventModel.completedSlot + 1),
			onReceived)
end

function UIEventResolvePuzzleLayout:OnClickClaim()
	local onReceived = function(result)
		--- @type List
		local listRewards = List()
		--- @param buffer UnifiedNetwork_ByteBuf
		local onBufferReading = function(buffer)
			 listRewards = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)
		end
		local onSuccess = function()
			PopupUtils.ClaimAndShowRewardList(listRewards)
			self:NextPicture()
		end
		NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
	end
	NetworkUtils.Request(OpCode.EVENT_PUZZLE_OPEN_HERO_PIECE_SELECT, UnknownOutBound.CreateInstance(PutMethod.Int, self.eventModel.completedSlot + 1), onReceived)
end


function UIEventResolvePuzzleLayout:UpdateNotification()
	local noti = InventoryUtils.GetMoney(MoneyType.EVENT_PUZZLE_PIECE) > 0
	self.noti:SetActive(noti)
	return  noti
end



function UIEventResolvePuzzleLayout:OnClickShowReward()
	local data = {}
	--- @type List
	data.listRewardIconData = self.eventConfig:GetListPuzzlePieceReward()
	data.uiPoolType = UIPoolType.RateView
	PopupMgr.ShowPopup(UIPopupName.UIShowItemInRandomPool, data)
end

function UIEventResolvePuzzleLayout:OnHide()
	UIEventPuzzleLayout.OnHide(self)
	self.scrollView:Hide()
	self.listPuzzleSlot:Clear()
end
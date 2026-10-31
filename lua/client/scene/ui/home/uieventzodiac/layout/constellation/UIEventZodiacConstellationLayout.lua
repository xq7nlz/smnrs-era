--- @class UIEventZodiacConstellationLayout : UIEventZodiacLayout
UIEventZodiacConstellationLayout = Class(UIEventZodiacConstellationLayout, UIEventZodiacLayout)

local NUMBER_OF_CONSTELLATION = 10;

--- @param view UIEventZodiacView
--- @param anchor UnityEngine_RectTransform
function UIEventZodiacConstellationLayout:Ctor(view, tab, anchor)
	---@type UIEventZodiacConstellationConfig
	self.layoutConfig = nil
	--- @type EventTimeType
	self.eventTimeType = EventTimeType.EVENT_ZODIAC
	--- @type ItemsTableView
	self.moneyTableView = nil
	UIEventZodiacLayout.Ctor(self, view, tab, anchor)
end

function UIEventZodiacConstellationLayout:InitLayoutConfig()
	local inst = PrefabLoadUtils.Instantiate("zodiac_constellation", self.anchor)
	UIEventZodiacLayout.InitLayoutConfig(self, inst)
	self:InitButtonListener()
	self:_InitMoneyTableView()
end

function UIEventZodiacConstellationLayout:_InitMoneyTableView()
	self.moneyTableView = ItemsTableView(self.layoutConfig.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

function UIEventZodiacConstellationLayout:InitLocalization()
	UIEventZodiacLayout.InitLocalization(self)
	self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("zodiac_constellation")
	self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("zodiac_constellations")
	self.layoutConfig.moneyValueText.text = self.eventConfig.costStarAmount
	self.layoutConfig.quickOpenMapText.text = LanguageUtils.LocalizeCommon("quick_open_constellation_map")
end

function UIEventZodiacConstellationLayout:UpdateLocalization()
	local remainFree =  self.eventConfig.freeOpenStarAmount - self.eventModel.zodiacConstellationData.freeMapping
	local freeText  = ""
	if remainFree > 0 then
		freeText = " " .. UIUtils.SetColorString(UIUtils.green_light,
				LanguageUtils.LocalizeCommon("free") .. " x" ..remainFree )
	end
	local text = LanguageUtils.LocalizeCommon("event_zodiac_map") .. freeText
	self.layoutConfig.openMapText.text = text
end


function UIEventZodiacConstellationLayout:OnShow(view)
	UIEventZodiacLayout.OnShow(self)
	self:_InitMoneyBar()
	self.layoutConfig.starBg.sprite = ResourceLoadUtils.LoadConstellationBackground(self.eventModel.zodiacConstellationData.currentMap)
	self.layoutConfig.starBg:SetNativeSize()

	if self.constellationPointPosition == nil then
		self.constellationPointPosition = self.eventConfig:GetConstellationPointPositionConfig()
	end

	self:InitLocalization()
	self:UpdateLocalization()

	for i = 1, NUMBER_OF_CONSTELLATION do
		local index = i-1
		--- @type UnityEngine_Vector2
		local pos = self.constellationPointPosition:Get(self.eventModel.zodiacConstellationData.currentMap):Get(i)
		pos = U_Vector3(pos.x,pos.y,0)
		local child = self.layoutConfig.nodeAnchor:GetChild(index)
		child.localPosition = pos
		child.gameObject:SetActive(false)
	end
	self:DrawLine()
end

function UIEventZodiacConstellationLayout:InitButtonListener()
	self.layoutConfig.mapButton.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnOpenMapClick(true)
	end)
	self.layoutConfig.quickButton.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnOpenMapClick(false)
	end)
	self.layoutConfig.backButton.onClick:AddListener(function()
		self:CloseLayout()
	end)
	self.layoutConfig.rewardButton.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickReward()
	end)
end

function UIEventZodiacConstellationLayout:CloseLayout()
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
	self:OnHide()
end

function UIEventZodiacConstellationLayout:OnClickHelp()

end


function UIEventZodiacConstellationLayout:OnClickReward()
	self.layoutConfig.line.gameObject:SetActive(false)
	local data = {}
	--- @type List
	data.listRewardIconData = self.eventConfig:GetListRewardConstellation()
	--- @type List
	data.listRewardIconData2 = self.eventConfig:GetListFinalRewardConstellation()
	data.uiPoolType = UIPoolType.RateView
	data.callbackClose = function()
		PopupMgr.HidePopup(UIPopupName.UIShowItemInRandomPoolSplit)
		if self.eventModel.zodiacConstellationData.currentPosition > 0 then
			self.layoutConfig.line.gameObject:SetActive(true)
		end
	end
	PopupMgr.ShowPopup(UIPopupName.UIShowItemInRandomPoolSplit, data)
end

function UIEventZodiacConstellationLayout:OnOpenMapClick(isNormal)
	---@type List
	local rewardList1 = List()
	---@type List
	local rewardList2 = List()
	---@type List
	local listIconData = List()
	---@type List
	local listIconData2 = List()
	local price = 0
	local openPos = 0
	local freeAmount = self.eventConfig.freeOpenStarAmount - self.eventModel.zodiacConstellationData.freeMapping
	local isFree = freeAmount > 0
	local star = InventoryUtils.GetMoney(MoneyType.SUPER_PEARL) + freeAmount
	if isNormal then
		if not isFree then
			price = self.eventConfig.costStarAmount
		end
		if price > star then
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("not_enough_resource"))
			return
		end
		openPos = self.eventModel.zodiacConstellationData.currentPosition + 1
	else
		local maxReach = self.eventConfig.constellationMapAmount - self.eventModel.zodiacConstellationData.currentPosition
		if maxReach >= star then
			price = star
		elseif maxReach < star then
			price = maxReach
		end
		openPos = self.eventModel.zodiacConstellationData.currentPosition + price
		price = price - freeAmount
		if price > star or star == 0 then
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("not_enough_resource"))
			return
		end
	end

	if price > 0 then
		isFree = false
	end
	local onReceived = function(result)
		--- @param buffer UnifiedNetwork_ByteBuf
		local onBufferReading = function(buffer)
			local size = buffer:GetByte()
			for i = 1, size do
				rewardList1:Add(RewardInBound.CreateByBuffer(buffer))
			end
			size = buffer:GetByte()
			for i = 1, size do
				rewardList2:Add(RewardInBound.CreateByBuffer(buffer))
			end
		end
		local onFailed = function(logicCode)
			SmartPoolUtils.LogicCodeNotification(logicCode)
		end
		local onSuccess = function()
			self:OnOpenSuccess(isFree,price,isNormal,openPos)
			--- @type ItemIconData
			local reward = nil
			if rewardList2 ~= nil and rewardList2:Count() > 0 then
				for i = 1, rewardList2:Count() do
					reward  = rewardList2:Get(i)
					reward:AddToInventory()
					listIconData2:Add(reward:GetIconData())
				end
				for i = 1, rewardList1:Count() do
					reward  = rewardList1:Get(i)
					reward:AddToInventory()
					listIconData:Add(reward:GetIconData())
				end
				PopupUtils.ClaimAndShowSplitReward(listIconData,listIconData2)
			elseif rewardList1 ~= nil and rewardList1:Count() > 0 then
				for i = 1, rewardList1:Count() do
					listIconData:Add(rewardList1:Get(i):GetIconData())
				end
				PopupUtils.ClaimAndShowItemList(listIconData)
			end
		end
		NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
	end
	NetworkUtils.Request(OpCode.EVENT_ZODIAC_LIGHTING_MAPPING,
			UnknownOutBound.CreateInstance(PutMethod.Int,openPos,PutMethod.Bool, isFree),
			onReceived)
end


function UIEventZodiacConstellationLayout:OnOpenSuccess(isFree,price,isNormal,openPos)
	self.layoutConfig.line.gameObject:SetActive(true)
	if isFree then
		self.eventModel.zodiacConstellationData.freeMapping = self.eventModel.zodiacConstellationData.freeMapping + openPos - self.eventModel.zodiacConstellationData.currentPosition
	else
		self.eventModel.zodiacConstellationData.freeMapping = self.eventConfig.freeOpenStarAmount
		InventoryUtils.Sub(ResourceType.Money, MoneyType.SUPER_PEARL, price)
	end
	self.eventModel.zodiacConstellationData.currentPosition = openPos
	self:UpdateLocalization()
	if self.eventModel.zodiacConstellationData.currentPosition == 10 then
		self:ChangeMap()
		return
	end
	self:DrawLine()
	--self.eventModel.zodiacConstellationData.currentPosition = self.eventModel.zodiacConstellationData.currentPosition + 1
end

function UIEventZodiacConstellationLayout:ChangeMap()
	self.layoutConfig.line.gameObject:SetActive(false)
	self.eventModel.zodiacConstellationData.currentPosition = 0
	self.eventModel.zodiacConstellationData.currentMap = self.eventModel.zodiacConstellationData.currentMap + 1
	if self.eventModel.zodiacConstellationData.currentMap > 12  then
		self.eventModel.zodiacConstellationData.currentMap = 1
	end
	self.layoutConfig.starBg.sprite = ResourceLoadUtils.LoadConstellationBackground(self.eventModel.zodiacConstellationData.currentMap)
	self.layoutConfig.starBg:SetNativeSize()
	for i = 1, NUMBER_OF_CONSTELLATION do
		local index = i-1
		--- @type UnityEngine_Vector2
		local pos = self.constellationPointPosition:Get(self.eventModel.zodiacConstellationData.currentMap):Get(i)
		pos = U_Vector3(pos.x,pos.y,0)
		local child = self.layoutConfig.nodeAnchor:GetChild(index)
		child.localPosition = pos
		child.gameObject:SetActive(false)
	end
	self:UpdateLocalization()
end


function UIEventZodiacConstellationLayout:DrawLine()
	local map = self.constellationPointPosition:Get(self.eventModel.zodiacConstellationData.currentMap)
	local pos = nil
	local child= nil
	local currentConstellationPosition = self.eventModel.zodiacConstellationData.currentPosition
	for i = 1, currentConstellationPosition do
		pos = map:Get(i)
		pos = U_Vector3(pos.x, pos.y, 0)
		self.layoutConfig.line:SetPosition(i - 1, pos)
		self.layoutConfig.nodeAnchor:GetChild(i - 1).gameObject:SetActive(true)
	end
	if currentConstellationPosition > 0 then
		--- @type UnityEngine_Vector2
		pos = map:Get(currentConstellationPosition)
		pos = U_Vector3(pos.x, pos.y, 0)
		for i = currentConstellationPosition, 9 do
			self.layoutConfig.line:SetPosition(i, pos)
		end
	end
end

--- @return void
function UIEventZodiacConstellationLayout:_InitMoneyBar()
	self:SetUpMoneyBar(MoneyType.STAR_POINT, MoneyType.SUPER_PEARL)
end

function UIEventZodiacConstellationLayout:SetUpMoneyBar(...)
	local args = { ... }
	local moneyList = List()
	for i = 1, #args do
		moneyList:Add(args[i])
	end
	self.moneyTableView:SetData(moneyList)
end


function UIEventZodiacConstellationLayout:OnHide()
	UIEventZodiacLayout.OnHide(self)
	if self.moneyBar ~= nil then
		self.moneyBar:ReturnPool()
		self.moneyBar = nil
	end
	local pos = U_Vector3(0,0,0)
	for i = 0, 9 do
		self.layoutConfig.line:SetPosition(i, pos)
	end
end

--- @class UISelectTalentView : UIBaseView
UISelectTalentView = Class(UISelectTalentView, UIBaseView)

--- @param model UISelectTalentModel
function UISelectTalentView:Ctor(model)
	---@type List
	self.listTalentSelectItemView = List()
	--- @type UISelectTalentConfig
	self.config = nil
	UIBaseView.Ctor(self, model)
	--- @type UISelectTalentModel
	self.model = model
	--- @type ItemsTableView
	self.moneyTableView = nil
	--- @type ItemsTableView
	self.moneyCostTableView = nil
end

function UISelectTalentView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self:InitButtons()
end

function UISelectTalentView:InitButtons()
	self.config.background.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonRefresh.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRefresh()
	end)
    self.config.buttonHelp.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelp()
    end)
end

function UISelectTalentView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("select_talent")
	self.config.textRefresh.text = LanguageUtils.LocalizeCommon("refresh")
end

--- @param data {callbackClose : function}
function UISelectTalentView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self:_InitMoneyTableView()
	self.heroInventoryId = data.heroInventoryId
	self.slotId = data.slotId
	self.listId = data.listId
	self.callbackSelectId = data.callbackSelectId

	---@type ItemCollectionInBound
	self.itemCollectionInBound = zg.playerData:GetMethod(PlayerDataMethod.ITEM_COLLECTION)
	self:ShowListTalent()
end

function UISelectTalentView:ShowListTalent()
	self:HideListTalent()
	for _, v in ipairs(self.listId:GetItems()) do
		---@type TalentSelectItemView
		local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.TalentSelectItemView, self.config.item)
		item:SetIconData(v, function (id)
			self:SelectTalentId(id)
		end)
		self.listTalentSelectItemView:Add(item)
	end

	self.talentConfigList = ResourceMgr.GetHeroRefreshTalentConfig():GetTalentConfigListBySlotEquipment(self.slotId)
	local listRefreshMoneyCost = List()
	--- @param talentConfig TalentConfig
	for i, talentConfig in ipairs(self.talentConfigList:GetItems()) do
		listRefreshMoneyCost:Add(talentConfig.refreshMoneyData:GetRewardInbound())
	end
	self.moneyCostTableView:SetData(RewardInBound.GetItemIconDataList(listRefreshMoneyCost))

	local listCurrentMoneyNeed = List()
	--- @param talentConfig TalentConfig
	for i, talentConfig in ipairs(self.talentConfigList:GetItems()) do
		listCurrentMoneyNeed:Add(talentConfig.moneyRefreshType)
	end

	self.moneyTableView:SetData(listCurrentMoneyNeed)
end

function UISelectTalentView:SelectTalentId(id)
	PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("noti_select_talent"), nil, function ()
		local callback = function(result)
			--- @param buffer UnifiedNetwork_ByteBuf
			local onBufferReading = function(buffer)

			end
			local onSuccess = function()
				if self.callbackSelectId ~= nil then
					self.callbackSelectId(id)
				end
				PopupMgr.HidePopup(UIPopupName.UISelectTalent)
			end
			local onFailed = function(logicCode)
				SmartPoolUtils.LogicCodeNotification(logicCode)
			end
			NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
		end
		NetworkUtils.Request(OpCode.ITEM_TALENT_SELECT, UnknownOutBound.CreateInstance(PutMethod.Long,
				self.heroInventoryId, PutMethod.Int, self.slotId, PutMethod.Int, id), callback)
	end)
end

function UISelectTalentView:HideListTalent()
	---@param v TalentSelectItemView
	for _, v in ipairs(self.listTalentSelectItemView:GetItems()) do
		v:ReturnPool()
	end
	self.listTalentSelectItemView:Clear()
end

function UISelectTalentView:OnClickRefresh()
	local listRefreshMoneyCost = List()
	--- @param talentConfig TalentConfig
	for i, talentConfig in ipairs(self.talentConfigList:GetItems()) do
		listRefreshMoneyCost:Add(talentConfig.refreshMoneyData:GetRewardInbound())
	end

	if InventoryUtils.IsEnoughMultiResourceRequirement(listRefreshMoneyCost) then
		PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("noti_refresh_talent"), nil, function ()
			local callback = function(result)
				---@type List
				local listId = List()
				--- @param buffer UnifiedNetwork_ByteBuf
				local onBufferReading = function(buffer)
					local size = buffer:GetByte()
					for i = 1, size do
						listId:Add(buffer:GetInt())
					end
				end
				local onSuccess = function()
					--- @param talentConfig TalentConfig
					for i, talentConfig in ipairs(self.talentConfigList:GetItems()) do
						talentConfig.refreshMoneyData:SubToInventory()
					end
					self.itemCollectionInBound:AddNumberRefreshTalent(self.heroInventoryId, self.slotId)
					self.listId = listId
					self:HideListTalent()
					self:ShowListTalent()
				end
				local onFailed = function(logicCode)
					SmartPoolUtils.LogicCodeNotification(logicCode)
				end
				NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
			end
			NetworkUtils.Request(OpCode.ITEM_TALENT_REFRESH, UnknownOutBound.CreateInstance(PutMethod.Long,
					self.heroInventoryId, PutMethod.Int, self.slotId), callback)
		end)
	end
end

--- @return void
function UISelectTalentView:Hide()
	UIBaseView.Hide(self)

	if self.moneyTableView ~= nil then
		self.moneyTableView:Hide()
		self.moneyTableView = nil
	end

	if self.moneyCostTableView ~= nil then
		self.moneyCostTableView:Hide()
		self.moneyCostTableView = nil
	end

	self:HideListTalent()
end

function UISelectTalentView:OnClickHelp()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("talent_info"))
end

function UISelectTalentView:_InitMoneyTableView()
	self.moneyTableView = ItemsTableView(self.config.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
	self.moneyCostTableView = ItemsTableView(self.config.moneyCostBarAnchor, nil, UIPoolType.MoneyCostBarView)
end
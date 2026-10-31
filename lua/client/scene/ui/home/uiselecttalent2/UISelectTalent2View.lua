require "lua.client.scene.ui.home.uiSelectTalent.UISelectTalentView"
--- @class UISelectTalent2View : UIBaseView
UISelectTalent2View = Class(UISelectTalent2View, UISelectTalentView)

--- @param model UISelectTalent2Model
function UISelectTalent2View:Ctor(model)
	UISelectTalentView.Ctor(self, model)
end

function UISelectTalent2View:ShowListTalent()
	self:HideListTalent()
	for _, v in ipairs(self.listId:GetItems()) do
		---@type TalentSelectItemView
		local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.Talent2SelectItemView, self.config.item)
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

function UISelectTalent2View:SelectTalentId(id)
	PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("noti_select_talent"), nil, function ()
		local callback = function(result)
			--- @param buffer UnifiedNetwork_ByteBuf
			local onBufferReading = function(buffer)

			end
			local onSuccess = function()
				if self.callbackSelectId ~= nil then
					self.callbackSelectId(id)
				end
				PopupMgr.HidePopup(UIPopupName.UISelectTalent2)
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

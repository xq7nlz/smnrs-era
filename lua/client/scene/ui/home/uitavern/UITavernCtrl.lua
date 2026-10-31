
--- @class UITavernCtrl : UIBaseCtrl
UITavernCtrl = Class(UITavernCtrl, UIBaseCtrl)

--- @return void
--- @param model UITavernModel
function UITavernCtrl:Ctor(model)
	UIBaseCtrl.Ctor(self, model)
	--- @type UITavernModel
	self.model = model
end

--- @return void
function UITavernCtrl:InitQuestDoing()
	---@param v TavernQuestInBound
	for _, v in pairs(zg.playerData:GetMethod(PlayerDataMethod.TAVERN).listTavernQuest:GetItems()) do
		if v.questState == TavernQuestState.DOING then
			---@type TavernQuestDataConfig
			local tavernQuestDataConfig = ResourceMgr.GetTavernQuestConfig():GetQuestDataByStar(v.star)
			if tavernQuestDataConfig.time - (zg.timeMgr:GetServerTime() - v.startTime) <= 0 then
				v.questState = TavernQuestState.DONE
				v.inventoryHeroList:Clear()
			end
		end
	end
end

--- @return void
function UITavernCtrl:GetNumberQuestCanRefresh()
	local number = 0
	---@param v TavernQuestInBound
	for _, v in pairs(zg.playerData:GetMethod(PlayerDataMethod.TAVERN).listTavernQuest:GetItems()) do
		if v.questState == TavernQuestState.WAITING and v.isLock == false then
			number = number + 1
		end
	end
	return number
end

--- @return void
function UITavernCtrl:SortQuest()
	zg.playerData:GetMethod(PlayerDataMethod.TAVERN).listTavernQuest:SortWithMethod(SortUtils.SortTavernQuest)
end
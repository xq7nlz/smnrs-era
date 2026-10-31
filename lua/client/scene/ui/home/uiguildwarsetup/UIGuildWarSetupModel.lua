
--- @class UIGuildWarSetupModel : UIBaseModel
UIGuildWarSetupModel = Class(UIGuildWarSetupModel, UIBaseModel)

--- @return void
function UIGuildWarSetupModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIGuildWarSetup, "ui_guild_war_setup")
	self.slotPerPage = 4

	--- @type number
	self.pageCount = nil
	--- @type number
	self.currentPage = 1
	--- @type List
	self.listParticipants = nil
end

--- @param listParticipants List
function UIGuildWarSetupModel:SetListParticipants(listParticipants)
	self.listParticipants = List()
	for i = 1, listParticipants:Count() do
		self.listParticipants:Add(listParticipants:Get(i))
	end
	self:UpdatePage()
end

function UIGuildWarSetupModel:UpdatePage()
	self.pageCount = math.max(math.ceil(self.listParticipants:Count() / self.slotPerPage), 1)
	self.currentPage = MathUtils.Clamp(self.currentPage, 1, self.pageCount)
end

--- @param guildWarPlayerInBound GuildWarPlayerInBound
function UIGuildWarSetupModel:SelectParticipantForGuildWar(guildWarPlayerInBound)
	for i = 1, self.listParticipants:Count() do
		--- @type GuildWarPlayerInBound
		local member = self.listParticipants:Get(i)
		if member.compactPlayerInfo.playerId == guildWarPlayerInBound.compactPlayerInfo.playerId then
			self.listParticipants:RemoveByIndex(i)
			self:UpdatePage()
			return
		end
	end
end

function UIGuildWarSetupModel:GetListMemberInPages()
	local dataItems = List()
	local minIndex, maxIndex = self:_GetRangeItem()
	for i = minIndex, maxIndex do
		dataItems:Add(self.listParticipants:Get(i))
	end
	return dataItems
end

--- @return number, number
function UIGuildWarSetupModel:_GetRangeItem()
	local minIndex = (self.currentPage - 1) * self.slotPerPage + 1
	local maxIndex = math.min(self.listParticipants:Count(), minIndex + self.slotPerPage - 1)
	return minIndex, maxIndex
end


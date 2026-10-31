require "lua.client.core.network.event.EventGuildQuestDonationBoardInBound"
--- @class GuildQuestData
GuildQuestData = Class(GuildQuestData)

--- @param buffer UnifiedNetwork_ByteBuf
function GuildQuestData:Ctor(buffer)
	if buffer then
		self:ReadBuffer(buffer)
	end
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildQuestData:ReadBuffer(buffer)
	self.isHaveEventTime = buffer:GetBool()
	--- @type Dictionary
	self.dictUserDonate = Dictionary()
	--- @type List
	self.listClaim = List()
	if self.isHaveEventTime == true then
		self.timeData = EventTimeData.CreateByBuffer(buffer)
		require "lua.client.core.network.playerData.guildQuest.EventTimePlan"
		self.eventTimePlan = EventTimePlan.CreateByBuffer(buffer)
	end
	self.isInEventTime = buffer:GetBool()
	--- @type List
	self.listClaim = List()
	if (self.isInEventTime) then
		local size = buffer:GetByte()
		for i = 1, size do
			self.listClaim:Add(buffer:GetInt())
		end
	end
	self.isInGuild = buffer:GetBool()
	if self.isInGuild == true then
		local size = buffer:GetShort()
		for _ = 1, size do
			local id = buffer:GetLong()
			require "lua.client.core.network.event.EventGuildQuestDonationBoardInBound"
			local eventGuildQuestDonationBoardInBound = EventGuildQuestDonationBoardInBound()
			eventGuildQuestDonationBoardInBound:ReadBuffer(buffer)
			self.dictUserDonate:Add(id, eventGuildQuestDonationBoardInBound)
		end
		self.dictMoneyDonate = GuildQuestData.GetMoneyDictByBuffer(buffer)
	end
end

---@return Dictionary
--- @param buffer UnifiedNetwork_ByteBuf
function GuildQuestData.GetMoneyDictByBuffer(buffer)
	local dict = Dictionary()
	local size = buffer:GetShort()
	for i = 1, size do
		dict:Add(buffer:GetShort(), buffer:GetInt())
	end
	return dict
end

--- @param moneyType MoneyType
function GuildQuestData:GetGuildDonate(moneyType)
	return self.dictMoneyDonate:Get(moneyType) or 0
end

--- @return void
--- @param moneyType MoneyType
--- @param quantity number
function GuildQuestData:AddDonate(moneyType, quantity)
	local total = quantity
	if self.dictMoneyDonate:IsContainKey(moneyType) then
		total = total + self.dictMoneyDonate:Get(moneyType)
	end
	self.dictMoneyDonate:Add(moneyType, total)

	---@type EventGuildQuestDonationBoardInBound
	local playerDonate = self.dictUserDonate:Get(PlayerSettingData.playerId)
	if playerDonate == nil then
		---@type BasicInfoInBound
		local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
		playerDonate = EventGuildQuestDonationBoardInBound(basicInfoInBound.name, basicInfoInBound.avatarData:GetMyPlayerAvatar(), basicInfoInBound.level)
		self.dictUserDonate:Add(PlayerSettingData.playerId, playerDonate)
	end
	playerDonate:AddDonate(moneyType, quantity)
end
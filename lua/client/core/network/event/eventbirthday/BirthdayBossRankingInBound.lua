--- @class BirthdayBossRankingInBound
BirthdayBossRankingInBound = Class(BirthdayBossRankingInBound)

function BirthdayBossRankingInBound:Ctor()
	--- @type List -- SingleArenaRanking
	self.listRanking = List()
	---@type number
	self.rankingOrder = -2
	---@type number
	self.score = 0
	---@type number
	self.power = 0
	---@type number
	self.factionId = 0
end

--- @return void
--- @param listHeroSelected List<number>
--- @param onSuccess function
--- Send list hero with element is selectionId to server
function BirthdayBossRankingInBound.GetLeaderBoard(onSuccess)
	----- @type EventKazetsuModel
	local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
	local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
	if isOpening == true then
		if eventModel.birthdayBossRankingInBound == nil then
			eventModel.birthdayBossRankingInBound = BirthdayBossRankingInBound()
		end
		local onReceived = function(result)
			--- @param buffer UnifiedNetwork_ByteBuf
			local onBufferReading = function(buffer)
				require "lua.client.core.network.event.eventBirthday.BirthdayBossRanking"
				--- @type List
				eventModel.birthdayBossRankingInBound.listRanking = NetworkUtils.GetListDataInBound(buffer,
						BirthdayBossRanking)
				if (eventModel.birthdayBossRankingInBound.listRanking:Count() == 0) then
					return
				end
				eventModel.birthdayBossRankingInBound.rankingOrder = buffer:GetInt()
				if (eventModel.birthdayBossRankingInBound.rankingOrder == nil) then
				else
				end
				eventModel.birthdayBossRankingInBound.score = buffer:GetLong()
				eventModel.birthdayBossRankingInBound.factionId = buffer:GetInt()

			end
			local onSuccess = function()
				onSuccess(eventModel)
			end
			NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
		end
		NetworkUtils.Request(OpCode.EVENT_BIRTHDAY_BOSS_RANKING_GET, nil, onReceived)
	end
end
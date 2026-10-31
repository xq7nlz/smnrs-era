--- @class BossChallengeRankingInBound
BossChallengeRankingInBound = Class(BossChallengeRankingInBound)

function BossChallengeRankingInBound:Ctor()
	--- @type List -- SingleArenaRanking
	self.listRanking = List()
	---@type number
	self.currentRanking = nil
	---@type number
	self.score = 0
end

--- @return void
--- @param listHeroSelected List<number>
--- @param onSuccess function
--- Send list hero with element is selectionId to server
function BossChallengeRankingInBound.GetLeaderBoard(onSuccess)
	----- @type EventBossChallengeModel
	local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BOSS_CHALLENGE)
	local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
	if isOpening == true then
		if eventModel.BossChallengeRankingInBound == nil then
			eventModel.BossChallengeRankingInBound = BossChallengeRankingInBound()
		end
		local onReceived = function(result)
			--- @param buffer UnifiedNetwork_ByteBuf
			local onBufferReading = function(buffer)
				require "lua.client.core.network.event.eventBossChallenge.BossChallengeRanking"
				--- @type List
				eventModel.BossChallengeRankingInBound.listRanking = NetworkUtils.GetListDataInBound(buffer,
						BossChallengeRanking)
				if eventModel.BossChallengeRankingInBound.listRanking:Count() > 0 then
					--- @param v SingleArenaRanking
					for k, v in pairs(eventModel.BossChallengeRankingInBound.listRanking:GetItems()) do
						if v.playerId == PlayerSettingData.playerId then
							eventModel.BossChallengeRankingInBound.currentRanking = k
							eventModel.BossChallengeRankingInBound.score = v.score
							break
						end
					end
				end

				if (eventModel.BossChallengeRankingInBound.listRanking:Count() == 0) then
					return
				end
			end
			local onSuccess = function()
				onSuccess(eventModel)
			end
			NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
		end
		NetworkUtils.Request(OpCode.EVENT_BOSS_CHALLENGE_GET_LEADER_BOARD, nil, onReceived)
	end
end
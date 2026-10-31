require "lua.client.core.network.event.eventNewHero.EventNewHeroBossRankingInBound"

--- @class EventNewHeroBossChallengeModel : EventPopupModel
EventNewHeroBossChallengeModel = Class(EventNewHeroBossChallengeModel, EventPopupModel)

function EventNewHeroBossChallengeModel:Ctor()
    --- @type number
    self.numberChallenge = 0
    --- @type number
    self.highestDamage = nil
    ---@type EventNewHeroBossRankingInBound
    self.eventRankingInBound = nil
    EventPopupModel.Ctor(self)

    --- @type EventChallengeRewardResultInBound
    self.eventChallengeRewardResultInBound = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventNewHeroBossChallengeModel:ReadInnerData(buffer)
    self.numberChallenge = buffer:GetInt()
    self.highestDamage = buffer:GetInt()
end

function EventNewHeroBossChallengeModel:HasNotification()
    return false
end

function EventNewHeroBossChallengeModel:RequestChallengeBoss(uiFormationTeamData, callback)
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        ---@type EventChallengeRewardResultInBound
        self.eventChallengeRewardResultInBound = EventChallengeRewardResultInBound(buffer)
        if self.highestDamage < self.eventChallengeRewardResultInBound.battleDamage then
            self.highestDamage = self.eventChallengeRewardResultInBound.battleDamage
        end
        self.numberChallenge = self.numberChallenge + 1
    end
    local callbackSuccess = function()
        if callback ~= nil then
            callback()
        end
        zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
    end
    NetworkUtils.RequestAndCallback(OpCode.EVENT_NEW_HERO_CHALLENGE, BattleFormationOutBound(uiFormationTeamData), callbackSuccess,
            SmartPoolUtils.LogicCodeNotification, onBufferReading)
end
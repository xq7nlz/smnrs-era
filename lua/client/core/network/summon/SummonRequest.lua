require "lua.client.core.network.summon.SummonResultInBound"
require "lua.client.core.network.summon.EventRateUpSummonResult"
--- @class SummonRequest
SummonRequest = Class(SummonRequest)

--- @return void
--- @param summonType SummonType
--- @param isSingleSummon boolean
--- @param isUseGem boolean
function SummonRequest.Summon(summonType, isSingleSummon, isUseGem, callbackSuccess)
    ---@type TutorialInBound
    local tutorialInBound = zg.playerData:GetMethod(PlayerDataMethod.TUTORIAL)
    local isSumTutorial = UIBaseView.IsActiveTutorial() == true -- or (summonType == SummonType.Heroic and tutorialInBound.summonStep < ResourceMgr.GetTutorialSummonConfig().maxStep )
    local onReceived = function(result)
        --- @type SummonResultInBound
        local summonResult
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            summonResult = SummonResultInBound(buffer)
        end

        local onSuccess = function()
            if isSumTutorial == true then
                tutorialInBound.summonStep = tutorialInBound.summonStep + 1
            end
            callbackSuccess(summonResult)
            if summonType == SummonType.Basic then
                RxMgr.mktTracking:Next(MktTrackingType.summonBasic, isSingleSummon and 1 or 10)
            elseif summonType == SummonType.Heroic then
                RxMgr.mktTracking:Next(MktTrackingType.summonPre, isSingleSummon and 1 or 10)
            end
        end

        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end


    if isSumTutorial == true then
        TrackingUtils.TrackingTutorial(FBProperties.STEP,TutorialStepID.TUTORIAL_SUMMON_10_CLICK)
        NetworkUtils.Request(OpCode.SUMMON_HERO, UnknownOutBound.CreateInstance(
                PutMethod.Byte, summonType, PutMethod.Bool, isSingleSummon, PutMethod.Bool, isUseGem), onReceived)
    else

       -- local idABTest = ClientConfigUtils.GetMySummonABFirebaseID() --hoangpl

        if summonType == SummonType.RateUp then
            NetworkUtils.Request(OpCode.EVENT_RATE_UP, UnknownOutBound.CreateInstance(
                    PutMethod.Bool, isSingleSummon, PutMethod.Bool, isUseGem), onReceived)
        elseif summonType == SummonType.NewHero then
            NetworkUtils.Request(OpCode.EVENT_NEW_HERO_SUMMON, UnknownOutBound.CreateInstance(
                    PutMethod.Bool, isSingleSummon, PutMethod.Bool, isUseGem), onReceived)
        elseif summonType == SummonType.NewHero2 then
            NetworkUtils.Request(OpCode.EVENT_NEW_HERO_RATE_UP_SUMMON, UnknownOutBound.CreateInstance(
                    PutMethod.Bool, isSingleSummon, PutMethod.Bool, isUseGem), onReceived)
        elseif summonType == SummonType.HeroRelease then
            NetworkUtils.Request(OpCode.EVENT_HERO_RELEASE_SUMMON, UnknownOutBound.CreateInstance(
                    PutMethod.Bool, isSingleSummon, PutMethod.Bool, isUseGem), onReceived)
        elseif summonType == SummonType.Kazetsu then
            NetworkUtils.Request(OpCode.EVENT_KAZETSU_SUMMON, UnknownOutBound.CreateInstance(
                    PutMethod.Bool, isSingleSummon, PutMethod.Bool, isUseGem), onReceived)
        else
            NetworkUtils.Request(OpCode.SUMMON_HERO, UnknownOutBound.CreateInstance(
                    PutMethod.Byte, summonType, PutMethod.Bool, isSingleSummon, PutMethod.Bool, isUseGem), onReceived)
        end
    end
end

--- @return void
--- @param summonType SummonType
function SummonRequest.SummonByWatchAds(summonType, callbackSuccess)
    local onReceived = function(result)
        --- @type SummonResultInBound
        local summonResult
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            summonResult = SummonResultInBound(buffer)
        end

        local onSuccess = function()
            callbackSuccess(summonResult)
            if summonType == SummonType.Basic then
                RxMgr.mktTracking:Next(MktTrackingType.summonBasic,1)
            elseif summonType == SummonType.Heroic then
                RxMgr.mktTracking:Next(MktTrackingType.summonPre, 1)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.SUMMON_HERO_BY_WATCH_ADS, UnknownOutBound.CreateInstance(
            PutMethod.Byte, summonType), onReceived)
end
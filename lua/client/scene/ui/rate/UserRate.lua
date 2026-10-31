require "lua.client.scene.ui.home.uiRate2.UIRate2View"
--- @class UserRate
UserRate = Class(UserRate)

UserRate.KEY_USER_RATE = "user_rate"

---@type number
UserRate.time = nil

--- @return void
function UserRate.LoadFromServer(callbackSuccess, callbackFailed)
    UserRate.time = zg.playerData.remoteConfig.rateTime
    UserRate.likeTime = zg.playerData.remoteConfig.likeTime
    if UserRate.time == nil then
        UserRate.time = 0
    end
    if UserRate.likeTime == nil then
        UserRate.likeTime = 0
    end
    if callbackSuccess ~= nil then
        callbackSuccess()
    end
end

--- @return void
function UserRate.SaveRateToServer(time)
    UserRate.time = time
    zg.playerData.remoteConfig.rateTime = time
    zg.playerData:SaveRemoteConfig()
end


--- @return void
function UserRate.SaveLikeToServer(time)
    UserRate.likeTime = time
    zg.playerData.remoteConfig.likeTime = time
    zg.playerData:SaveRemoteConfig()
end

--- @return void
function UserRate.CheckRate(forceShow)
    if UIBaseView.IsActiveTutorial() == false then
        local checkShowPopup = function()
            local canTrigger = zg.timeMgr:GetServerTime() - UserRate.likeTime > 84600
            if not canTrigger then
                canTrigger = zg.timeMgr:GetServerTime() - UserRate.time > 84600
            end
            if forceShow == true or (( UserRate.likeTime >= 0 or  UserRate.time >= 0) and canTrigger) then
                if zgUnity.googleReviewUtils ~= nil then
                    print(">>> RequestReview")
                    zgUnity.googleReviewUtils:RequestReview(function(isSuccess)
                        print(">>> Result RequestReview ", isSuccess)
                        --touchObject:Enable()
                        if isSuccess == false then
                            PopupMgr.ShowPopupDelay(1, UIPopupName.UIRate)
                        else
                            UserRate.SaveRateToServer(-1)
                        end
                    end)
                else
                    --local data = {}
                    --if UserRate.likeTime >= 0 then
                    --    data.tab = RatePopup.Like
                    --else
                    --    data.tab = RatePopup.Rate
                    --end
                    --PopupMgr.ShowPopupDelay(1, UIPopupName.UIRate2,data)
                    PopupMgr.ShowPopupDelay(1, UIPopupName.UIRate)
                end
                --end
            end
        end
        UserRate.LoadFromServer(checkShowPopup)
        checkShowPopup()
    end
end
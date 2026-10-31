require "lua.client.scene.ui.home.uiEvent.community.ButtonCommunity"

--- @class EventCommunityPopup
EventCommunityPopup = Class(EventCommunityPopup)

local TWITTER_URL = "https://twitter.com/SummonersEra"
local INSTAGRAM_URL = "https://www.instagram.com/summoners.era/"
local REDDIT_URL = "https://www.reddit.com/r/SummonersEra/"
local DISCORD_URL = "https://discord.gg/RbdQRbRFC4"

function EventCommunityPopup:Ctor(transform)
    --- @type EventCommunityPopupConfig
    self.config = UIBaseConfig(transform)
    --- @type Dictionary
    self.buttonCommunityDict = Dictionary()

    self:TryGetReward()
    self:InitButtonCommunity()
end

function EventCommunityPopup:TryGetReward()
    local eventCommunityInBound = zg.playerData:GetEvents().eventCommunityInBound
    --- @type RewardInBound
    self.reward = eventCommunityInBound:GetRewardConfig()
end

function EventCommunityPopup:InitButtonCommunity()
    --- @param eventTimeType EventTimeType
    local addButton = function(eventTimeType, isClone)
        isClone = isClone or false
        --- @type UnityEngine_GameObject
        local obj
        if isClone then
            obj = U_GameObject.Instantiate(self.config.prefabButton, self.config.anchor)
            obj.transform:SetAsLastSibling()
        else
            obj = self.config.prefabButton
        end
        --- @type ButtonCommunity
        local buttonCommunity = ButtonCommunity(obj.transform)
        buttonCommunity:SetText(self:GetButtonText(eventTimeType))
        buttonCommunity:SetIcon(ResourceLoadUtils.LoadEventTimeIcon(eventTimeType))
        buttonCommunity:AddOnClickListener(function()
            self:OnClickButton(eventTimeType)
        end)
        self.buttonCommunityDict:Add(eventTimeType, buttonCommunity)
    end
    addButton(EventTimeType.EVENT_FACEBOOK_COMMUNITY)
    addButton(EventTimeType.EVENT_TWITTER_COMMUNITY, true)
    addButton(EventTimeType.EVENT_INSTAGRAM_COMMUNITY, true)
    --addButton(EventTimeType.EVENT_REDDIT_COMMUNITY, true)
    addButton(EventTimeType.EVENT_DISCORD_COMMUNITY, true)
end

--- @param eventTimeType EventTimeType
function EventCommunityPopup:GetButtonText(eventTimeType)
    if eventTimeType == EventTimeType.EVENT_FACEBOOK_COMMUNITY then
        return "Facebook"
    elseif eventTimeType == EventTimeType.EVENT_DISCORD_COMMUNITY then
        return "Discord"
    elseif eventTimeType == EventTimeType.EVENT_INSTAGRAM_COMMUNITY then
        return "Instagram"
    elseif eventTimeType == EventTimeType.EVENT_REDDIT_COMMUNITY then
        return "Reddit"
    elseif eventTimeType == EventTimeType.EVENT_TWITTER_COMMUNITY then
        return "Twitter"
    end
end

function EventCommunityPopup:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("social_tab_title")
    self.config.textDesc.text = LanguageUtils.LocalizeCommon("social_tab_des")

    local rewardValue = string.format("%s %s", self.reward.number, LanguageUtils.LocalizeMoneyType(self.reward.id))
    self.config.textRewardDesc.text = string.format(LanguageUtils.LocalizeCommon("social_reward_desc"), rewardValue)
end

function EventCommunityPopup:OnShow()
    self.eventInBound = zg.playerData:GetEvents()

    --- @type RemoteConfigData
    self.remoteConfigData = zg.playerData.remoteConfig
    self:UpdateAllNotification()
    self:InitLocalization()
    self.config.gameObject:SetActive(true)
end

function EventCommunityPopup:StartUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.config.localizeClaim.text = string.format("%s\n%s",
                LanguageUtils.LocalizeCommon("all_received"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
        end
    end
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function EventCommunityPopup:SetTimeRefresh()
    local svTime = zg.timeMgr:GetServerTime()
    self.timeRefresh = TimeUtils.GetTimeStartDayFromSec(svTime) + TimeUtils.SecondADay - svTime
end

function EventCommunityPopup:RemoveUpdateTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
        self.updateTime = nil
    end
end

function EventCommunityPopup:OnHide()
    self:RemoveUpdateTime()
    self.config.gameObject:SetActive(false)
end

function EventCommunityPopup:OnClickButton(eventTimeType)
    self.eventInBound.eventCommunityInBound:SetCheckInCommunity(eventTimeType)
    self.eventInBound.eventCommunityInBound:RequestAchievedCommunity(eventTimeType)
    self:UpdateButtonCommunityNotify(eventTimeType)
    RxMgr.notificationEventPopup:Next(EventTimeType.COMMUNITY_TYPE)
    if eventTimeType == EventTimeType.EVENT_FACEBOOK_COMMUNITY then
        PopupUtils.OpenFanpage()
        NetworkUtils.Request(OpCode.FACEBOOK_FAN_PAGE_JOIN, nil, nil, false)
    elseif eventTimeType == EventTimeType.EVENT_TWITTER_COMMUNITY then
        U_Application.OpenURL(TWITTER_URL)
    elseif eventTimeType == EventTimeType.EVENT_INSTAGRAM_COMMUNITY then
        U_Application.OpenURL(INSTAGRAM_URL)
    elseif eventTimeType == EventTimeType.EVENT_REDDIT_COMMUNITY then
        U_Application.OpenURL(REDDIT_URL)
    elseif eventTimeType == EventTimeType.EVENT_DISCORD_COMMUNITY then
        U_Application.OpenURL(DISCORD_URL)
    end
    RxMgr.notificationRequestCommunityTotal:Next()
end

function EventCommunityPopup:GetNotification(eventTimeType)
    return self.eventInBound.eventCommunityInBound:HasCommunityNotification(eventTimeType)
end

function EventCommunityPopup:UpdateAllNotification()
    self:UpdateButtonCommunityNotify(EventTimeType.EVENT_FACEBOOK_COMMUNITY)
    self:UpdateButtonCommunityNotify(EventTimeType.EVENT_TWITTER_COMMUNITY)
    self:UpdateButtonCommunityNotify(EventTimeType.EVENT_INSTAGRAM_COMMUNITY)
    --self:UpdateButtonCommunityNotify(EventTimeType.EVENT_REDDIT_COMMUNITY)
    self:UpdateButtonCommunityNotify(EventTimeType.EVENT_DISCORD_COMMUNITY)
end

function EventCommunityPopup:UpdateButtonCommunityNotify(eventTimeType)
    --- @type ButtonCommunity
    local buttonCommunity = self.buttonCommunityDict:Get(eventTimeType)
    buttonCommunity:EnableNotify(self.eventInBound.eventCommunityInBound:HasCommunityNotification(eventTimeType))
end

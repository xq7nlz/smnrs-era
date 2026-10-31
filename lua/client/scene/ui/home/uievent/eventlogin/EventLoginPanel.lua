--- @class EventLoginPanel : PrefabView
EventLoginPanel = Class(EventLoginPanel, PrefabView)

function EventLoginPanel:Ctor()
    PrefabView.Ctor(self)
    self.dataConfig = nil
end

function EventLoginPanel:SetPrefabName()
    self.prefabName = 'popup_event_login'
end

--- @return void
--- @param transform UnityEngine_Transform
function EventLoginPanel:SetConfig(transform)
    --- @type EventLoginPanelConfig
    self.config = UIBaseConfig(transform)
    self:InitTileDay()
    self.config.buttonClaim.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickClaim()
    end)
end

function EventLoginPanel:InitTileDay()
    self.tileDayDict = Dictionary()
    for i = 1, self.config.tile6Days.childCount do
        local root = self.config.tile6Days:GetChild(i - 1)
        local dailyRewardItemView = DailyRewardItemView(root)
        self.tileDayDict:Add(i, dailyRewardItemView)
    end
    local tile7 = DailyRewardItemView(self.config.tileDay7)
    self.tileDayDict:Add(7, tile7)
end

function EventLoginPanel:InitLocalization()
    self.config.eventTittle.text = LanguageUtils.LocalizeCommon("event_login")
    self.config.eventDesc.text = LanguageUtils.LocalizeCommon("event_login_info")
    self.config.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
end

--- @param data {eventPopupLoginModel, onClaimSuccess}
function EventLoginPanel:OnShow(data)
    --- @type EventPopupLoginModel
    self.eventPopupLoginModel = data.eventPopupLoginModel
    self.onClaimSuccess = data.onClaimSuccess
    self:FillReward()
    if self.eventPopupLoginModel.hasData then
        self:UpdateView()
    end
end

function EventLoginPanel:UpdateView()
    local lastClaimDay = self.eventPopupLoginModel.lastDayUserClaim
    local isClaim = self.eventPopupLoginModel:IsClaim()
    local progress = string.format("<color=#%s>%s</color>/7", "554939", lastClaimDay)
    self.config.txtProgress.text = string.format("%s",
            string.format(LanguageUtils.LocalizeCommon("login_event_progress"), progress))
    self.config.buttonDisable:SetActive(isClaim == true)
    --- @param day number
    --- @param v DailyRewardItemView
    for day, v in pairs(self.tileDayDict:GetItems()) do
        v.iconView:ActiveTimeCountDown(false)
        if day <= lastClaimDay then
            v:SetClaim(true)
        elseif day == lastClaimDay + 1 and isClaim == false then
            v:SetClaim(false)
        else
            v:SetClaim()
        end
    end

    if isClaim == true then
        if self.eventPopupLoginModel.lastDayUserClaim < 7 then
            self:StartUpdateTime()
        else
            self.config.localizeClaim.text = LanguageUtils.LocalizeCommon("all_received")
        end
    end

    local claimAble = self.eventPopupLoginModel:HasNotification()
    self.config.notify:SetActive(claimAble)
    if claimAble then
        self.config.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
    end
end

function EventLoginPanel:StartUpdateTime()
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

function EventLoginPanel:SetTimeRefresh()
    local svTime = zg.timeMgr:GetServerTime()
    self.timeRefresh = TimeUtils.GetTimeStartDayFromSec(svTime) + TimeUtils.SecondADay - svTime
end

function EventLoginPanel:RemoveUpdateTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
        self.updateTime = nil
    end
end

function EventLoginPanel:FillReward()
    self.dataConfig = self.eventPopupLoginModel:GetConfig()
    --- @param v DailyRewardItemView
    for k, v in pairs(self.tileDayDict:GetItems()) do
        --- @type RewardInBound
        local rewardInBound = self.dataConfig:Get(k)
        v:SetIconData(rewardInBound:GetIconData(), k)
        v:RegisterShowInfo()
    end
end

function EventLoginPanel:OnHide()
    --- @param v DailyRewardItemView
    for _, v in pairs(self.tileDayDict:GetItems()) do
        v:ReturnPoolItem()
    end
    self:RemoveUpdateTime()
end

function EventLoginPanel:OnClickClaim()
    if self.eventPopupLoginModel:IsClaim() then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.LogicCodeNotification(LogicCode.EVENT_LOGIN_ALREADY_CLAIMED)
        return
    end
    local onReceived = function(result)
        local onSuccess = function()
            local day = (self.eventPopupLoginModel.lastDayUserClaim or 0) + 1 --hoangpl fix lastDayUserClaim = nil
            --- @type RewardInBound
            local reward = self.dataConfig:Get(day)
            self.eventPopupLoginModel.lastClaimTime = zg.timeMgr:GetServerTime()
            self.eventPopupLoginModel.lastDayUserClaim = day
            self:UpdateView()
            self:ShowAndAddReward(reward:GetIconData())
            RxMgr.notificationEventPopup:Next(self.eventPopupLoginModel:GetType())

            if self.onClaimSuccess then
                self.onClaimSuccess()
            end
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.EVENT_LOGIN_CLAIM, nil, onReceived)
end

--- @param iconData ItemIconData
function EventLoginPanel:ShowAndAddReward(iconData)
    SmartPoolUtils.ShowReward1Item(iconData)
    iconData:AddToInventory()
end
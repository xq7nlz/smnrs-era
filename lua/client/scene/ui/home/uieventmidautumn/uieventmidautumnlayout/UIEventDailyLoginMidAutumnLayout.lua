--- @class UIEventDailyLoginMidAutumnLayout : UIEventMidAutumnLayout
UIEventDailyLoginMidAutumnLayout = Class(UIEventDailyLoginMidAutumnLayout, UIEventMidAutumnLayout)

--- @param view UIEventView
function UIEventDailyLoginMidAutumnLayout:Ctor(view, midAutumnTab, anchor)
    --- @type EventMidAutumnModel
    self.eventMidAutumnModel = nil
    --- @type EventMidAutumnConfig
    self.eventConfig = nil
    --- @type UIEventMidAutumnDailyLoginConfig
    self.layoutConfig = nil

    UIEventMidAutumnLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventDailyLoginMidAutumnLayout:OnShow()
    self.eventMidAutumnModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MID_AUTUMN)
    self.eventConfig = self.eventMidAutumnModel:GetConfig()
    self.rewardDic = self.eventConfig:GetLoginConfig()
    UIEventMidAutumnLayout.OnShow(self)
    self:FillReward()
    self:UpdateView()
end

function UIEventDailyLoginMidAutumnLayout:OnHide()
    UIEventMidAutumnLayout.OnHide(self)
    for _, v in pairs(self.tileDayDict:GetItems()) do
        v:ReturnPoolItem()
    end
    self:RemoveUpdateTime()
end

function UIEventDailyLoginMidAutumnLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("popup_event_mid_autumn_login", self.anchor)
    UIEventMidAutumnLayout.InitLayoutConfig(self, inst)

    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitTileDay()
    self:InitButtons()
    self:InitLocalization()
    self:InitTimeView()
end

function UIEventDailyLoginMidAutumnLayout:InitTimeView()
    self.timeCountDownContainer = SmartPool.Instance:SpawnTransform(AssetType.UIPool, UIPoolType.TimeCountDown)
    self.textTimeCountDown = self.timeCountDownContainer:GetComponentInChildren(ComponentName.UnityEngine_UI_Text)
    self.textTimeCountDown:GetComponent(ComponentName.UnityEngine_RectTransform).sizeDelta = U_Vector2(120, 50)
    self.timeCountDownContainer:SetParent(self.layoutConfig.transform)
    self.timeCountDownContainer.transform.localPosition = U_Vector3(0, 0, 0)
    self.timeCountDownContainer.transform.localScale = U_Vector3(1.2, 1.2, 1.2)
end

function UIEventDailyLoginMidAutumnLayout:FillReward()
    --- @param v DailyRewardMultiItemView

    local loginConfig
    for k, v in pairs(self.tileDayDict:GetItems()) do
        --- @type List -- RewardInBound
        local rewardInBoundList = self.rewardDic:Get(k)
        v:FillData(rewardInBoundList, k)
    end
end
function UIEventDailyLoginMidAutumnLayout:InitTileDay()
    self.tileDayDict = Dictionary()
    local count6day = 6
    for i = 1, count6day do
        local dailyRewardItemView = DailyRewardMultiItemView()
        dailyRewardItemView:SetParent(self.layoutConfig.tile6Days)
        self.tileDayDict:Add(i, dailyRewardItemView)
    end
    local tile7 = DailyRewardMultiItemView()
    tile7:SetParent(self.layoutConfig.tileDay7)
    tile7.config.item.transform.localScale = U_Vector3(1/1.8, 1/1.8, 1/1.8)
    tile7.config.dailyCheckinTag2.gameObject:SetActive(true)
    tile7.config.dailyCheckinTag.gameObject:SetActive(false)
    self.tileDayDict:Add(7, tile7)
end

function UIEventDailyLoginMidAutumnLayout:InitButtons()
    self.layoutConfig.buttonClaim.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickClaim()
    end)
end

function UIEventDailyLoginMidAutumnLayout:InitLocalization()
    self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
    self.layoutConfig.eventTittle.text = LanguageUtils.LocalizeCommon("event_midautumn_checkin")
end

function UIEventDailyLoginMidAutumnLayout:OnClickClaim()
    if self.eventMidAutumnModel:IsClaim() then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.LogicCodeNotification(LogicCode.EVENT_LOGIN_ALREADY_CLAIMED)
        return
    end
    local onReceived = function(result)
        local onSuccess = function()
            local day = self.eventMidAutumnModel.lastClaimLoginDay + 1
            --- @type RewardInBound
            local rewardInBoundList = self.rewardDic:Get(day)
            self.eventMidAutumnModel.lastClaimLoginTime = zg.timeMgr:GetServerTime()
            self.eventMidAutumnModel.lastClaimLoginDay = day
            self:UpdateView()
            self:ShowAndAddReward(rewardInBoundList)

            self.view:CheckAllNotificationTab()
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.EVENT_MID_AUTUMN_LOGIN_CLAIM, nil, onReceived)
end

--- @param rewardList List
function UIEventDailyLoginMidAutumnLayout:ShowAndAddReward(rewardList)
    local touchObject = TouchUtils.Spawn("MidAutumn.Login")
    local callbackDelay = function()
        touchObject:Enable()
    end
    local iconList = List()
    for i = 1, rewardList:Count() do
        rewardList:Get(i):GetIconData():AddToInventory()
        iconList:Add(rewardList:Get(i):GetIconData())
    end
    PopupMgr.ShowPopupDelay(0, UIPopupName.UIPopupReward, { ["resourceList"] = iconList, ["activeEffectBlackSmith"] = true }, nil, callbackDelay)
end

function UIEventDailyLoginMidAutumnLayout:UpdateView()
    local lastClaimDay = self.eventMidAutumnModel.lastClaimLoginDay
    local isClaim = self.eventMidAutumnModel:IsClaim()
    local progress = string.format("<color=#%s>%s</color>/7", "554939", lastClaimDay)
    self.layoutConfig.txtProgress.text = string.format("%s",
            string.format(LanguageUtils.LocalizeCommon("login_event_progress"), progress))
    self.layoutConfig.buttonDisable:SetActive(isClaim == true)
    --- @param day number
    --- @param v DailyRewardMultiItemView
    for day, v in pairs(self.tileDayDict:GetItems()) do
        if day <= lastClaimDay then
            v:SetClaim(true)
        elseif day == lastClaimDay + 1 and isClaim == false then
            v:SetClaim(false)
        else
            v:SetClaim()
        end
    end

    if isClaim == true then
        if self.eventMidAutumnModel.lastClaimLoginDay < 7 then
            self:StartUpdateTime()
            local nextReward = self.tileDayDict:Get(self.eventMidAutumnModel.lastClaimLoginDay + 1).config.transform
            self.timeCountDownContainer.gameObject:SetActive(true)
            self.timeCountDownContainer:SetParent(nextReward)
            self.timeCountDownContainer.transform.localPosition = U_Vector3(0, 0, 0)
        else
            self.timeCountDownContainer.gameObject:SetActive(false)
            self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("all_received")
        end
    end

    local claimAble = self.view:_GetEventNotification(self.midAutumnTab)
    self.layoutConfig.notify:SetActive(claimAble)
    if claimAble then
        self.timeCountDownContainer.gameObject:SetActive(true)
        self.timeCountDownContainer.gameObject:SetActive(not claimAble)
        self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
    else
    end
    self.view:UpdateNotificationByTab(self.midAutumnTab)
end
function UIEventDailyLoginMidAutumnLayout:StartUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        local timeText = UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh))
        self.layoutConfig.localizeClaim.text = string.format("%s\n%s",
                LanguageUtils.LocalizeCommon("all_received"),
                timeText)
        self.textTimeCountDown.text = timeText
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
        end
    end
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventDailyLoginMidAutumnLayout:SetTimeRefresh()
    local svTime = zg.timeMgr:GetServerTime()
    self.timeRefresh = TimeUtils.GetTimeStartDayFromSec(svTime) + TimeUtils.SecondADay - svTime
end

function UIEventDailyLoginMidAutumnLayout:RemoveUpdateTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
        self.updateTime = nil
    end
end


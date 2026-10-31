--- @class UIKazetsuLoginLayout : UIEventKazetsuLayout
UIKazetsuLoginLayout = Class(UIKazetsuLoginLayout, UIEventKazetsuLayout)

--- @param view UIEventView
function UIKazetsuLoginLayout:Ctor(view, NewServerWeekTab, anchor)
    --- @type EventKazetsuModel
    self.eventKazetsuModel = nil
    --- @type EventKazetsuConfig
    self.eventConfig = nil
    --- @type UINewServerDailyRewardConfig
    self.layoutConfig = nil
    UIEventKazetsuLayout.Ctor(self, view, NewServerWeekTab, anchor)
end

function UIKazetsuLoginLayout:OnShow()
    self.eventKazetsuModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
    self.eventConfig = self.eventKazetsuModel:GetConfig()
    self.rewardDic = self.eventConfig:GetLoginConfig()
    UIEventKazetsuLayout.OnShow(self)
    self:FillReward()
    self:UpdateView()
end

function UIKazetsuLoginLayout:OnHide()
    UIEventKazetsuLayout.OnHide(self)
    for _, v in pairs(self.tileDayDict:GetItems()) do
        v:ReturnPoolItem()
    end
    self:RemoveUpdateTime()
end

function UIKazetsuLoginLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("kazetsu_login_layout", self.anchor)
    UIEventKazetsuLayout.InitLayoutConfig(self, inst)

    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitTileDay()
    self:InitButtons()
    self:InitLocalization()
    self:InitTimeView()
end

function UIKazetsuLoginLayout:InitTimeView()
    self.timeCountDownContainer = SmartPool.Instance:SpawnTransform(AssetType.UIPool, UIPoolType.TimeCountDown)
    self.timeCountDownContainer.gameObject:SetActive(false)
    self.textTimeCountDown = self.timeCountDownContainer:GetComponentInChildren(ComponentName.UnityEngine_UI_Text)
    self.textTimeCountDown:GetComponent(ComponentName.UnityEngine_RectTransform).sizeDelta = U_Vector2(120, 50)
    self.timeCountDownContainer:SetParent(self.layoutConfig.transform)
    self.timeCountDownContainer.transform.localPosition = U_Vector3(0, 0, 0)
    self.timeCountDownContainer.transform.localScale = U_Vector3(1.2, 1.2, 1.2)
end

function UIKazetsuLoginLayout:FillReward()
    --- @param v DailyRewardMultiItemView

    local loginConfig
    for k, v in pairs(self.tileDayDict:GetItems()) do
        --- @type List -- RewardInBound
        local rewardInBoundList = self.rewardDic:Get(k)
        v:FillData(rewardInBoundList, k)
    end
end
function UIKazetsuLoginLayout:InitTileDay()
    self.tileDayDict = Dictionary()
    local count6day = 6
    for i = 1, count6day do
        local dailyRewardItemView = KazetsuDailyRewardItemView()
        dailyRewardItemView:SetParent(self.layoutConfig.tile6Days)
        self.tileDayDict:Add(i, dailyRewardItemView)
    end
    local tile7 = KazetsuLastDailyRewardItemView()
    tile7:SetParent(self.layoutConfig.tileDay7)
    tile7.config.item.transform.localScale = U_Vector3(1/1.8, 1/1.8, 1/1.8)
    tile7.config.bgItemReward.gameObject:SetActive(true)
    tile7.config.dailyCheckinTag2.gameObject:SetActive(true)
    tile7.config.dailyCheckinTag.gameObject:SetActive(false)
    self.tileDayDict:Add(7, tile7)
end

function UIKazetsuLoginLayout:InitButtons()
    self.layoutConfig.buttonClaim.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickClaim()
    end)
end

function UIKazetsuLoginLayout:InitLocalization()
    self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
    self.layoutConfig.eventTittle.text = LanguageUtils.LocalizeCommon("event_kazetsu_check_in")
end

function UIKazetsuLoginLayout:OnClickClaim()
    if self.eventKazetsuModel:IsClaim() then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.LogicCodeNotification(LogicCode.EVENT_LOGIN_ALREADY_CLAIMED)
        return
    end
    local onReceived = function(result)
        local onSuccess = function()
            local day = self.eventKazetsuModel.eventLoginData.lastClaimDay + 1
            --- @type RewardInBound
            local rewardInBoundList = self.rewardDic:Get(day)
            self.eventKazetsuModel.eventLoginData.lastClaimLoginTime = zg.timeMgr:GetServerTime()
            self.eventKazetsuModel.eventLoginData.lastClaimDay = day
            self:UpdateView()
            self:ShowAndAddReward(rewardInBoundList)

            self.view:CheckAllNotificationTab()
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.EVENT_KAZETSU_DAILY_LOGIN_CLAIM, nil, onReceived)
end

--- @param rewardList List
function UIKazetsuLoginLayout:ShowAndAddReward(rewardList)
    local touchObject = TouchUtils.Spawn("Kazetsu.Login")
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

function UIKazetsuLoginLayout:UpdateView()
    local lastClaimDay = self.eventKazetsuModel.eventLoginData.lastClaimDay
    local isClaim = self.eventKazetsuModel:IsClaim()
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
        if self.eventKazetsuModel.eventLoginData.lastClaimDay < 7 then
            self:StartUpdateTime()
            local nextReward = self.tileDayDict:Get(self.eventKazetsuModel.eventLoginData.lastClaimDay + 1).config.transform
            self.timeCountDownContainer.gameObject:SetActive(true)
            self.timeCountDownContainer:SetParent(nextReward)
            self.timeCountDownContainer.transform.localPosition = U_Vector3(0, -150, 0)
        else
            self.timeCountDownContainer.gameObject:SetActive(false)
            self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("all_received")
        end
    end

    local claimAble = self.view:_GetEventNotification(self.eventKazetsuTab)
    self.layoutConfig.notify:SetActive(claimAble)
    if claimAble then
        self.timeCountDownContainer.gameObject:SetActive(false)
        self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
    else
    end
    self.view:UpdateNotificationByTab(self.NewServerWeekTab)
end
function UIKazetsuLoginLayout:StartUpdateTime()
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

function UIKazetsuLoginLayout:SetTimeRefresh()
    local svTime = zg.timeMgr:GetServerTime()
    self.timeRefresh = TimeUtils.GetTimeStartDayFromSec(svTime) + TimeUtils.SecondADay - svTime
end

function UIKazetsuLoginLayout:RemoveUpdateTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
        self:UpdateView()
        self.updateTime = nil
    end
end


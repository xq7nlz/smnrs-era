--- @class UIEventAiryuuCheckinLayout : UIEventAiryuuLayout
UIEventAiryuuCheckinLayout = Class(UIEventAiryuuCheckinLayout, UIEventAiryuuLayout)

--- @param view UIEventAiryuuView
--- @param anchor UnityEngine_RectTransform
function UIEventAiryuuCheckinLayout:Ctor(view, tab, anchor)
    --- @type UIEventAiryuuView
    self.view = view
    ---@type UIEventAiryuuCheckinLayoutConfig
    self.layoutConfig = nil
    ---@type Dictionary
    self.loginRewardDict = Dictionary()
    --- @type EventAiryuuConfig
    self.eventConfig = nil
    self.uiScroll = nil
    UIEventAiryuuLayout.Ctor(self, view, tab, anchor)
end

function UIEventAiryuuCheckinLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_airyuu_checkin_layout", self.anchor)
    UIEventAiryuuLayout.InitLayoutConfig(self, inst)
    self:InitUpdateTime()
    --self:ValidateCheckinDay()
    self:InitIScroll()
    self:InitLocalization()
    self:InitButtonListener()
end

function UIEventAiryuuCheckinLayout:InitLocalization()
    UIEventAiryuuLayout.InitLocalization(self)
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("airyuu_check_in")
end

function UIEventAiryuuCheckinLayout:ValidateCheckinDay()
    if not self.eventModel then
        self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_AIRYUU)
    end
    self.eventCurrentDay = self.eventModel:GetLoginData().eventCurrentDay
    self.lastClaimLoginTime = self.eventModel:GetLoginData().lastClaimLoginTime
    self.lastClaimDay = self.eventModel:GetLoginData().lastClaimDay
    self.isClaimed = self.eventModel:GetLoginData():IsClaimed()
    self.isFreeClaim = self.eventModel:GetLoginData():IsFreeClaimNew()
    self.loginRewardDict = self.eventModel.config:GetLoginRewardConfig()
end

function UIEventAiryuuCheckinLayout:InitIScroll()
    ---@param obj EventAiryuuCheckinItem
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        local loginRewardDict = self.loginRewardDict:Get(dataIndex)
        obj:SetItemData(dataIndex, loginRewardDict)

        if self.eventCurrentDay <= 0 then
            obj:IsLock(true)
            obj:IsClaimed()
        elseif self.lastClaimDay == self.eventCurrentDay then
            if dataIndex <= self.lastClaimDay then
                obj:IsClaimed(true)
            else
                obj:IsLock(true)
                obj:IsClaimed()
            end
        else
            if dataIndex <= self.lastClaimDay then
                obj:IsClaimed(true)
            elseif dataIndex == self.lastClaimDay + 1 then
                if not self.isClaimed and self.isFreeClaim then
                    obj:IsFreeButton(true)
                    obj:IsLock()
                    obj:IsClaimed()
                    obj.onClickCheckin = function()
                        self:OpCode(obj)
                    end
                elseif not self.isClaimed and not self.isFreeClaim then
                    obj:IsFreeButton(false)
                    obj:IsLock()
                    obj:IsClaimed()
                    obj.onClickCheckin = function()
                        local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, loginRewardDict.moneyData.moneyType, loginRewardDict.moneyData.moneyValue))
                        if canExchange then
                            local yesCallback = function()
                                self:OpCode(obj, loginRewardDict.moneyData)
                            end
                            PopupUtils.ShowPopupNotificationYesNo(string.format("%s: %d %s",
                                    LanguageUtils.LocalizeCommon("confirm_use_resource"), loginRewardDict.moneyData.moneyValue,
                                    UIUtils.SetColorString(UIUtils.green_dark,
                                            LanguageUtils.GetStringResourceName(ResourceType.Money, loginRewardDict.moneyData.moneyType)))
                            , nil, yesCallback)
                        end
                    end
                end
            else
                obj:IsLock(true)
                obj:IsClaimed()
            end
        end
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.EventAiryuuCheckinItem, onCreateItem)
end

---@param obj EventAiryuuCheckinItem
function UIEventAiryuuCheckinLayout:OpCode(obj, moneyData)
    local pos = self.layoutConfig.content.position
    local rewardList = List()
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        rewardList = NetworkUtils.GetRewardInBoundList(buffer)
    end

    local onSuccess = function()
        if moneyData ~= nil then
            InventoryUtils.Sub(ResourceType.Money, moneyData.moneyType, moneyData.moneyValue)
        end
        obj:HasNoti()
        obj:IsClaimed(true)
        if self.isFreeClaim then
            self.isFreeClaim = false
        end
        self.lastClaimDay = self.lastClaimDay + 1
        self.uiScroll:Resize(self.loginRewardDict:Count())
        self.layoutConfig.content.position = pos
        if rewardList ~= nil or rewardList:Count() > 0 then
            PopupUtils.ClaimAndShowRewardList(rewardList)
        end
    end

    local onFailed = function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("failed"))
    end
    NetworkUtils.RequestAndCallback(OpCode.EVENT_HERO_AIRYUU_LOGIN, nil, onSuccess, onFailed, onBufferReading)
end

function UIEventAiryuuCheckinLayout:ReturnPoolScroll()
    self.loginRewardDict:Clear()
    self.uiScroll:Hide()
end

function UIEventAiryuuCheckinLayout:OnPurchaseSuccess()
    self.view:CheckAllNotificationTab()
end

function UIEventAiryuuCheckinLayout:InitButtonListener()
    self.layoutConfig.backButton.onClick:AddListener(function()
        self:CloseLayout()
    end)
end

function UIEventAiryuuCheckinLayout:OnShow()
    UIEventAiryuuLayout.OnShow(self)
    self.anchor.gameObject:SetActive(true)
    self:SetNextDayTime(function()
        self:OnEventTimeEnded()
    end)
    self:ValidateCheckinDay()
    if self.loginRewardDict:Count() > self.eventModel.config:GetLoginDayCount() then
        self.uiScroll:Resize(self.eventModel.config:GetLoginDayCount())
    end
    self.uiScroll:Resize(self.loginRewardDict:Count())
end

function UIEventAiryuuCheckinLayout:SetUpLayout()
    UIEventAiryuuLayout.SetUpLayout(self)
end

function UIEventAiryuuCheckinLayout:OnHide()
    self:ReturnPoolScroll()
    self:RemoveUpdateTime()
    UIEventAiryuuLayout.OnHide(self)
end

function UIEventAiryuuCheckinLayout:GetEventEndTime()
    return self.eventModel.timeData.endTime
end

--- @param onEventTimeEnded function
function UIEventAiryuuCheckinLayout:SetNextDayTime(onEventTimeEnded)
    self.onEventTimeEnded = onEventTimeEnded
    self:StartUpdateTime()
end

--- @param eventTimeType EventTimeType
function UIEventAiryuuCheckinLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventAiryuuCheckinLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventAiryuuCheckinLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventAiryuuCheckinLayout:SetTimeRefresh()
    --self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

function UIEventAiryuuCheckinLayout:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.layoutConfig.textEventTime.text = string.format("%s %s", LanguageUtils.LocalizeCommon("time_next_day"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end

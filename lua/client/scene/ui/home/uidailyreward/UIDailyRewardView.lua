--- @class UIDailyRewardView : UIBaseView
UIDailyRewardView = Class(UIDailyRewardView, UIBaseView)

--- @return void
--- @param model UIDailyRewardModel
function UIDailyRewardView:Ctor(model)
    ---@type UIDailyRewardConfig
    self.config = nil
    ---@type UILoopScroll
    self.uiScroll = nil
    ---@type UnityEngine_UI_Text
    self.textTimeCountDown = nil

    UIBaseView.Ctor(self, model)
    --- @type UIDailyRewardModel
    self.model = model
    --- @type PlayerDailyDataInBound
    self.server = nil
end

--- @return void
function UIDailyRewardView:OnReadyCreate()
    ---@type UIDailyRewardConfig
    self.config = UIBaseConfig(self.uiTransform)
    self:InitButtonListener()
    self:InitScrollView()
    self:InitUpdateTime()
end

function UIDailyRewardView:InitButtonListener()
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.backGround.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonClaim.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickClaim()
    end)
end

function UIDailyRewardView:InitScrollView()
    --SCROLL
    --- @param obj DailyRewardItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        local currentIndex = index + 1
        local rewardInbound = self.server.listItem:Get(currentIndex)
        obj:SetIconData(rewardInbound:GetIconData(), currentIndex)
        obj.iconView:ActiveTimeCountDown(false)
        if currentIndex <= self.server.claimDay then
            obj:SetClaim(true)
            obj.iconView:ActiveTimeCountDown(false)
            --obj:ActiveMaskSelect(true , U_Vector2(195, 230))
        else
            if currentIndex <= self.server.loginDay then
                obj:SetClaim(false)
            else
                obj:SetClaim()
                if currentIndex == self.server.loginDay + 1 then
                    ---@type UnityEngine_RectTransform
                    local effect = obj.iconView:ActiveTimeCountDown(true)
                    if effect ~= nil then
                        self.textTimeCountDown = effect:GetComponentInChildren(ComponentName.UnityEngine_UI_Text)
                    else
                        self.textTimeCountDown = nil
                    end
                end
            end
        end
    end
    --- @param obj DailyRewardItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        onUpdateItem(obj, index)
        obj:RegisterShowInfo()
    end
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.DailyRewardItemView, onCreateItem, onUpdateItem)
    self.uiScroll:SetUpMotion(MotionConfig(nil, nil, nil, 0.02, 2))
end

--- @return void
function UIDailyRewardView:InitLocalization()
    self.config.localizeDailyReward.text = LanguageUtils.LocalizeCommon("daily_reward")
    self.config.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
    self.config.textReceived.text = LanguageUtils.LocalizeCommon("all_received")
    self.config.textTapToClose.gameObject:SetActive(false)
end

--- @return void
function UIDailyRewardView:OnReadyShow()
    self.server = zg.playerData:GetMethod(PlayerDataMethod.DAILY_REWARD)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.uiScroll:Resize(self.server.listItem:Count())
    --if self.server.loginDay > self.server.listItem:Count() - 18 then      -- 2 dong cuoi cung
    --	self.uiScroll:ScrollToCell(self.server.listItem:Count() - 18, 10000)
    --else
    --end
    self.uiScroll:RefillCells(math.max(self.server.loginDay - self.server.loginDay % 6 - 6, 0))
    self:UpdateUI()
    self.uiScroll:PlayMotion()
end

--- @return void
function UIDailyRewardView:Hide()
    UIBaseView.Hide(self)
    self.uiScroll:Hide()
end

--- @return void
function UIDailyRewardView:UpdateUI()
    if self.server:CanClaim() then
        self.config.iconNotiCheckin:SetActive(true)
        self.config.localizeClaim.gameObject:SetActive(true)
        self.config.textReceived.gameObject:SetActive(false)
        self.config.textTimeReceived.gameObject:SetActive(false)
        UIUtils.SetInteractableButton(self.config.buttonClaim, true)
    else
        self.config.iconNotiCheckin:SetActive(false)
        self.config.localizeClaim.gameObject:SetActive(false)
        self.config.textReceived.gameObject:SetActive(true)
        self.config.textTimeReceived.gameObject:SetActive(true)
        UIUtils.AlignText(self.config.textTimeReceived)
        UIUtils.SetInteractableButton(self.config.buttonClaim, false)
    end
    if self.server.loginDay == self.server.listItem:Count() then
        self.config.textCheckinProgress.text = UIUtils.SetColorString(UIUtils.color1,
                string.format(LanguageUtils.LocalizeCommon("checkin_progress"),
                        string.format("%s/%s", self.server.loginDay, self.server.listItem:Count()))

        )
    else
        self.config.textCheckinProgress.text = UIUtils.SetColorString(UIUtils.color1,
                string.format(LanguageUtils.LocalizeCommon("checkin_progress"),
                        UIUtils.SetColorString(UIUtils.brown, self.server.loginDay) ..
                                "/" .. self.server.listItem:Count()
                )
        )
    end
end

function UIDailyRewardView:InitUpdateTime()
    self:InitUpdateTimeNextDay(function(timeNextDay, isSetTime)
        self.config.textTimeReceived.text = timeNextDay
        if self.textTimeCountDown ~= nil then
            self.textTimeCountDown.text = timeNextDay
            if isSetTime == true then
                UIUtils.AlignText(self.textTimeCountDown)
            end
        end
    end)
end

--- @return void
function UIDailyRewardView:OnClickClaim()
    if self.server:CanClaim() then
        local rewardList = List()
        for i = self.server.claimDay + 1, self.server.loginDay do
            local rewardInBound = self.server.listItem:Get(i)
            rewardList:Add(rewardInBound)
        end
        self.server.claimDay = self.server.loginDay
        RxMgr.notificationUiDailyReward:Next()
        self:OnReadyHide()
        -- REQUEST
        local callback = function(result)
            local onSuccess = function()
                --XDebug.Log("Claim success")
                -----@param v ItemIconData
                --for _, v in pairs(rewardList:GetItems()) do
                --    v:AddToInventory()
                --end

                PopupUtils.ClaimAndShowRewardList(rewardList)
                TrackingUtils.AddAppsflyerEvent(AFInAppEvents.DAILY_QUEST, AFInAppEvents.COUNT, tostring(1))
            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
                XDebug.Log("Claim failed")
                PlayerDataRequest.Request(PlayerDataMethod.DAILY_REWARD)
                PopupMgr.HidePopup(UIPopupName.UIDailyReward)
            end
            NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
        end
        NetworkUtils.Request(OpCode.DAILY_REWARD_CLAIM, nil, callback)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("can_not_claim_reward"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

--- @return void
function UIDailyRewardView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    self:OnReadyHide()
end

function UIDailyRewardView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end
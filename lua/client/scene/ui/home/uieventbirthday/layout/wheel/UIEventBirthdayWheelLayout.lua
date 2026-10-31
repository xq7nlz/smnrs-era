require "lua.client.scene.ui.home.uiEventBirthday.layout.dailyCheckin.DailyRewardEventBirthdayPageView"
require "lua.client.scene.ui.home.uiWheelOfFate.SpinWheel"

--- @class UIEventBirthdayWheelLayout : UIEventBirthdayLayout
UIEventBirthdayWheelLayout = Class(UIEventBirthdayWheelLayout, UIEventBirthdayLayout)

function UIEventBirthdayWheelLayout:Ctor(view, xmasTab, anchor)
    --- @type EventBirthdayModel
    self.eventModel = nil
    --- @type EventBirthdayConfig
    self.eventConfig = nil
    --- @type UIBirthdayWheelLayoutConfig
    self.layoutConfig = nil
    ---@type SpinWheel
    self.spinWheel = nil
    ---@type function
    self.coroutineSpin = nil
    ---@type EventBirthdayWheelConfig
    self.wheelConfig = nil
    --- @type MoneyBarView
    self.casinoBarView = nil
    ---@type List | RootIconView
    self.listIconView = List()
    ---@type List | RootIconView
    self.listReward = List()
    UIEventBirthdayLayout.Ctor(self, view, xmasTab, anchor)
end

function UIEventBirthdayWheelLayout:OnShow()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.view.eventTimeType)
    self.eventConfig = self.eventModel:GetConfig()
    UIEventBirthdayLayout.OnShow(self)
    self:UpdateView()
    self:UpdateReward()
end

function UIEventBirthdayWheelLayout:OnHide()
    UIEventBirthdayLayout.OnHide(self)

    self.spinWheel:Hide()
    self.casinoBarView:ReturnPool()
    self.casinoBarView = nil
    self:ReturnPoolItem()
    self:ReturnPoolItemReward()
end

function UIEventBirthdayWheelLayout:ReturnPoolItem()
    for i, v in pairs(self.listIconView:GetItems()) do
        v:ReturnPool()
    end
    self.listIconView:Clear()
end

function UIEventBirthdayWheelLayout:ReturnPoolItemReward()
    for i, v in pairs(self.listReward:GetItems()) do
        v:ReturnPool()
    end
    self.listReward:Clear()
end

function UIEventBirthdayWheelLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("birthday_wheel", self.anchor)
    UIEventBirthdayLayout.InitLayoutConfig(self, inst)
    self.spinWheel = SpinWheel(self.layoutConfig.wheel)
    self:InitButtons()
    self:InitLocalization()
end

function UIEventBirthdayWheelLayout:InitButtons()
    self.layoutConfig.buttonSpin.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSpin()
    end)
    self.layoutConfig.buttonStop.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickStop()
    end)
end

function UIEventBirthdayWheelLayout:InitLocalization()
    self.layoutConfig.textSpin.text = LanguageUtils.LocalizeCommon("roll")
    self.layoutConfig.textStop.text = LanguageUtils.LocalizeCommon("stop")
end

function UIEventBirthdayWheelLayout:OnClickStop()
    local listRewards = self:GetListRoundRewards()

    local callbackConfirm = function()
        local callback = function(result)
            local onSuccess = function()
                PopupUtils.ClaimAndShowRewardList(listRewards)
                self.eventModel.roundRewards:Clear()
                self:UpdateView()
                self:UpdateReward()
            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
        end
        --NetworkUtils.Request(OpCode.EVENT_BIRTHDAY_WHEEL_CLAIM, nil, callback) -- bo tinh nang
    end
    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("confirm_stop_spin"), nil, callbackConfirm, nil,
            RewardInBound.GetItemIconDataList(listRewards))
end

function UIEventBirthdayWheelLayout:OnClickSpin()
    local touchObject
    local moneyType = self.wheelConfig.moneyType
    local moneyValue = self.wheelConfig.moneyValue
    if self.spinWheel.isSpinning == false then
        if InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, moneyType, moneyValue)) then
            zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
            ---@type SpinCasinoInBound
            local spinCasinoInBound
            local index = ClientMathUtils.randomHelper:RandomMinMax(1, 9)
            local resetItems = false
            local callbackSpin = function()
                Coroutine.start(function()
                    coroutine.waitforseconds(0.5)
                    touchObject:Enable()
                end)
                if self.eventModel.roundRewards:Count() == self.eventConfig:GetListWheelConfig():Count() then
                    ---@type List
                    local listItem = List()
                    for i = 1, self.eventModel.roundRewards:Count() do
                        ---@type EventBirthdayWheelConfig
                        local wheelConfig = self.eventConfig:GetListWheelConfig():Get(i)
                        ---@type RewardInBound
                        local reward = wheelConfig.listReward:Get(self.eventModel.roundRewards:Get(i))
                        listItem:Add(reward)
                    end
                    PopupUtils.ClaimAndShowRewardList(listItem)
                    self.eventModel.roundRewards:Clear()
                end
                self:UpdateView()
                self:UpdateReward()

                self:PlayDiceEndFx()

            end
            self.spinWheel.indexTarget = index - 1
            self.spinWheel.isValidate = false
            self.spinWheel.timeDefault = 5
            self.spinWheel:Rotate(callbackSpin)
            self.layoutConfig.fxSpin:Play()
            self.layoutConfig.fxSpinBg:Play()

            local callback = function(result)
                touchObject = TouchUtils.Spawn("UIEventBirthdayWheelLayout:OnClickSpin")
                local indexReward
                --- @param buffer UnifiedNetwork_ByteBuf
                local onBufferReading = function(buffer)
                    indexReward = buffer:GetInt()
                end

                local onSuccess = function()
                    InventoryUtils.Sub(ResourceType.Money, moneyType, moneyValue)
                    ---@type RewardInBound
                    local reward = self.wheelConfig.listReward:Get(indexReward)
                    if reward ~= nil and reward.type ~= nil then
                        self.eventModel.roundRewards:Add(self.eventModel.roundRewards:Count() + 1, indexReward)
                    else
                        self.eventModel.roundRewards:Clear()
                    end
                    self.spinWheel.indexTarget = indexReward - 1
                    self.spinWheel.isValidate = true

                    zg.audioMgr:PlaySfxUi(SfxUiType.CASINO_SPIN)
                    zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
                end
                local onFailed = function(logicCode)
                    SmartPoolUtils.LogicCodeNotification(logicCode)
                    self:OnRequestFailed()
                end
                NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
            end
            -- NetworkUtils.Request(OpCode.EVENT_BIRTHDAY_WHEEL_SPIN, nil, callback) --old
        end
    end
end

function UIEventBirthdayWheelLayout:UpdateReward()
    self:ReturnPoolItemReward()
    for i = 1, self.eventModel.roundRewards:Count() do
        ---@type EventBirthdayWheelConfig
        local wheelConfig = self.eventConfig:GetListWheelConfig():Get(i)
        ---@type RewardInBound
        local reward = wheelConfig.listReward:Get(self.eventModel.roundRewards:Get(i))
        if reward ~= nil then
            ---@type IconView
            local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.layoutConfig.reward)
            iconView:SetIconData(reward:GetIconData())
            iconView:RegisterShowInfo()
            self.listReward:Add(iconView)
        else
            XDebug.Log("Nil reward index" .. i)
        end
    end
end

function UIEventBirthdayWheelLayout:PlayDiceEndFx()
    self.layoutConfig.fxSpin:Stop()
    self.layoutConfig.fxSpinBg:Stop()

    if self.layoutConfig.reward.childCount > 0 then
        --- @type UnityEngine_RectTransform
        local rect = self.layoutConfig.fxItem:GetComponent(ComponentName.UnityEngine_RectTransform)
        local pos = self.layoutConfig.reward.anchoredPosition3D
        pos.y = pos.y - (150 * (self.layoutConfig.reward.childCount - 1) * 0.75)
        rect.anchoredPosition3D = pos
        self.layoutConfig.fxItem:Play()

        zg.audioMgr:PlaySfxUi(SfxUiType.DICE_END)
    end
end

function UIEventBirthdayWheelLayout:UpdateView()
    self.view:UpdateNotificationByTab(self.eventBirthdayTab)
    self.wheelConfig = self.eventConfig:GetListWheelConfig():Get(self.eventModel.roundRewards:Count() + 1)
    self.layoutConfig.buttonStop.gameObject:SetActive(self.eventModel.roundRewards:Count() > 0)
    self.spinWheel:SetNumberItem(self.wheelConfig.listReward:Count())
    self.spinWheel.transform.eulerAngles = U_Vector3(0, 0, 0)
    if self.casinoBarView == nil then
        self.casinoBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.money)
    end
    self.layoutConfig.iconMoney.sprite = ResourceLoadUtils.LoadMoneyIcon(self.wheelConfig.moneyType)
    self.layoutConfig.textNumberMoney.text = tostring(self.wheelConfig.moneyValue)
    self.casinoBarView:SetIconData(self.wheelConfig.moneyType)

    self:ReturnPoolItem()
    local angle = 360 / self.wheelConfig.listReward:Count()
    ---@type UnityEngine_RectTransform
    local spin = self.layoutConfig.wheel:GetChild(self.eventModel.roundRewards:Count()):GetChild(0)
    for i = 1, spin.childCount do
        if i <= self.wheelConfig.listReward:Count() then
            ---@type UnityEngine_RectTransform
            local child = spin:GetChild(i - 1)
            ---@type BirthdayWheelItemConfig
            local config = UIBaseConfig(child)
            child.localEulerAngles = U_Vector3(child.localEulerAngles.x, child.localEulerAngles.y, -(i - 1) * angle)
            ---@type RewardInBound
            local reward = self.wheelConfig.listReward:Get(i)
            if reward.type ~= nil then
                ---@type IconView
                local iconView = SmartPoolUtils.GetIconViewByIconData(reward:GetIconData(), config.item)
                iconView:RegisterShowInfo()
                self.listIconView:Add(iconView)
                config.stop.transform.parent.gameObject:SetActive(false)
            else
                config.stop.transform.parent.gameObject:SetActive(true)
                config.stop.text = LanguageUtils.LocalizeCommon("stop")
            end
        else

        end
    end

    for i = 1, self.layoutConfig.arrow.childCount do
        self.layoutConfig.arrow:GetChild(i - 1).gameObject:SetActive(false)
    end
    self.layoutConfig.arrow:GetChild(self.eventModel.roundRewards:Count()).gameObject:SetActive(true)

    for i = 1, self.layoutConfig.wheel.childCount do
        self.layoutConfig.wheel:GetChild(i - 1).gameObject:SetActive(false)
    end
    self.layoutConfig.wheel:GetChild(self.eventModel.roundRewards:Count()).gameObject:SetActive(true)
end

--- @return List --- RewardInBound
function UIEventBirthdayWheelLayout:GetListRoundRewards()
    ---@type List
    local listItem = List()
    local roundRewards = self.eventModel.roundRewards
    for i = 1, roundRewards:Count() do
        --- @type EventBirthdayWheelConfig
        local wheelConfig = self.eventConfig:GetListWheelConfig():Get(i)
        --- @type RewardInBound
        local reward = wheelConfig.listReward:Get(roundRewards:Get(i))
        listItem:Add(reward)
    end
    return listItem
end
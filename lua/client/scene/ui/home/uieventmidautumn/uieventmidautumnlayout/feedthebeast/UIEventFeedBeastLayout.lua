require "lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.feedTheBeast.BeastAutumn"

--- @class UIEventFeedBeastLayout : UIEventMidAutumnLayout
UIEventFeedBeastLayout = Class(UIEventFeedBeastLayout, UIEventMidAutumnLayout)

--- @param view UIEventView
function UIEventFeedBeastLayout:Ctor(view, midAutumnTab, anchor)
    --- @type UIEventFeedBeastLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestFeedBeast = nil
    --- @type Dictionary
    self.beastAutumnDict = Dictionary()
    --- @type BeastAutumn
    self.beastAutumn = nil
    --- @type List
    self.listFeedReward = nil
    ---@type boolean
    self.skipAnimation = false
    UIEventMidAutumnLayout.Ctor(self, view, midAutumnTab, anchor)
end

function UIEventFeedBeastLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("feed_beast_view", self.anchor)
    UIEventMidAutumnLayout.InitLayoutConfig(self, inst)

    self:InitButtonListener()
    self:InitLocalization()
    self:InitScroll()
end

function UIEventFeedBeastLayout:InitScroll()
    --- @param obj FeedBeastLevelRewardItem
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type QuestElementConfig
        local questElementConfig = self.listQuestFeedBeast:Get(dataIndex)
        local level = questElementConfig:GetMainRequirementTarget()
        obj:SetData(level, questElementConfig:GetListReward())
        obj:SetClaim(level <= self.eventMidAutumnModel.feedBeastLevel)
        obj:Highlight(dataIndex == self:_GetCurrentRewardMilestone())
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollReward, UIPoolType.FeedBeastLevelRewardItem, onCreateItem)
end

function UIEventFeedBeastLayout:InitLocalization()
    UIEventMidAutumnLayout.InitLocalization(self)
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("event_feed_beast_name")
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("event_feed_beast_desc")
    self.layoutConfig.textFeed.text = LanguageUtils.LocalizeCommon("feed")
    self.layoutConfig.textReward.text = LanguageUtils.LocalizeCommon("reward")
end

function UIEventFeedBeastLayout:InitButtonListener()
    self.layoutConfig.buttonFeed.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonFeed()
    end)
    self.layoutConfig.buttonRewardPool.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRewardPool()
    end)
    self.layoutConfig.toggle.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCheckbox()
    end)
end

function UIEventFeedBeastLayout:OnShow()
    UIEventMidAutumnLayout.OnShow(self)
    self:ShowData()
end

function UIEventFeedBeastLayout:GetModelConfig()
    UIEventMidAutumnLayout.GetModelConfig(self)
    self.eventFeedBeastConfig = self.eventConfig:GetEventFeedBeastConfig()
    self.listQuestFeedBeast = self.eventFeedBeastConfig:GetListQuestConfig()
end

function UIEventFeedBeastLayout:ShowData()
    self:ShowLevel()

    self.layoutConfig.textProgressExp.text = "0/" .. self.eventFeedBeastConfig.feedRewardInBound.number
    self.layoutConfig.progressFull:SetActive(false)
    self:ShowMoneyValue()
    local feedAvailable = self.eventMidAutumnModel:IsFeedBeastHasNotification()
    self.layoutConfig.coverFeed:SetActive(feedAvailable == false)
    self.layoutConfig.notification:SetActive(feedAvailable)
    self.layoutConfig.progressBar.fillAmount = 0

    self.uiScroll:Resize(self.listQuestFeedBeast:Count(), math.max(0, self:_GetCurrentRewardMilestone() - 5))

    self:ShowBeastModel()
end

function UIEventFeedBeastLayout:ShowLevel()
    self.layoutConfig.textLevel.text = string.format("%s %s", LanguageUtils.LocalizeCommon("level"),
            self.eventMidAutumnModel.feedBeastLevel)
end

function UIEventFeedBeastLayout:ShowMoneyValue()
    local moonCake = InventoryUtils.Get(self.eventFeedBeastConfig.feedRewardInBound.type, self.eventFeedBeastConfig.feedRewardInBound.id)
    local color = UIUtils.green_light
    local valueRequire = self.eventFeedBeastConfig.feedRewardInBound.number
    if moonCake < self.eventFeedBeastConfig.feedRewardInBound.number then
        color = UIUtils.red_light
    end
    self.layoutConfig.textMoneyValue.text = string.format("%s/%s", UIUtils.SetColorString(color, moonCake), valueRequire)
end

function UIEventFeedBeastLayout:_GetCurrentRewardMilestone()
    for i = 1, self.listQuestFeedBeast:Count() do
        --- @type QuestElementConfig
        local questElementConfig = self.listQuestFeedBeast:Get(i)
        local level = questElementConfig:GetMainRequirementTarget()
        if level > self.eventMidAutumnModel.feedBeastLevel then
            return i
        end
    end
    return self.listQuestFeedBeast:Count()
end

function UIEventFeedBeastLayout:OnClickCheckbox()
    self.skipAnimation = not self.skipAnimation
    self:InitTickEnableAnimation()
end

function UIEventFeedBeastLayout:InitTickEnableAnimation()
    self.layoutConfig.iconTick.gameObject:SetActive(self.skipAnimation)
end

function UIEventFeedBeastLayout:OnClickButtonFeed()
    if self.eventMidAutumnModel:IsFeedBeastHasNotification(true) == false then
        return
    end
    local onFeedSuccess = function()
        self.eventMidAutumnModel:ListQuestFeedBeastAddCurrentNumber(self.eventFeedBeastConfig.feedRewardInBound.number)
        self.view:UpdateNotificationByTab(MidAutumnTab.QUEST)
        local touchObject = TouchUtils.Spawn("feed_beast")
        local progressDuration = 0
        if not self.skipAnimation then
            progressDuration = 1
            self.beastAutumn:PlayEat()
        end
        self.layoutConfig.progressBar:DOFillAmount(1, progressDuration):
        OnComplete(function()
            self.layoutConfig.progressFull:SetActive(true)
            zg.audioMgr:PlaySfxUi(SfxUiType.HERO_LEVEL_UP)
            self.layoutConfig.fxLevelUp:Play()
            Coroutine.start(function()
                coroutine.waitforseconds(0.1)
                self:ShowData()
                coroutine.waitforseconds(0.1)
                touchObject:Enable()
                self:ClaimListFeedReward()
            end)
        end):
        OnUpdate(function()
            local value = math.floor(self.layoutConfig.progressBar.fillAmount * self.eventFeedBeastConfig.feedRewardInBound.number)
            self.layoutConfig.textProgressExp.text = string.format("%s/%s", value, self.eventFeedBeastConfig.feedRewardInBound.number)
        end)
    end
    self:RequestFeedBeast(onFeedSuccess)
end

function UIEventFeedBeastLayout:OnClickRewardPool()
    local data = {}
    --- @type List
    data.listInstanceReward = self.eventFeedBeastConfig:GetListInstanceReward()
    --- @type List
    data.listRandomReward = self.eventFeedBeastConfig:GetListRandomReward()
    PopupMgr.ShowPopup(UIPopupName.UIRewardLevelUpBeast, data)
end

function UIEventFeedBeastLayout:OnHide()
    UIEventMidAutumnLayout.OnHide(self)
    self:HideBeast()
    self.uiScroll:Hide()
end

function UIEventFeedBeastLayout:RequestFeedBeast(onSuccess)
    local onFeedFailed = function(logicCode)
        if logicCode == LogicCode.EVENT_MID_AUTUMN_FEED_PROCESS_FULL then
            self:_RequestClaimReward(function()
                self:ClaimListFeedReward(function()
                    self:RequestFeedBeast(onSuccess)
                end)
            end)
        else
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
    end
    local onReceived = function(result)
        NetworkUtils.ExecuteResult(result, nil, function()
            self.eventMidAutumnModel.feedBeastLevel = self.eventMidAutumnModel.feedBeastLevel + 1
            InventoryUtils.SubSingleRewardInBound(self.eventFeedBeastConfig.feedRewardInBound)
            self.view:UpdateNotificationByTab(self.midAutumnTab)
            self:_RequestClaimReward(onSuccess)
        end, onFeedFailed)
    end
    NetworkUtils.Request(OpCode.EVENT_MID_AUTUMN_FEED_BEAST, UnknownOutBound.CreateInstance(PutMethod.Bool, false), onReceived)
end

function UIEventFeedBeastLayout:_RequestClaimReward(onSuccess)
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            self.listFeedReward = NetworkUtils.GetRewardInBoundList(buffer)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.EVENT_MID_AUTUMN_BEAST_REWARD_CLAIM, nil, onReceived)
end

function UIEventFeedBeastLayout:ShowBeastModel()
    local beastForm = math.floor(self.eventMidAutumnModel.feedBeastLevel / 10) + 1
    beastForm = MathUtils.Clamp(beastForm, 1, 4)
    if self.beastAutumn ~= nil and self.beastAutumn == beastForm then
        return
    end
    local isTransform = self.beastAutumn ~= nil and beastForm > self.beastAutumn.level
    self:HideBeast()
    local callback = function()
        self.beastAutumn:PlayIdle()
        if isTransform then
            zg.audioMgr:PlaySfxUi(SfxUiType.HERO_EVOLVE)
            self.layoutConfig.fxEvolve:Play()
        end
    end
    self:_GetBeastModelByLevel(beastForm, callback)
end

function UIEventFeedBeastLayout:_GetBeastModelByLevel(beastLevel, callback)
    local isTransform = false
    if self.beastAutumn ~= nil then
        isTransform = beastLevel > self.beastAutumn.level
    end
    --- @type BeastAutumn
    local beastAutumn = self.beastAutumnDict:Get(beastLevel)
    if beastAutumn == nil then
        PrefabLoadUtils.InstantiateAsync("beast_" .. beastLevel,
                function(clone)
                    beastAutumn = BeastAutumn(clone.transform, beastLevel)
                    beastAutumn:PlayIdle()
                    self.beastAutumnDict:Add(beastLevel, beastAutumn)
                    self.beastAutumn = beastAutumn
                    callback(isTransform)
                end, self.layoutConfig.beastAnchor)
    else
        self.beastAutumn = beastAutumn
        self.beastAutumn:SetActive(true)
        callback(isTransform)
    end
end

function UIEventFeedBeastLayout:HideBeast()
    if self.beastAutumn ~= nil then
        self.beastAutumn:SetActive(false)
        self.beastAutumn = nil
    end
end

function UIEventFeedBeastLayout:ClaimListFeedReward(callback)
    if self.listFeedReward ~= nil then
        PopupUtils.ClaimAndShowRewardList(self.listFeedReward, callback)
        self.listFeedReward = nil
    end
end
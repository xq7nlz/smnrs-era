require "lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.feedTheBeast.BeastAutumn"

--- @class UIEventChristmasFeedLayout : UIEventChristmasLayout
UIEventChristmasFeedLayout = Class(UIEventChristmasFeedLayout, UIEventChristmasLayout)

--- @param view UIEventView
function UIEventChristmasFeedLayout:Ctor(view, tab, anchor)
    --- @type UIEventChristmasFeedLayoutConfig
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
    --- @type List
    self.listFeedRewardAll = nil
    ---@type boolean
    self.skipAnimation = false
    ---@type WorldSpaceHeroView
    self.worldSpaceHeroView = nil
    ---@type number
    self.heroId = 50011
    UIEventChristmasLayout.Ctor(self, view, tab, anchor)
end

function UIEventChristmasFeedLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("christmas_feed_view", self.anchor)
    UIEventChristmasLayout.InitLayoutConfig(self, inst)

    self.layoutConfig.factionIcon.sprite = ResourceLoadUtils.LoadFactionIcon(ClientConfigUtils.GetFactionIdByHeroId(self.heroId))
    self:InitButtonListener()
    self:InitLocalization()
    self:InitScroll()
end

function UIEventChristmasFeedLayout:InitScroll()
    --- @param obj FeedBeastLevelRewardItem
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type QuestElementConfig
        local questElementConfig = self.listQuestFeedBeast:Get(dataIndex)
        local level = questElementConfig:GetMainRequirementTarget()
        obj:SetData(level, questElementConfig:GetListReward())
        obj:SetClaim(level <= self.eventModel.feedBeastLevel)
        obj:Highlight(dataIndex == self:_GetCurrentRewardMilestone())
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollReward, UIPoolType.FeedBeastLevelRewardItem, onCreateItem)
end

function UIEventChristmasFeedLayout:InitLocalization()
    UIEventChristmasLayout.InitLocalization(self)
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("event_christmas_feed_name")
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("event_christmas_feed_desc")
    self.layoutConfig.textFeed.text = LanguageUtils.LocalizeCommon("blessing")
    self.layoutConfig.textFeedAll.text = LanguageUtils.LocalizeCommon("blessing_all")
    self.layoutConfig.textReward.text = LanguageUtils.LocalizeCommon("reward")
    self.layoutConfig.heroNameTxt.text = LanguageUtils.LocalizeNameHero(self.heroId)
end

function UIEventChristmasFeedLayout:InitButtonListener()
    self.layoutConfig.buttonFeed.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonFeed()
    end)
    self.layoutConfig.buttonFeedAll.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonFeedAll()
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

function UIEventChristmasFeedLayout:OnShow()
    UIEventChristmasLayout.OnShow(self)
    self:ShowData()
end

function UIEventChristmasFeedLayout:GetModelConfig()
    UIEventChristmasLayout.GetModelConfig(self)
    self.eventFeedBeastConfig = self.eventConfig:GetEventFeedBeastConfig()
    self.listQuestFeedBeast = self.eventFeedBeastConfig:GetListQuestConfig()
end

function UIEventChristmasFeedLayout:ShowData()
    self:ShowLevel()
    self.layoutConfig.textProgressExp.text = "0/" .. self.eventFeedBeastConfig.feedRewardInBound.number
    self.layoutConfig.progressFull:SetActive(false)
    self:ShowMoneyValue()
    local feedAvailable = self.eventModel:IsFeedBeastHasNotification()
    self.layoutConfig.coverFeed:SetActive(feedAvailable == false)
    self.layoutConfig.coverFeedAll.gameObject:SetActive(feedAvailable == false)
    self.layoutConfig.notification:SetActive(feedAvailable)
    self.layoutConfig.notificationAll.gameObject:SetActive(feedAvailable)
    self.layoutConfig.progressBar.fillAmount = 0

    self.uiScroll:Resize(self.listQuestFeedBeast:Count(), math.max(0, self:_GetCurrentRewardMilestone() - 5))

    --self:ShowBeastModel()
    self:ShowBossView()
end

function UIEventChristmasFeedLayout:ShowBossView()
    if self.worldSpaceHeroView == nil then
        ---@type UnityEngine_Transform
        local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
        self.worldSpaceHeroView = WorldSpaceHeroView(trans)
        local renderTexture = U_RenderTexture(1000, 1000, 24, U_RenderTextureFormat.ARGB32)
        self.layoutConfig.iconHero.texture = renderTexture
        self.worldSpaceHeroView:Init(renderTexture)
    end
    local heroResource = HeroResource()
    local heroItem = Dictionary()
    heroItem:Add(7, 50011001)
    heroResource:SetData(-1, 50011, 7, 1, heroItem)
    self.worldSpaceHeroView:ShowHero(heroResource)
    self.worldSpaceHeroView.config.transform.position = U_Vector3(0, 100, 0)
    self.worldSpaceHeroView.config.bg:SetActive(false)
end

function UIEventChristmasFeedLayout:ShowLevel()
    self.layoutConfig.textLevel.text = string.format("%s %s", LanguageUtils.LocalizeCommon("level"),
            self.eventModel.feedBeastLevel)
end

function UIEventChristmasFeedLayout:ShowMoneyValue()
    local moonCake = InventoryUtils.Get(self.eventFeedBeastConfig.feedRewardInBound.type, self.eventFeedBeastConfig.feedRewardInBound.id)
    local color = UIUtils.green_light
    local valueRequire = self.eventFeedBeastConfig.feedRewardInBound.number
    if moonCake < self.eventFeedBeastConfig.feedRewardInBound.number then
        color = UIUtils.red_light
    end
    self.layoutConfig.textMoneyValue.text = string.format("%s/%s", UIUtils.SetColorString(color, moonCake), valueRequire)
end

function UIEventChristmasFeedLayout:_GetCurrentRewardMilestone()
    for i = 1, self.listQuestFeedBeast:Count() do
        --- @type QuestElementConfig
        local questElementConfig = self.listQuestFeedBeast:Get(i)
        local level = questElementConfig:GetMainRequirementTarget()
        if level > self.eventModel.feedBeastLevel then
            return i
        end
    end
    return self.listQuestFeedBeast:Count()
end

function UIEventChristmasFeedLayout:OnClickCheckbox()
    self.skipAnimation = not self.skipAnimation
    self:InitTickEnableAnimation()
end

function UIEventChristmasFeedLayout:InitTickEnableAnimation()
    self.layoutConfig.iconTick.gameObject:SetActive(self.skipAnimation)
end

function UIEventChristmasFeedLayout:OnClickButtonFeed()
    if self.eventModel:IsFeedBeastHasNotification(true) == false then
        return
    end
    local onFeedSuccess = function()
        self.eventModel:ListQuestFeedBeastAddCurrentNumber(self.eventFeedBeastConfig.feedRewardInBound.number)
        self.view:UpdateNotificationByTab(ChristmasTab.QUEST)
        local touchObject = TouchUtils.Spawn("feed_beast")
        local progressDuration = 0
        if not self.skipAnimation then
            progressDuration = 1
            --self.beastAutumn:PlayEat()
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

function UIEventChristmasFeedLayout:OnClickButtonFeedAll()
    if self.eventModel:IsFeedBeastHasNotification(true) == false then
        return
    end
    local onFeedSuccess = function(currentValue)
        self.eventModel:ListQuestFeedBeastAddCurrentNumber(currentValue)
        self.view:UpdateNotificationByTab(ChristmasTab.QUEST)
        zg.audioMgr:PlaySfxUi(SfxUiType.HERO_LEVEL_UP)
        self.layoutConfig.fxLevelUp:Play()
        Coroutine.start(function()
            coroutine.waitforseconds(0.1)
            self:ShowData()
            coroutine.waitforseconds(0.1)
            self:ClaimListRewardFeedAll()
        end)
    end
    self:RequestFeedBeastAll(onFeedSuccess)
end

function UIEventChristmasFeedLayout:RequestFeedBeastAll(onSuccess)
    local onFeedFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
    end
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            self.listFeedRewardAll = NetworkUtils.GetRewardInBoundList(buffer)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, function()
            local valueMoney = InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_CHRISTMAS_CANDY_BAR)
            local valueSub = valueMoney - (valueMoney % 100)
            self.eventModel.feedBeastLevel = self.eventModel.feedBeastLevel + math.floor(valueSub / 100)
            InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_CHRISTMAS_CANDY_BAR, valueSub)
            self.view:UpdateNotificationByTab(self.tab)
            if onSuccess ~= nil then
                onSuccess(valueSub)
            end
        end, onFeedFailed)
    end
    NetworkUtils.Request(OpCode.EVENT_CHRISTMAS_FEED_ALL_BEAST, nil, onReceived)
end

function UIEventChristmasFeedLayout:OnClickRewardPool()
    local data = {}
    --- @type List
    data.listInstanceReward = self.eventFeedBeastConfig:GetListInstanceReward()
    --- @type List
    data.listRandomReward = self.eventFeedBeastConfig:GetListRandomReward()
    PopupMgr.ShowPopup(UIPopupName.UIRewardLevelUpBeast, data)
end

function UIEventChristmasFeedLayout:OnHide()
    UIEventChristmasLayout.OnHide(self)
    self:HideBeast()
    self.uiScroll:Hide()
end

function UIEventChristmasFeedLayout:RequestFeedBeast(onSuccess)
    local onFeedFailed = function(logicCode)
        if logicCode == LogicCode.EVENT_CHRISTMAS_FEED_PROCESS_FULL then
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
            self.eventModel.feedBeastLevel = self.eventModel.feedBeastLevel + 1
            InventoryUtils.SubSingleRewardInBound(self.eventFeedBeastConfig.feedRewardInBound)
            self.view:UpdateNotificationByTab(self.tab)
            self:_RequestClaimReward(onSuccess)
        end, onFeedFailed)
    end
    NetworkUtils.Request(OpCode.EVENT_CHRISTMAS_FEED_BEAST, UnknownOutBound.CreateInstance(PutMethod.Bool, false), onReceived)
end

function UIEventChristmasFeedLayout:_RequestClaimReward(onSuccess)
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            self.listFeedReward = NetworkUtils.GetRewardInBoundList(buffer)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.EVENT_CHRISTMAS_BEAST_REWARD_CLAIM, nil, onReceived)
end

function UIEventChristmasFeedLayout:ShowBeastModel()
    local beastForm = math.floor(self.eventModel.feedBeastLevel / 10) + 1
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

function UIEventChristmasFeedLayout:_GetBeastModelByLevel(beastLevel, callback)
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

function UIEventChristmasFeedLayout:HideBeast()
    if self.beastAutumn ~= nil then
        self.beastAutumn:SetActive(false)
        self.beastAutumn = nil
    end

    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end
end

function UIEventChristmasFeedLayout:ClaimListFeedReward(callback)
    if self.listFeedReward ~= nil then
        PopupUtils.ClaimAndShowRewardList(self.listFeedReward, callback)
        self.listFeedReward = nil
    end
end

function UIEventChristmasFeedLayout:ClaimListRewardFeedAll(callback)
    if self.listFeedRewardAll ~= nil then
        PopupUtils.ClaimAndShowRewardList(self.listFeedRewardAll, callback)
        self.listFeedRewardAll = nil
    end
end
require "lua.client.core.network.event.eventPieceAdventure.PieceAdventureOpenCardData"

--- @class UIEventMayDayBingoLayout : UIEventMayDayLayout
UIEventMayDayBingoLayout = Class(UIEventMayDayBingoLayout, UIEventMayDayLayout)

local countCard = 25

--- @param view UIEventMayDayView
--- @param tab number
--- @param anchor UnityEngine_RectTransform
function UIEventMayDayBingoLayout:Ctor(view, tab, anchor)
    ---@type UIEventMayDayBingoConfig
    self.layoutConfig = nil
    ---@type List
    self.listCard = List()
    ---@type List
    self.listRewardExtra = List()
    ---@type List
    self.listMoneyBar = List()
    UIEventMayDayLayout.Ctor(self, view, tab, anchor)
end

function UIEventMayDayBingoLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("may_day_bingo", self.anchor)
    UIEventMayDayLayout.InitLayoutConfig(self, inst)
    self:InitButtonListener()
    self:InitLocalization()
    self:InitScroll()
end

function UIEventMayDayBingoLayout:InitLocalization()
    UIEventMayDayLayout.InitLocalization(self)
    self.layoutConfig.textReward.text = LanguageUtils.LocalizeCommon("bingo_reward_list")
    self.layoutConfig.textExtraReward.text = LanguageUtils.LocalizeCommon("extra_bingo_reward_text")
    self.layoutConfig.bingoTitle.text = LanguageUtils.LocalizeCommon("bingo_title")
    self.layoutConfig.textChanceReset.text = LanguageUtils.LocalizeCommon("text_chance_reset")
    self.layoutConfig.textTutorial.text = LanguageUtils.LocalizeCommon("bingo_tut_may_day")
end

function UIEventMayDayBingoLayout:InitButtonListener()
    self.layoutConfig.bgTapReset.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickReset()
    end)
    self.layoutConfig.buttonReward.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickShowReward()
    end)
end

function UIEventMayDayBingoLayout:OnShow()
    UIEventMayDayLayout.OnShow(self)
    self.layoutConfig.bgTouch1.gameObject:SetActive(false)

    self.listQuestBingo = self.eventConfig:GetListBingoQuestConfig()
    self.layoutConfig.bgTouch.gameObject:SetActive(false)
    self:ReturnPoolCard()
    self:ReturnPoolRewardExtra()

    for i = 1, countCard do
        --- @type MayDayCardItemView
        local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MayDayCardItemView, self.layoutConfig.content)
        item.config.button.interactable = true
        item:AddListener(function ()
            self:OnClickOpenCard(i)
        end)
        self.listCard:Add(item)
    end

    for i = 1, self.eventConfig:GetBingoRewardExtraData():Count() do
        ---@type MayDayBingoItemView
        local itemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MayDayBingoItemView, self.layoutConfig.itemExtraConfig)
        local reward = self.eventConfig:GetRewardExtraById(i)
        itemView:SetTextBingo(i)
        itemView:SetBarActive(i < self.eventConfig:GetBingoRewardExtraData():Count())
        itemView:SetIconData(reward:GetIconData())
        itemView:RegisterShowInfo()
        self.listRewardExtra:Add(itemView)
    end

    self:UpdateCard()
    self:UpdateUI()
    self:ResizeScroll()
end

function UIEventMayDayBingoLayout:ResizeScroll()
    if self.eventModel.totalOpenTime >= self.listQuestBingo:Get(self.listQuestBingo:Count()):GetMainRequirementTarget() - 30 then
        self.uiScroll:Resize(self.listQuestBingo:Count(), 4)
    else
        self.uiScroll:Resize(self.listQuestBingo:Count(), math.max(0, self:_GetCurrentRewardMilestone() - 3))
    end

    self.layoutConfig.textBingoCount.text = string.format("%s: %s",LanguageUtils.LocalizeCommon("bingo_count") , self.eventModel.totalOpenTime)
end

function UIEventMayDayBingoLayout:InitScroll()
    --- @param obj LunarNewYearBingo2024RewardItemView
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type QuestElementConfig
        local questElementConfig = self.listQuestBingo:Get(dataIndex)
        local level = questElementConfig:GetMainRequirementTarget()
        obj:SetData(level, questElementConfig:GetListReward())
        obj:SetClaim(level <= self.eventModel.totalOpenTime)
        obj:Highlight(dataIndex == self:_GetCurrentRewardMilestone())
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollReward, UIPoolType.MayDayBingoRewardItemView, onCreateItem)
end

function UIEventMayDayBingoLayout:_GetCurrentRewardMilestone()
    for i = 1, self.listQuestBingo:Count() do
        --- @type QuestElementConfig
        local questElementConfig = self.listQuestBingo:Get(i)
        local level = questElementConfig:GetMainRequirementTarget()
        if level > self.eventModel.totalOpenTime then
            return i
        end
    end
    return self.listQuestBingo:Count()
end

function UIEventMayDayBingoLayout:UpdateCard()
    for i = 1, countCard do
        --- @type MayDayCardItemView
        local item = self.listCard:Get(i)
        item:HideItem()
        local idReward = self.eventModel:GetRewardById(i - 1)
        local reward = self.eventConfig:GetRewardById(idReward)
        if reward ~= nil then
            item:SetIconData(reward:GetIconData())
        end
    end
end

function UIEventMayDayBingoLayout:UpdateUI()
    self.layoutConfig.bgTapReset.gameObject:SetActive(self.eventModel:GetOpenedCard():Count() >= self.eventConfig:GetBingoConfig().max_open_slot)

    self.layoutConfig.textChanceResetValue.text = string.format("%s/%s", math.floor(self.eventModel:GetOpenedCard():Count()/2),
            math.floor(self.eventConfig:GetBingoConfig().max_open_slot/2))

    for i = 1, self.eventConfig:GetBingoRewardExtraData():Count() do
        ---@type MayDayBingoItemView
        local itemView = self.listRewardExtra:Get(i)
        itemView:SetClaimed(i <= self.eventModel.totalBingo)
        itemView:ActiveMaskSelect(i <= self.eventModel.totalBingo)
    end
end

function UIEventMayDayBingoLayout:ShowEffect(isActive)
    for i = 1, countCard do
        --- @type MayDayCardItemView
        local item = self.listCard:Get(i)
        item:ShowEffect(isActive)
    end
end

function UIEventMayDayBingoLayout:OnClickShowReward()
    local data = {}
    --- @type List
    data.listRewardIconData = self.eventConfig:GetListRewardRate()
    data.uiPoolType = UIPoolType.RateView
    PopupMgr.ShowPopup(UIPopupName.UIShowItemInRandomPool, data)
end

function UIEventMayDayBingoLayout:OnClickReset()
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            local openedCardPositionDict = Dictionary()
            local size = buffer:GetByte()
            for i = 1, size do
                openedCardPositionDict:Add(buffer:GetInt(), buffer:GetInt())
            end
            self.eventModel:SetOpenedCardDict(openedCardPositionDict)
        end
        local onSuccess = function()
            self:ShowEffect(false)
            self:ShowEffect(true)
            self.eventModel.totalBingo = 0
            self:UpdateCard()
            self:UpdateUI()
            self:ResizeScroll()
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result ,onBufferReading ,onSuccess ,onFailed)
    end
    NetworkUtils.Request(OpCode.EVENT_MAY_DAY_RESET_BINGO, nil, onReceived)
end

function UIEventMayDayBingoLayout:OnClickOpenCard(index)
    --local item = self.listCard:Get(index)
    local openedCardPositionBefore = self.eventModel:GetOpenedCard()
    local openedCardPositionDictAfter = Dictionary()
    local canOpen = InventoryUtils.IsEnoughSingleResourceRequirement(
            RewardInBound.CreateBySingleParam(ResourceType.Money ,MoneyType.EVENT_MAY_DAY_PLAY_TICKET ,1))
    if canOpen then
        local onReceived = function(result)
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                self.rewards = NetworkUtils.GetListDataInBound(buffer ,RewardInBound.CreateByBuffer)
                local size = buffer:GetByte()
                for i = 1, size do
                    openedCardPositionDictAfter:Add(buffer:GetInt(), buffer:GetInt())
                end
                self.eventModel:SetOpenedCardDict(openedCardPositionDictAfter)
                self.eventModel.totalBingo = buffer:GetInt()
                self.eventModel.totalOpenTime = buffer:GetInt()
            end
            local onSuccess = function()
                self.layoutConfig.bgTouch1.gameObject:SetActive(true)

                local listIndexItemAfter = List()
                for i, v in pairs(openedCardPositionDictAfter:GetItems()) do
                    if openedCardPositionBefore:IsContainKey(i) == false then
                        listIndexItemAfter:Add(i + 1)
                    end
                end

                self.coroutine = Coroutine.start(function()
                    for i = 1, listIndexItemAfter:Count() do
                       --- @type MayDayCardItemView
                       local item = self.listCard:Get(listIndexItemAfter:Get(i))
                       item:ActiveEffectOpenCard(false)
                       item:ActiveEffectOpenCard(true)
                    end
                    self:UpdateCard()
                    coroutine.waitforseconds(0.75)
                    InventoryUtils.Sub(ResourceType.Money ,MoneyType.EVENT_MAY_DAY_PLAY_TICKET ,1)
                    if self.rewards ~= nil then
                        PopupUtils.ClaimAndShowRewardList(self.rewards)
                        self.rewards = nil
                    end
                    self:UpdateUI()
                    self:ResizeScroll()
                    self.layoutConfig.bgTouch1.gameObject:SetActive(false)
                end)

                zg.audioMgr:PlaySfxUi(SfxUiType.OPEN_CARD)
            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            NetworkUtils.ExecuteResult(result ,onBufferReading ,onSuccess ,onFailed)
        end
        NetworkUtils.Request(OpCode.EVENT_MAY_DAY_OPEN_BINGO ,UnknownOutBound.CreateInstance(PutMethod.Int ,index - 1) ,onReceived)
    end
end

function UIEventMayDayBingoLayout:SetUpLayout()
    UIEventMayDayLayout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventMayDayBingoLayout:ShowMoneyBar()
    ---@type MoneyBarView
    local moneyBarView1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyBarAnchor1)
    moneyBarView1:SetIconData(MoneyType.EVENT_MAY_DAY_PLAY_TICKET)
    moneyBarView1.config.buttonInfo.interactable = true
    moneyBarView1.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView1:SetSize(0, 0)
    moneyBarView1.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView1:ShowInfo()
    end)
    self.listMoneyBar:Add(moneyBarView1)
end

function UIEventMayDayBingoLayout:ReturnPoolMoneyBar()
    ---@param v MoneyBarView
    for _, v in pairs(self.listMoneyBar:GetItems()) do
        v:ReturnPool()
    end
    self.listMoneyBar:Clear()
end

function UIEventMayDayBingoLayout:ReturnPoolCard()
    ---@param v PieceAdventureOpenCardItemView
    for i, v in ipairs(self.listCard:GetItems()) do
        v:ReturnPool()
    end
    self.listCard:Clear()
end

function UIEventMayDayBingoLayout:ReturnPoolRewardExtra()
    ---@param v PieceAdventureOpenCardItemView
    for i, v in ipairs(self.listRewardExtra:GetItems()) do
        v:ReturnPool()
    end
    self.listRewardExtra:Clear()
end

function UIEventMayDayBingoLayout:OnHide()
    UIEventMayDayLayout.OnHide(self)
    self:ShowEffect(false)
    self:ReturnPoolMoneyBar()
    self:ReturnPoolCard()
    self:ReturnPoolRewardExtra()
end
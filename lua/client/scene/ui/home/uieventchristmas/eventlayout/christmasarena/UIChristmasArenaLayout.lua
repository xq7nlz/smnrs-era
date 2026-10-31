--- @class UIChristmasArenaLayout : UIEventChristmasLayout
UIChristmasArenaLayout = Class(UIChristmasArenaLayout, UIEventChristmasLayout)

local TOTAL_DAY_BET = 13

--- @param view UIEventChristmas
--- @param tab ChristmasTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIChristmasArenaLayout:Ctor(view, tab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type UIEventChristmasArenaLayoutConfig
    self.layoutConfig = nil
    --- @type ItemsTableView
    self.moneyTableView = nil
    --- @type List
    self.listReward = nil
    UIEventChristmasLayout.Ctor(self, view, tab, anchor)
end

function UIChristmasArenaLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_christmas_arena_layout", self.anchor)
    UIEventChristmasLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:InitScroll()

    self.moneyTableView = ItemsTableView(self.layoutConfig.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

function UIChristmasArenaLayout:InitLocalization()
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_christmas_arena_title")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_christmas_arena_content")
end

function UIChristmasArenaLayout:SetUpLayout()
    UIEventChristmasLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
    self:ShowMoneyBar()
end

function UIChristmasArenaLayout:InitButtons()

end

function UIChristmasArenaLayout:OnShow()
    UIEventChristmasLayout.OnShow(self)
    self:InitLocalization()
    self:OnUpdateCurrentDay()
end

function UIChristmasArenaLayout:ReturnPoolScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIChristmasArenaLayout:OnHide()
    self:ReturnPoolScroll()
    UIEventChristmasLayout.OnHide(self)
    self.moneyTableView:Hide()
end

function UIChristmasArenaLayout:InitScroll()
    --- @param obj UIEventChristmasArenaItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        local betScoreInbound = self.eventModel:GetBetScoreInboundByDay(dataIndex)
        obj:SetData(dataIndex, self.currentEventDay, self.view)
        obj:AddClaimListener(function()
            if self.eventModel:IsClaimedBetReward(dataIndex) then
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("claimed"))
            elseif betScoreInbound == nil then
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reward_claimed"))
            else
                self:OnClickClaim(dataIndex)
            end
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.UIEventChristmasArenaItem, onCreateItem)
end

function UIChristmasArenaLayout:OnUpdateCurrentDay()
    self.currentEventDay = self.eventModel.loginData.eventCurrentDay
    self:OnUpdateArenaItem()
end

function UIChristmasArenaLayout:OnClickClaim(day)
    local outBound = UnknownOutBound.CreateInstance(PutMethod.Int, day)

    local onSuccess = function()
        self.eventModel:AddBoolClaimedBetReward(day, true)
        self:ClaimListReward()
        self:OnClaimSuccess()
    end
    
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            self.listReward = NetworkUtils.GetRewardInBoundList(buffer)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.EVENT_CHRISTMAS_BET_ARENA_CLAIM, outBound, onReceived)
end

function UIChristmasArenaLayout:ClaimListReward()
    if self.listReward ~= nil then
        PopupUtils.ClaimAndShowRewardList(self.listReward)
        self.listReward = nil
    end
end

function UIChristmasArenaLayout:OnClaimSuccess()
    self:OnUpdateArenaItem()
end

function UIChristmasArenaLayout:OnUpdateArenaItem()
    self.uiScroll:Resize(TOTAL_DAY_BET)
    local scrollSpeed = 0
    if self.currentEventDay >= 7 then
        scrollSpeed = 8000
    else
        scrollSpeed = 2000
    end

    if self.currentEventDay > TOTAL_DAY_BET then
        self.uiScroll:ScrollToCell(TOTAL_DAY_BET - 1, scrollSpeed)
    else
        self.uiScroll:ScrollToCell(self.currentEventDay - 1, scrollSpeed)
    end
end

function UIChristmasArenaLayout:ShowMoneyBar()
    local moneyList = List()
    moneyList:Add(MoneyType.EVENT_CHRISTMAS_CANDLE)
    self.moneyTableView:SetData(moneyList)
end

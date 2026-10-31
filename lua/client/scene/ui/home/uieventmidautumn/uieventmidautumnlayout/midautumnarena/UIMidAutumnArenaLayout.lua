--- @class UIMidAutumnArenaLayout : UIEventMidAutumnLayout
UIMidAutumnArenaLayout = Class(UIMidAutumnArenaLayout, UIEventMidAutumnLayout)

local TOTAL_DAY_BET = 13

--- @param view UIEventMidAutumn
--- @param eventMidAutumnTab MidAutumnTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIMidAutumnArenaLayout:Ctor(view, eventMidAutumnTab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type UIEventMidAutumnArenaLayoutConfig
    self.layoutConfig = nil
    --- @type ItemsTableView
    self.moneyTableView = nil
    --- @type List
    self.listReward = nil
    UIEventMidAutumnLayout.Ctor(self, view, eventMidAutumnTab, anchor)
end

function UIMidAutumnArenaLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_mid_autumn_arena_layout", self.anchor)
    UIEventMidAutumnLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:InitScroll()

    self.moneyTableView = ItemsTableView(self.layoutConfig.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

function UIMidAutumnArenaLayout:InitLocalization()
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_mid_autumn_arena_title")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_mid_autumn_arena_content")
end

function UIMidAutumnArenaLayout:SetUpLayout()
    UIEventMidAutumnLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
    self:ShowMoneyBar()
end

function UIMidAutumnArenaLayout:InitButtons()

end

function UIMidAutumnArenaLayout:OnShow()
    UIEventMidAutumnLayout.OnShow(self)
    self:InitLocalization()
    self:OnUpdateCurrentDay()
end

function UIMidAutumnArenaLayout:ReturnPoolScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIMidAutumnArenaLayout:OnHide()
    self:ReturnPoolScroll()
    UIEventMidAutumnLayout.OnHide(self)
    self.moneyTableView:Hide()
end

function UIMidAutumnArenaLayout:InitScroll()
    --- @param obj UIEventMidAutumnArenaItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        local betScoreInbound = self.eventMidAutumnModel:GetBetScoreInboundByDay(dataIndex)
        obj:SetData(dataIndex, self.currentEventDay, self.view)
        obj:AddClaimListener(function()
            if self.eventMidAutumnModel:IsClaimedBetReward(dataIndex) then
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("claimed"))
            elseif betScoreInbound == nil then
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reward_claimed"))
            else
                self:OnClickClaim(dataIndex)
            end
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.UIEventMidAutumnArenaItem, onCreateItem)
end

function UIMidAutumnArenaLayout:OnUpdateCurrentDay()
    self.currentEventDay = self.eventMidAutumnModel.loginData.eventCurrentDay
    self:OnUpdateArenaItem()
end

function UIMidAutumnArenaLayout:OnClickClaim(day)
    local outBound = UnknownOutBound.CreateInstance(PutMethod.Int, day)

    local onSuccess = function()
        self.eventMidAutumnModel:AddBoolClaimedBetReward(day, true)
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
    NetworkUtils.Request(OpCode.EVENT_MID_AUTUMN_BET_ARENA_CLAIM, outBound, onReceived)
end

function UIMidAutumnArenaLayout:ClaimListReward()
    if self.listReward ~= nil then
        PopupUtils.ClaimAndShowRewardList(self.listReward)
        self.listReward = nil
    end
end

function UIMidAutumnArenaLayout:OnClaimSuccess()
    self:OnUpdateArenaItem()
end

function UIMidAutumnArenaLayout:OnUpdateArenaItem()
    self.uiScroll:Resize(TOTAL_DAY_BET)
    local scrollSpeed = 0
    if self.currentEventDay >= 7 then
        scrollSpeed = 4000
    else
        scrollSpeed = 2000
    end
    self.uiScroll:ScrollToCell(self.currentEventDay - 1, scrollSpeed)
end

function UIMidAutumnArenaLayout:ShowMoneyBar()
    local moneyList = List()
    moneyList:Add(MoneyType.EVENT_MID_AUTUMN_LANTERN)
    self.moneyTableView:SetData(moneyList)
end

require "lua.client.scene.ui.home.uiEventSkinChallenge.layout.UIEventSkinChallengeLayout"

--- @class UIEventSkinChallengeExchangeLayout : UIEventSkinChallengeLayout
UIEventSkinChallengeExchangeLayout = Class(UIEventSkinChallengeExchangeLayout, UIEventSkinChallengeLayout)

--- @param view UIEventSkinChallengeView
--- @param eventSkinChallengeTab EventSkinChallengeTab
--- @param anchor UnityEngine_RectTransform
function UIEventSkinChallengeExchangeLayout:Ctor(view, eventSkinChallengeTab, anchor)
    --- @type UIEventSkinChallengeExchangeLayoutConfig
    self.layoutConfig = nil
    --- @type UIEventSkinChallengeLayout
    self.layout = nil
    self.view = view
    --- @type List
    self.listExchangeItem = List()
    --- @type List
    self.listExchangeSkin = List()
    ---@type UILoopScroll
    self.uiScroll = nil
    UIEventSkinChallengeLayout.Ctor(self, view, eventSkinChallengeTab, anchor)
end

function UIEventSkinChallengeExchangeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("ui_event_skin_challenge_exchange_layout", self.anchor)
    UIEventSkinChallengeLayout.InitLayoutConfig(self, inst)
    self:InitListeners()
    self:InitUpdateTime()
    self:InitScrolls()
end

function UIEventSkinChallengeExchangeLayout:InitListeners()
    self.layoutConfig.backButton.onClick:AddListener(function()
        --self:CloseLayout()
        self.view:SelectTab(EventSkinChallengeTab.QUEST)
    end)
    self.layoutConfig.buttonInfor.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_skin_challenge_exchange_info"))
    end)
end

function UIEventSkinChallengeExchangeLayout:OnShow()
    UIEventSkinChallengeLayout.OnShow(self)
    self.model = self.view.eventModel
    self:InitLocalization()
    self:SetEndEventTime(self:GetEventEndTime(), function()
        self:OnEventTimeEnded()
    end)
    ---@type EventSkinChallengeSkinExchangeConfig
    self:InitMoneyBar()
    ---@type EventSkinChallengeModel
    self.eventModel2 = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SKIN_CHALLENGE)
    self.uiScroll:Resize(self.listExchangeSkin:Count())
end

function UIEventSkinChallengeExchangeLayout:InitMoneyBar()
    if self.moneyBarView == nil then
        self.moneyBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
        self.moneyBarView:SetIconData(MoneyType.SKIN_BADGE)
    end
end

function UIEventSkinChallengeExchangeLayout:ReturnPoolMoneyBar()
    if self.moneyBarView ~= nil then
        self.moneyBarView:ReturnPool()
        self.moneyBarView = nil
    end
end

function UIEventSkinChallengeExchangeLayout:ReturnPoolExchangeItem()
    ---@param v SkinChallengeExchangeItem
    for _, v in pairs(self.listExchangeItem:GetItems()) do
        v:ReturnPool()
    end
    self.uiScroll:Hide()
end

function UIEventSkinChallengeExchangeLayout:InitScrolls()
    self.listExchangeSkin = ResourceMgr.GetSkinChallengeExchangeConfig().listExchangeSkin
    ---@param obj SkinChallengeExchangeItem
    local onCreateItem = function(obj, index)
        ---@type SkinChallengeSkinItemConfig
        local exchangeItem = self.listExchangeSkin:Get(index + 1)
        self:SetItemData(obj, exchangeItem)
        local numberBuy = self.eventModel2:GetNumberBuy(EventActionType.SKIN_CHALLENGE_EXCHANGE, index + 1)
        if numberBuy < tonumber(obj.limit) then
            obj:AvailableToBuy(true)
            obj.onClickExchange = function()
                local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.SKIN_BADGE, obj.moneyValue))
                if canExchange then
                    local yesCallback = function()
                        PopupMgr.HidePopup(UIPopupName.UIPopupNotificationReward)
                        local rewardList = List()
                        --- @param buffer UnifiedNetwork_ByteBuf
                        local onBufferReading = function(buffer)
                            rewardList = NetworkUtils.GetRewardInBoundList(buffer)
                        end

                        local onSuccess = function()
                            --InventoryUtils.Sub(ResourceType.Money, MoneyType.SKIN_BADGE, obj.moneyValue)
                            InventoryUtils.Sub(ResourceType.Money, obj.moneyType, obj.moneyValue)
                            obj:AvailableToBuy(false)
                            self.eventModel:AddNumberBuy(EventActionType.SKIN_CHALLENGE_EXCHANGE, index + 1, obj.resourceNumber)
                            if rewardList ~= nil or rewardList:Count() > 0 then
                                PopupUtils.ClaimAndShowRewardList(rewardList)
                            end
                        end

                        local onFailed = function()
                            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("failed"))
                        end

                        local outBound = UnknownOutBound.CreateInstance(PutMethod.Int, obj.id, PutMethod.Int, obj.resourceNumber)
                        NetworkUtils.RequestAndCallback(OpCode.EVENT_SKIN_CHALLENGE_EXCHANGE, outBound, onSuccess, onFailed, onBufferReading)
                    end

                    local rewardList = List()
                    local rewardItem = RewardInBound.CreateBySingleParam(obj.resourceType, obj.resourceId, obj.resourceNumber, obj.resourceData)
                    rewardList:Add(rewardItem)
                    local resourceList = RewardInBound.GetItemIconDataList(rewardList)

                    local data = {}
                    data.rewardList = rewardList
                    data.resourceList = resourceList
                    data.textButton = true
                    data.titleText = string.format("%s\n%s", LanguageUtils.LocalizeCommon("confirm_exchange"),
                            UIUtils.SetColorString(UIUtils.red_light, LanguageUtils.LocalizeSkinName(obj.resourceId)))
                    data.yesCallback = yesCallback
                    PopupMgr.ShowPopup(UIPopupName.UIPopupNotificationReward, data)
                end
            end
        else
            obj:AvailableToBuy(false)
            obj.onClickExchange = function()
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("already_exchange")
                )
            end
        end
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.SkinChallengeExchangeItem, onCreateItem)
end

---@param data EventSkinChallengeSkinExchangeConfig
---@param obj SkinChallengeExchangeItem
function UIEventSkinChallengeExchangeLayout:SetItemData(obj, data)
    obj:SetItemData(tonumber(data.id), tonumber(data.money_type), tonumber(data.money_value), tonumber(data.res_type), tonumber(data.res_id), tonumber(data.res_number), tonumber(data.res_data), tonumber(data.limit))
end

function UIEventSkinChallengeExchangeLayout:InitLocalization()
    self.layoutConfig.textEventTittle.text = LanguageUtils.LocalizeCommon("event_skin_challenge")
    self.layoutConfig.textExchangeDetail.text = LanguageUtils.LocalizeCommon("event_skin_challenge_detail")
end

function UIEventSkinChallengeExchangeLayout:OnHide()
    self:ReturnPoolMoneyBar()
    self:ReturnPoolExchangeItem()
    self:RemoveUpdateTime()
    UIEventSkinChallengeLayout.OnHide(self)
end

function UIEventSkinChallengeExchangeLayout:GetEventEndTime()
    return self.eventModel.timeData.endTime
end

--- @param endTime number
--- @param onEventTimeEnded function
function UIEventSkinChallengeExchangeLayout:SetEndEventTime(endTime, onEventTimeEnded)
    self.endTime = endTime
    self.onEventTimeEnded = onEventTimeEnded
    self:StartUpdateTime()
end

--- @param eventTimeType EventTimeType
function UIEventSkinChallengeExchangeLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventSkinChallengeExchangeLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventSkinChallengeExchangeLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventSkinChallengeExchangeLayout:SetTimeRefresh()
    self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
end

function UIEventSkinChallengeExchangeLayout:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.layoutConfig.textEventTime.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end




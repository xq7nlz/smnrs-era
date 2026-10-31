require "lua.client.scene.ui.home.WorldSpaceHeroView.WorldSpaceHeroView"
require "lua.client.scene.ui.notification.NotificationEventServerOpen"

--- @class ServerOpenType
ServerOpenType = {
    QUEST = 1,
    MARKET = 2,
}

--- @class ServerOpenItemData
ServerOpenItemData = Class(ServerOpenItemData)

function ServerOpenItemData:Ctor(type, id)
    ---@type ServerOpenType
    self.type = type
    ---@type number
    self.id = id
    ---@type QuestUnitInBound
    self.questUnitInBound = nil
    ---@type EventServerOpenMarketItem
    self.eventServerOpenMarketItem = nil
end

--- @class UIEventServerOpenView : UIBaseView
UIEventServerOpenView = Class(UIEventServerOpenView, UIBaseView)

--- @return void
--- @param model UIEventServerOpenModel
function UIEventServerOpenView:Ctor(model)
    self.day = nil
    self.indexDayLock = nil
    --- @type UISelect
    self.tab = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type EventServerOpenConfig
    self.eventServerOpenConfig = nil
    ---@type List
    self.listProgressView = List()
    ---@type MoneyType
    self.moneyTypeProgress = nil
    ---@type List --<ServerOpenItemData>
    self.listItem = List()

    ---@type List
    self.listRewardInfo = List()
    ---@type WorldSpaceHeroView
    self.worldSpaceHeroView = nil

    ---@type Dictionary --<UITabNewServerConfig>
    self.dictTab = Dictionary()

    UIBaseView.Ctor(self, model)
    --- @type UIEventServerOpenModel
    self.model = model
end

--- @return void
function UIEventServerOpenView:OnReadyCreate()

    --- @type UIEventServerOpenConfig
    self.config = UIBaseConfig(self.uiTransform)

    self.config.backButton.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)

    self.config.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)

    self.config.bgButtonReward.onClick:AddListener(function()
        self:OnClickHideRewardInfo()
    end)

    --- @param obj EventServerOpenItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        ---@type ServerOpenItemData
        local serverOpenItemData = self.listItem:Get(dataIndex)
        obj:SetIconData(serverOpenItemData, function()
            self:OnClickGo(obj)
        end, function()
            self:OnClickCollect(obj)
        end, function()
            self:OnClickBuy(obj)
        end)
    end
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.EventServerOpenItemView, onCreateItem)

    -- Tab
    --- @param obj UITabNewServerConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect, indexTab)
        obj.button.interactable = not isSelect
        obj.imageOn:SetActive(false)
        obj.iconOff:SetActive(false)
        obj.iconLock:SetActive(false)
        obj.iconOff.transform.parent.gameObject:SetActive(false)
        if isSelect == true then
            obj.imageOn:SetActive(true)
            obj.textDay.color = U_Color(1, 0.92, 0.78, 1)
        else
            obj.iconOff.transform.parent.gameObject:SetActive(true)
            obj.textDay.color = U_Color(0.48, 0.44, 0.4, 1)
        end

        if self.indexDayLock == nil or indexTab < self.indexDayLock then
            obj.iconOff:SetActive(true)
        else
            obj.iconLock:SetActive(true)
        end
    end
    local onChangeSelect = function(indexTab, lastTab)
        self:ShowDay(indexTab)
    end
    self.tab = UISelect(self.config.eventDayTab, UIBaseConfig, onSelect, onChangeSelect, nil, function(index)
        if self.indexDayLock == nil or index < self.indexDayLock then
            return true
        end
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("coming_soon"))
        return false
    end)

    self:InitUpdateTime()
end

--- @return void
function UIEventServerOpenView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("event_server_open")
    self.localizeEventEnd = LanguageUtils.LocalizeCommon("will_end_in")
end

--- @return void
function UIEventServerOpenView:OnReadyShow(result)
    ---@type BasicInfoInBound
    self.basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    ---@type ServerOpenInBound
    self.serverOpenInBound = zg.playerData:GetMethod(PlayerDataMethod.SERVER_OPEN)
    self.eventServerOpenConfig = ResourceMgr.GetEventServerOpenConfig()

    self:DetectDayLock()

    self:InitTab()

    self:ShowProgress()

    self:ShowFinalProgress()

    self:StartTime()
end

--- @return void
function UIEventServerOpenView:InitTab()
    UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.config.eventDayTab)

    local localizeDay = LanguageUtils.LocalizeCommon("day_x")
    self.dictTab:Clear()
    local currentDay = 1
    local totalDay = self.eventServerOpenConfig.listDay:Count()
    --XDebug.Log("total " .. tostring(totalDay) .. " DAY LOCK " .. tostring(self.indexDayLock))

    for i = 1, self.config.eventDayTab.childCount do
        if i <= self.eventServerOpenConfig.listDay:Count() then
            local tab = UIBaseConfig(self.config.eventDayTab:GetChild(i - 1))
            local day = self.eventServerOpenConfig.listDay:Get(i)
            if NotificationEventServerOpen.CheckNotificationEventServerOpenByDay(day) == true and (self.indexDayLock == nil or i < self.indexDayLock) then
                tab.notice:SetActive(true)
            else
                tab.notice:SetActive(false)
            end
            if self.indexDayLock == nil or i < self.indexDayLock then
                tab.iconOff:SetActive(true)
                tab.iconLock:SetActive(false)
            else
                tab.iconOff:SetActive(false)
                tab.iconLock:SetActive(true)
            end
            self.dictTab:Add(day, tab)
            if (self.indexDayLock - 1 >= totalDay) then
                self.config.eventBundleDuration.gameObject:SetActive(false)
            end
            if i == self.indexDayLock then
                    local anchorNextDay = self.config.eventDayTab:GetChild(self.indexDayLock - 1)
                    local pos = self.config.eventBundleDuration.transform.position
                    pos.x = anchorNextDay.transform.position.x
                    self.config.eventBundleDuration.transform.position = pos
                    self.config.eventBundleDuration.gameObject:SetActive(true)
            end
            tab.textDay.text = day
            tab.localizeDay.text = string.format(localizeDay, day)
            if (self.indexDayLock == nil or i < self.indexDayLock) and currentDay < day then
                currentDay = day
            end
        else
            self.config.eventDayTab:GetChild(i - 1).gameObject:SetActive(false)
        end
    end
    if (self.indexDayLock - 1 >= totalDay) then
        currentDay = totalDay
    end
    self.tab:Select(currentDay)
end




--- @return void
function UIEventServerOpenView:DetectDayLock()
    self.indexDayLock = self.eventServerOpenConfig:GetIndexDayLock()

    self.config.eventBundleDuration.gameObject:SetActive(self.indexDayLock ~= nil)
end

--- @return void
function UIEventServerOpenView:SortListItem()
    self.listItem:Clear()
    ---@param v QuestUnitInBound
    for _, v in ipairs(self.serverOpenInBound.listQuest:GetItems()) do
        if self.eventServerOpenConfig.dictQuestDay:Get(v.questId) == self.day
                and v.number ~= nil and v.number >= v.config:GetMainRequirementTarget()
                and v.questState ~= QuestState.COMPLETED then
            local item = ServerOpenItemData(ServerOpenType.QUEST, v.questId)
            item.questUnitInBound = v
            self.listItem:Add(item)
        end
    end

    ---@param v EventServerOpenMarketItem
    for _, v in ipairs(self.serverOpenInBound.listMarketItem:GetItems()) do
        if self.eventServerOpenConfig.dictMarketDay:Get(v.id) == self.day and v.currentStock > 0 then
            local item = ServerOpenItemData(ServerOpenType.MARKET, v.id)
            item.eventServerOpenMarketItem = v
            self.listItem:Add(item)
        end
    end

    ---@param v QuestUnitInBound
    for _, v in ipairs(self.serverOpenInBound.listQuest:GetItems()) do
        if v.questState ~= QuestState.COMPLETED and self.eventServerOpenConfig.dictQuestDay:Get(v.questId) == self.day
                and (v.number == nil or v.number < v.config:GetMainRequirementTarget()) then
            local item = ServerOpenItemData(ServerOpenType.QUEST, v.questId)
            item.questUnitInBound = v
            self.listItem:Add(item)
        end
    end

    ---@param v EventServerOpenMarketItem
    for _, v in ipairs(self.serverOpenInBound.listMarketItem:GetItems()) do
        if self.eventServerOpenConfig.dictMarketDay:Get(v.id) == self.day and v.currentStock == 0 then
            local item = ServerOpenItemData(ServerOpenType.MARKET, v.id)
            item.eventServerOpenMarketItem = v
            self.listItem:Add(item)
        end
    end

    ---@param v QuestUnitInBound
    for _, v in ipairs(self.serverOpenInBound.listQuest:GetItems()) do
        if self.eventServerOpenConfig.dictQuestDay:Get(v.questId) == self.day and v.questState == QuestState.COMPLETED then
            local item = ServerOpenItemData(ServerOpenType.QUEST, v.questId)
            item.questUnitInBound = v
            self.listItem:Add(item)
        end
    end
end

--- @return void
function UIEventServerOpenView:ShowDay(index)
    self.day = self.eventServerOpenConfig.listDay:Get(index)
    if NotificationEventServerOpen.CheckNotificationEventServerOpenByDay(self.day) == true then
        ---@type UITabNewServerConfig
        local tab = self.dictTab:Get(self.day)
        if tab ~= nil then
            tab.notice:SetActive(false)
        else
            XDebug.Error("Nil tab day " .. index)
        end
        NotificationEventServerOpen.RemoveNotificationDay(self.day)
    end
    self.uiScroll:Hide()
    self:SortListItem()
    self.uiScroll:Resize(self.listItem:Count())
    self:OnClickHideRewardInfo()
end

--- @return void
function UIEventServerOpenView:ShowProgress()
    self.config.contentProgress.spacing = self.config.rectContent.sizeDelta.x / self.eventServerOpenConfig.listProgress:Count()
    self.moneyTypeProgress = nil
    ---@param serverOpenProgress ServerOpenProgress
    for _, serverOpenProgress in ipairs(self.eventServerOpenConfig.listProgress:GetItems()) do
        --- @type RewardPointItemView
        local rewardPointItemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RewardPointItemView, self.config.contentProgress.transform)
        self.moneyTypeProgress = serverOpenProgress.moneyData.itemId
        rewardPointItemView:SetIconData(serverOpenProgress)
        rewardPointItemView:AddListener(function()
            self:OnClickProgress(rewardPointItemView)
        end)
        self.listProgressView:Add(rewardPointItemView)
    end
    self:UpdateProgress()
end

--- @return void
function UIEventServerOpenView:UpdateProgress()
    if self.moneyTypeProgress ~= nil then
        local currentPoint = InventoryUtils.GetMoney(self.moneyTypeProgress) or 0
        self.config.textEventPoint.text = ClientConfigUtils.FormatNumber(currentPoint)
        ---@type number
        local indexUnlock = 0
        ---@type ServerOpenProgress
        local serverOpenProgressStart = nil
        ---@type ServerOpenProgress
        local serverOpenProgressEnd = nil
        --- @param rewardPointItemView RewardPointItemView
        for i, rewardPointItemView in ipairs(self.listProgressView:GetItems()) do
            local isUnlock = rewardPointItemView.target <= currentPoint
            rewardPointItemView:UpdateStateView(isUnlock, self.serverOpenInBound.listClaim:IsContainValue(rewardPointItemView.id))
            if isUnlock == true then
                if i > indexUnlock then
                    indexUnlock = i
                    serverOpenProgressStart = rewardPointItemView.serverOpenProgress
                end
            else
                if serverOpenProgressEnd == nil then
                    serverOpenProgressEnd = rewardPointItemView.serverOpenProgress
                end
            end
        end
        local sizeDelta = 0
        if serverOpenProgressEnd ~= nil then
            local startPoint = 0
            if serverOpenProgressStart ~= nil then
                startPoint = serverOpenProgressStart.moneyData.quantity
            end
            sizeDelta = (currentPoint - startPoint) / (serverOpenProgressEnd.moneyData.quantity - startPoint)
        end
        self.config.progressBar.sizeDelta = U_Vector2(self.config.contentProgress.spacing * (indexUnlock + sizeDelta), self.config.progressBar.sizeDelta.y)
    end
end

--- @return void
function UIEventServerOpenView:ShowFinalProgress()
    ---@type ServerOpenProgress
    local finalProgress = self.eventServerOpenConfig.listProgress:Get(self.eventServerOpenConfig.listProgress:Count())
    self.config.iconHero.gameObject:SetActive(false)
    ---@param v RewardInBound
    for i, v in ipairs(finalProgress.listReward:GetItems()) do
        if v.type == ResourceType.HeroFragment then
            local heroId = ClientConfigUtils.GetHeroIdByFragmentHeroId(v.id)
            if heroId ~= nil then
                local star = ClientConfigUtils.GetHeroFragmentStar(v.id)
                if self.worldSpaceHeroView == nil then
                    ---@type UnityEngine_Transform
                    local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
                    self.worldSpaceHeroView = WorldSpaceHeroView(trans)
                    local renderTexture = U_RenderTexture(1000, 1000, 24, U_RenderTextureFormat.ARGB32)
                    self.config.iconHero.texture = renderTexture
                    self.worldSpaceHeroView:Init(renderTexture)
                end
                local heroResource = HeroResource()
                heroResource:SetData(-1, heroId, star, 1)
                self.worldSpaceHeroView:ShowHero(heroResource)
                self.worldSpaceHeroView.config.transform.position = U_Vector3(11000, 11000, 0)
                self.worldSpaceHeroView.config.bg:SetActive(false)
                self.config.iconHero.gameObject:SetActive(true)
                self.config.textHeroName.text = LanguageUtils.LocalizeNameHero(heroId)
                local faction = ClientConfigUtils.GetFactionIdByHeroId(heroId)
                self.config.iconFaction.sprite = ResourceLoadUtils.LoadFactionIcon(faction)
                self.config.bgTextGlow.color = UIUtils.glow_color_with_type[faction]
                self.config.bgFinalReward.color = UIUtils.glow_color_with_type[faction]
                self.config.textHeroName.color = UIUtils.text_color_with_type[faction]
                break
            end
        end
    end
    self:UpdateFinalProgress()
end

--- @return void
function UIEventServerOpenView:UpdateFinalProgress()
    ---@type ServerOpenProgress
    local finalProgress = self.eventServerOpenConfig.listProgress:Get(self.eventServerOpenConfig.listProgress:Count())
    if self.serverOpenInBound.listClaim:IsContainValue(finalProgress.id) then
        self.config.textFinalReward.text = LanguageUtils.LocalizeCommon("received")
    else
        self.config.textFinalReward.text = LanguageUtils.LocalizeCommon("final_reward")
    end
end

--- @return void
function UIEventServerOpenView:OnClickHelpInfo()
    local info = LanguageUtils.LocalizeHelpInfo("event_open_server_info")
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

--- @return void
function UIEventServerOpenView:Hide()
    UIBaseView.Hide(self)
    self.uiScroll:Hide()
    --- @param rewardPointItemView RewardPointItemView
    for i, rewardPointItemView in pairs(self.listProgressView:GetItems()) do
        rewardPointItemView:ReturnPool()
    end
    self.listProgressView:Clear()
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end

    self:StopTime()
end

--- @return void
--- @param eventServerOpenItemView EventServerOpenItemView
function UIEventServerOpenView:OnClickGo(eventServerOpenItemView)
    ---@type ServerOpenItemData
    local serverOpenItemData = eventServerOpenItemView.serverOpenItemData
    QuestDataInBound.GoQuest(serverOpenItemData.questUnitInBound.config.id, serverOpenItemData.questUnitInBound.config, function()
        PopupMgr.HidePopup(UIPopupName.UIEventServerOpen)
    end)
end

--- @return void
--- @param eventServerOpenItemView EventServerOpenItemView
function UIEventServerOpenView:OnClickBuy(eventServerOpenItemView)
    ---@type ServerOpenItemData
    local serverOpenItemData = eventServerOpenItemView.serverOpenItemData
    local requireVip = serverOpenItemData.eventServerOpenMarketItem.serverOpenMarket.vipRequire
    if requireVip == nil or self.basicInfoInBound.vipLevel >= requireVip then
        if serverOpenItemData.eventServerOpenMarketItem.currentStock > 0 then
            ---@type ItemIconData
            local itemIconData = serverOpenItemData.eventServerOpenMarketItem.serverOpenMarket.moneyData
            local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(itemIconData.type, itemIconData.itemId, itemIconData.quantity))
            if canExchange then
                local request = function()
                    NetworkUtils.RequestAndCallback(OpCode.EVENT_SERVER_OPEN_MARKET_BUY, UnknownOutBound.CreateInstance(PutMethod.Int, serverOpenItemData.id), function()
                        itemIconData:SubToInventory()
                        PopupUtils.ClaimAndShowRewardList(serverOpenItemData.eventServerOpenMarketItem.serverOpenMarket.listReward)
                        serverOpenItemData.eventServerOpenMarketItem.currentStock = serverOpenItemData.eventServerOpenMarketItem.currentStock - 1
                        if serverOpenItemData.eventServerOpenMarketItem.currentStock == 0 then
                            self:SortListItem()
                            self.uiScroll:Resize(self.listItem:Count())
                        else
                            eventServerOpenItemView:UpdateView()
                        end
                        self:UpdateProgress()
                    end, SmartPoolUtils.LogicCodeNotification)
                end
                --if itemIconData.type == ResourceType.Money and itemIconData.itemId == MoneyType.GEM then
                PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("are_you_sure"), nil, function()
                    request()
                end)
                --else
                --    request()
                --end
            end
        else

        end
    else
        SmartPoolUtils.ShowShortNotification(eventServerOpenItemView.config.textVip.text)
    end
end

--- @return void
--- @param eventServerOpenItemView EventServerOpenItemView
function UIEventServerOpenView:OnClickCollect(eventServerOpenItemView)
    ---@type ServerOpenItemData
    local serverOpenItemData = eventServerOpenItemView.serverOpenItemData
    if serverOpenItemData.questUnitInBound.questState ~= QuestState.COMPLETED then
        local questId = nil
        ---@type List
        local listReward = List()
        ---@param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            questId = buffer:GetInt()
            local size = buffer:GetByte()
            for i = 1, size do
                local reward = RewardInBound.CreateByBuffer(buffer)
                listReward:Add(reward)
            end
        end
        NetworkUtils.RequestAndCallback(OpCode.EVENT_SERVER_OPEN_QUEST_CLAIM, UnknownOutBound.CreateInstance(PutMethod.Int, serverOpenItemData.id), function()
            if serverOpenItemData.id == questId then
                PopupUtils.ClaimAndShowRewardList(listReward)
                serverOpenItemData.questUnitInBound.questState = QuestState.COMPLETED
                self:SortListItem()
                self.uiScroll:Resize(self.listItem:Count())
                self:UpdateProgress()
            end
        end, SmartPoolUtils.LogicCodeNotification, onBufferReading)
    end
end

--- @return void
--- @param rewardPointItemView RewardPointItemView
function UIEventServerOpenView:OnClickProgress(rewardPointItemView)
    ---@type ServerOpenProgress
    local serverOpenProgress = rewardPointItemView.serverOpenProgress
    if rewardPointItemView.isUnlock == true and rewardPointItemView.isClaim ~= true then
        NetworkUtils.RequestAndCallback(OpCode.EVENT_SERVER_OPEN_PROGRESS_CLAIM, UnknownOutBound.CreateInstance(PutMethod.Int, serverOpenProgress.id), function()
            PopupUtils.ClaimAndShowRewardList(serverOpenProgress.listReward)
            rewardPointItemView:UpdateStateView(true, true)
            self.serverOpenInBound.listClaim:Add(serverOpenProgress.id)
            self:UpdateFinalProgress()
        end, SmartPoolUtils.LogicCodeNotification)
    elseif rewardPointItemView.config.transform:GetSiblingIndex() ~= rewardPointItemView.config.transform.parent.childCount - 1 then
        self.config.itemRewardInfo:SetActive(true)
        self.config.itemRewardInfo.transform.position = rewardPointItemView.config.transform.position
        ---@param v RewardInBound
        for _, v in ipairs(serverOpenProgress.listReward:GetItems()) do
            --- @type RootIconView
            local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.contentReward)
            item:SetIconData(v:GetIconData())
            item:RegisterShowInfo()
            item:ActiveMaskSelect(rewardPointItemView.isClaim)
            self.listRewardInfo:Add(item)
        end
    end
end

function UIEventServerOpenView:OnClickHideRewardInfo()
    self.config.itemRewardInfo:SetActive(false)
    --- @param v IconView
    for i, v in pairs(self.listRewardInfo:GetItems()) do
        v:ReturnPool()
    end
    self.listRewardInfo:Clear()
end

function UIEventServerOpenView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            local timeServer = zg.timeMgr:GetServerTime()

            self.timeRemaining = self.serverOpenInBound.startTime + (self.serverOpenInBound.numberOfDays * TimeUtils.SecondADay) - timeServer
            if self.indexDayLock ~= nil then
                self.timeNextDayUnlock = TimeUtils.GetTimeStartDayFromSec(timeServer) + TimeUtils.SecondADay - timeServer
            end
            UIUtils.AlignText(self.config.textEventNextDay)
        else
            self.timeRemaining = self.timeRemaining - 1

            if self.timeNextDayUnlock ~= nil then
                self.timeNextDayUnlock = self.timeNextDayUnlock - 1
            end
        end
        if self.timeRemaining > 0 then
            self.config.textEventEndIn.text = string.format("%s %s", self.localizeEventEnd,
                    UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRemaining, 4)))
            if self.indexDayLock ~= nil then
                self.config.textEventNextDay.text = UIUtils.SetColorString(UIUtils.green_light, TimeUtils.SecondsToClock(self.timeNextDayUnlock))
            end
        else
            -- XDebug.Log("TIME REMAINING " ..  self.timeRemaining)
            self.config.textEventEndIn.text = ""
            self:StopTime()
            self:OnReadyHide()
        end
    end
end

--- @return void
function UIEventServerOpenView:StartTime()
    if self.updateTime ~= nil then
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end

--- @return void
function UIEventServerOpenView:StopTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end

function UIEventServerOpenView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIEventServerOpen)
end

function UIEventServerOpenView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end
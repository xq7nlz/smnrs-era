require "lua.client.scene.ui.home.uiBattlePass.UIBattlePassLayout"

--- @class UIBattlePassQuestLayout : UIBattlePassLayout
UIBattlePassQuestLayout = Class(UIBattlePassQuestLayout, UIBattlePassLayout)

--- @param view UIBattlePassView
function UIBattlePassQuestLayout:Ctor(view, anchor)
    ---@type UIBattlePassView
    self.view = view
    ---@type UIBattlePassConfig
    self.config = view.config
    ---@type  UIBattlePassQuestLayoutConfig
    self.layoutConfig = UIBaseConfig(self.config.questLayout)
    ---@type number
    self.weekIndex = nil
    --- @type UISelect
    self.tab = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    self:CreateTab()
    --- @type List --QuestUnitInBound
    self.listQuestData = nil
    ---@type number
    self.curWeekIndex = nil
    ---@type Dictionary --<UITabNewServerConfig>
    self.dictTab = Dictionary()
    ---@type number
    self.nextWeekUnlockDuration = -1
    ---@type List --UnityEngine_UI_Text
    self.updateQuestList = List()

    self:CreateQuestList()

    self:InitUpdateTime()

    UIBattlePassLayout.Ctor(self, view, anchor)

end

--- @return void
function UIBattlePassQuestLayout:StartTime()
    if self.updateTime ~= nil then
        --XDebug.Log("START TIME")
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end

function UIBattlePassQuestLayout:StopTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end

function UIBattlePassQuestLayout:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            if self.nextWeekUnlockDuration > 0 then
                self.timeNextWeekUnlock = self.nextWeekUnlockDuration
            else
                XDebug.Log("NO TIME GET")
            end
            UIUtils.AlignText(self.layoutConfig.textEventNextDay)
        else
            if self.timeNextWeekUnlock ~= nil then
                self.timeNextWeekUnlock = self.timeNextWeekUnlock - 1

            end
        end
        if self.timeNextWeekUnlock > 0 then
            if self.nextWeekUnlockDuration > 0 then
                if self.weekIndex == self.curWeekIndex then
                    local time = TimeUtils.GetDeltaTime(self.timeNextWeekUnlock)
                    self.layoutConfig.textEventNextDay.text = UIUtils.SetColorString(UIUtils.green_light, time)
                    for i = 1, self.updateQuestList:Count() do
                        self.updateQuestList:Get(i).text =LanguageUtils.LocalizeCommon("special_event")
                                .. " " .. UIUtils.SetColorString(UIUtils.white, time)
                    end
                end
            end
        else
            self.layoutConfig.textEventNextDay = ""
            self:StopTime()
        end
    end
end




function UIBattlePassQuestLayout:CreateQuestList()
    --- @param obj UIEventQuestItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type QuestUnitInBound
        local questUnitInBound = self.listQuestData:Get(dataIndex)
        obj:SetData(questUnitInBound.config, questUnitInBound)
        if questUnitInBound.config:IsFeatureMappingAvailable() then
            obj:AddGoListener(function()
                self:OnClickGo(questUnitInBound.questId, questUnitInBound.config)
            end)
        end
        obj:AddClaimListener(function()
            self:OnClickClaim(questUnitInBound.questId)
        end)
        obj.config.specialDeal:SetActive(questUnitInBound.config.isSpecial)
        if (questUnitInBound.config.isSpecial) then
            if self.weekIndex < self.curWeekIndex then
                obj.config.textEventSpecialTime.text = LanguageUtils.LocalizeCommon("ended")
            else
                self.updateQuestList:Add(obj.config.textEventSpecialTime)
            end
        end
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.BattlePassQuestItem, onCreateItem)
end

function UIBattlePassQuestLayout:OnClickClaim(questId)
    QuestDataInBound.RequestClaimQuest(OpCode.EVENT_BATTLE_PASS_QUEST_CLAIM, questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end



function UIBattlePassQuestLayout:OnClaimQuestSuccess(questId)
    self.view.eventBattlePassModel:OnClaimQuestSuccess(questId)
    self:OnUpdateListQuest()
    self.view:OnUpdatePurchase()
    self.view:CheckNotification()
end

function UIBattlePassQuestLayout:OnUpdateListQuest()
    self.listQuestData = self.view.eventBattlePassModel:GetListQuestDataByWeek(self.weekIndex)
    self:FilterWeeklyQuest()
    self.uiScroll:Resize(self.listQuestData:Count())
    self:ShowTab();
end

function UIBattlePassQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.view.model.uiName) --PopupMgr.HidePopup(self.view.model.uiName)
    end,true)
end

function UIBattlePassQuestLayout:SetWeekTab(weekNumber, maxWeek)
    local i = weekNumber
    if i <= maxWeek then
        ---@type UIBattlePassWeeklyQuestTabItemConfig
        local tab = UIBaseConfig(self.layoutConfig.eventDayTab:GetChild(i - 1))
        if self.curWeekIndex == nil or i <= self.curWeekIndex then
            tab.iconOff:SetActive(true)
            tab.iconLock:SetActive(false)
        else
            tab.iconOff:SetActive(false)
            tab.iconLock:SetActive(true)
        end
        self.dictTab:Add(i, tab)
        if (self.curWeekIndex < maxWeek and i == self.curWeekIndex) then
            local anchorNextDay = self.layoutConfig.eventDayTab:GetChild(self.curWeekIndex)
            local pos = self.layoutConfig.eventBundleDuration.transform.position
            pos.x = anchorNextDay.transform.position.x
            self.layoutConfig.eventBundleDuration.transform.position = pos
        end
        tab.textDay.text = weekNumber
        local localizeWeek = LanguageUtils.LocalizeCommon("week")
        tab.localizeDay.text = localizeWeek .. " ".. tostring(weekNumber) -- string.format(LanguageUtils.LocalizeCommon(localizeWeek , indexTab))
        if weekNumber == self.curWeekIndex +1 then
            self.layoutConfig.textEventNextDay.transform:SetParent(tab.textWeek.transform)
        end
        if self.curWeekIndex == 4 then
            self.layoutConfig.textEventNextDay.gameObject:SetActive(false)
        end
    else
        self.layoutConfig.eventDayTab:GetChild(i - 1).gameObject:SetActive(false)
    end
end

function UIBattlePassQuestLayout:ShowTab()
    ---@type Dictionary --<UIBattlePassWeeklyQuestTabItemConfig>
    self.dictTab:Clear()
    local maxWeek = self.view.eventBattlePassModel:GetMaxWeek()
    for i = 1, self.layoutConfig.eventDayTab.childCount do
        self:SetWeekTab(i, maxWeek)
    end
    local showNextWeekUnlockDuration = self.curWeekIndex <= maxWeek
    if (showNextWeekUnlockDuration) then
        self.nextWeekUnlockDuration = self.view:GetWeekTimeLeft(self.curWeekIndex)
    else
        self.nextWeekUnlockDuration = -1
    end

    self.layoutConfig.eventBundleDuration.gameObject:SetActive(showNextWeekUnlockDuration)
    for i = 1, maxWeek,1 do
        ---@type UIBattlePassWeeklyQuestTabItemConfig
        local tab = UIBaseConfig(self.layoutConfig.eventDayTab:GetChild(i - 1))
        local hasNoti = self.view.eventBattlePassModel:WeekHasQuestNotClaimed(i)
        tab.notice.gameObject:SetActive(hasNoti)
    end
end

function UIBattlePassQuestLayout:CreateTab()
    ---@param obj UIBattlePassWeeklyQuestTabItemConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect, indexTab)
        obj.button.interactable = not isSelect
        obj.imageOn:SetActive(false)
        obj.iconOff:SetActive(false)
        --obj.iconLock:SetActive(false)
        obj.iconOff.transform.parent.gameObject:SetActive(false)
        --obj.textDay.text = tostring(indexTab)
        if isSelect == true then
            obj.imageOn:SetActive(true)
            obj.textDay.color = U_Color(1, 0.92, 0.78, 1)

        else
            obj.iconOff.transform.parent.gameObject:SetActive(true)
            obj.textDay.color = U_Color(0.48, 0.44, 0.4, 1)
        end
        if (indexTab == nil) then

        else
            if self.weekIndex == nil or indexTab <= self.curWeekIndex then
                obj.iconOff:SetActive(true)
            else
                obj.iconLock:SetActive(true)
            end
        end

    end
    local onChangeSelect = function(indexTab, lastTab)
        if (indexTab == nil) then

        else
            self:ShowDay(indexTab)
        end

    end
    --index start from 0
    self.tab = UISelect(self.layoutConfig.eventDayTab, UIBaseConfig, onSelect, onChangeSelect, nil, function(index)
        if self.weekIndex == nil or index <= self.curWeekIndex then

            return true
        end
        local timeOpenIn = self.view:GetWeekTimeLeft(index - 1)
        local text = string.format("%s %s",
                UIUtils.SetColorString(UIUtils.white, LanguageUtils.LocalizeCommon("will_open_in")),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(timeOpenIn)))

        SmartPoolUtils.ShowShortNotification(text)
        return false
    end)
end

function UIBattlePassQuestLayout:ShowDay(weekIndex)
    self.weekIndex = weekIndex
    self:OnUpdateListQuest()
end

function UIBattlePassQuestLayout:InitButtons()

end

function UIBattlePassQuestLayout:_InitConfig()

end

function UIBattlePassQuestLayout:FilterWeeklyQuest()
    local questCount = self.listQuestData:Count()
    for i = questCount, 1, -1 do
        --- @type QuestUnitInBound
        local questUnitData = self.listQuestData:Get(i)
        if questUnitData.questState == QuestState.HIDDEN then
            self.listQuestData:RemoveByIndex(i)
        end
    end
end

function UIBattlePassQuestLayout:OnShow()
    ---@type UIBattlePassQuestLayoutConfig
    self.layoutConfig = UIBaseConfig(self.config.questLayout)
    local numberOfTab = self.view.eventBattlePassModel:GetConfig():GetWeeklyQuestRewardConfig():Count()
    self.tab:SetPagesCount(numberOfTab)
    -- start from 1
    self.curWeekIndex = self.view:GetWeekNumber()
    -- XDebug.Log("cur week is " .. tostring(self.curWeekIndex))
    self.weekIndex = self.curWeekIndex

    self.tab:Select(self.weekIndex)
    self.anchor.gameObject:SetActive(true)

    self:ShowDay(self.weekIndex)
    self:ShowTab()
    if (self.nextWeekUnlockDuration > 0) then
        self:StartTime()
    else

    end
end

function UIBattlePassQuestLayout:OnHide()
    self.anchor.gameObject:SetActive(false)
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
    self:StopTime()
end

function UIBattlePassQuestLayout:InitLocalization()

end

--- @class UIDailyQuestLayout : UIQuestLayout
UIDailyQuestLayout = Class(UIDailyQuestLayout, UIQuestLayout)

--- @param view UIQuestView
--- @param opCodeClaim OpCode
function UIDailyQuestLayout:Ctor(view, opCodeClaim)
    UIQuestLayout.Ctor(self, view, opCodeClaim)
    --- @type DailyQuestInBound
    self.dailyQuestInBound = nil
    --- @type EventDailyQuestPassModel
    self.eventPassModel = nil
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_DAILY_QUEST_PASS
end

function UIDailyQuestLayout:InitLocalization()
    self.config.textTittle.text = LanguageUtils.LocalizeCommon("daily_quest")
end

function UIDailyQuestLayout:OnShow()
    UIQuestLayout.OnShow(self)
    --- @type NewDailyQuestInBound
    self.dailyQuestInBound = self.questDataInBound.newDailyQuestInBound
    self.eventPassModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    self.isOpening = (self.eventPassModel ~= nil and self.eventPassModel.timeData:IsOpening())

    if self.isOpening == true then
        --- @type GrowthPackLineConfig
        self.growthPackLineConfig = ResourceMgr.EventDailyQuestPassConfig():GetConfig(self.eventPassModel.timeData.dataId)
    end

    self:ShowData()
    self.config.miniBar.gameObject:SetActive(false)
end

function UIDailyQuestLayout:SetData()
    self.view.listQuestData = self.dailyQuestInBound:GetListDailyQuestData()
    self.view.listQuestData = QuestDataInBound.SortQuestByData(self.view.listQuestData)
end

function UIDailyQuestLayout:ShowData()
    self:SetData()
    self.uiScroll:Resize(self.view.listQuestData:Count())
end

function UIDailyQuestLayout:ShowProgressDailyPass()
    local number = InventoryUtils.GetMoney(MoneyType.EVENT_DAILY_QUEST_PASS_POINT)
    local numberReq = 0
    for i = 1, self.growthPackLineConfig.listMilestone:Count() do
        --- @type GrowthMilestoneConfig
        local growthMilestoneConfig = self.growthPackLineConfig.listMilestone:Get(i)
        local numberMileStone = growthMilestoneConfig.number
        if numberMileStone >= number then
            numberReq = numberMileStone
            break
        end
    end

    self.config.textProgress.text = string.format("%d/%d", number, numberReq)
    self.config.bgMiniBarProgressBar2.fillAmount = number / numberReq
    self.config.bgMiniBarProgressBarFull.gameObject:SetActive(self.config.bgMiniBarProgressBar2.fillAmount >= 1)
    self.config.notiMiniBar.gameObject:SetActive(self.config.bgMiniBarProgressBar2.fillAmount >= 1)
    self.config.bgMiniBar.gameObject:SetActive(self.config.bgMiniBarProgressBar2.fillAmount >= 1)
    self.config.bgMiniBarComplete.gameObject:SetActive(self.config.bgMiniBarProgressBar2.fillAmount < 1)

    if self.coroutine ~= nil then
        Coroutine.stop(self.coroutine)
        self.config.miniBar.gameObject:SetActive(false)
    end

    self.coroutine = Coroutine.start(function()
        self.config.miniBar.gameObject:SetActive(true)
        coroutine.waitforseconds(3.5)
        self.config.miniBar.gameObject:SetActive(false)
        self.coroutine = nil
    end)
end

function UIDailyQuestLayout:RefreshView()
    self:SetData()
    self.uiScroll:RefreshCells()
end

--- @param questId number
function UIDailyQuestLayout:OnClaimSuccess(questId)
    QuestDataInBound.SetCompleteQuestById(self.view.listQuestData, questId, self.opCodeClaim)
    self:RefreshView()
    if self.isOpening == true then
        self:ShowProgressDailyPass()
    end
    RxMgr.notificationRequestQuest:Next()
end

function UIDailyQuestLayout:SetUpLayout()
    self.config.scroll.gameObject:SetActive(true)
    self.config.titleGroup.gameObject:SetActive(true)
    self:InitQuest()
end

function UIDailyQuestLayout:InitQuest()
    self.view.questConfig = ResourceMgr.GetQuestConfig():GetNewDailyQuest()
    ----- @type Dictionary
    --local bonusReward = Dictionary()
    --local listReward = List()
    --if zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY) ~= nil then
    --    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(DAILY_QUEST_PASS_BOSS_REWARD)
    --    for i = 1, #parsedData do
    --        local questId = parsedData[i].quest_id
    --        if questId ~= nil then
    --            listReward = List()
    --            listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
    --            bonusReward:Add(parsedData[i].id,listReward)
    --        else
    --            listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
    --        end
    --    end
    --end
    ----- @param key number
    ----- @param value QuestElementConfig
    --for key, value in pairs(self.view.questConfig:GetItems()) do
    --    value:AddListResData(bonusReward:Get(key))
    --end
end

function UIDailyQuestLayout:GetExtraReward(questId)
--[[    --- @type EventEasterEggModel
    local eventEasterEggModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_EGG)
    if eventEasterEggModel and eventEasterEggModel:IsOpening() then
        local dataId = eventEasterEggModel.timeData.dataId
        --- @type EventEasterEggConfig
        local eventEasterEggConfig = ResourceMgr.GetEventConfig():GetData(EventTimeType.EVENT_EASTER_EGG, dataId)
        return eventEasterEggConfig:GetDailyQuestBonusReward(dataId, questId)
    end]]
    --- @type EventDailyQuestPassModel
    local eventBirthdayModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
    if eventBirthdayModel and eventBirthdayModel:IsOpening() then
        local dataId = eventBirthdayModel.timeData.dataId
        return ResourceMgr.EventBirthdayConfig():GetDailyQuestBonusReward(dataId, questId)
    end

    --- @type EventDailyQuestPassModel
    local eventLunarNewYearModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_NEW_YEAR_2022)
    if eventLunarNewYearModel and eventLunarNewYearModel:IsOpening() then
        local dataId = eventLunarNewYearModel.timeData.dataId
        return ResourceMgr.GetEventLunarNewYearConfig():GetDailyQuestBonusReward(dataId, questId)
    end

    --- @type EventDailyQuestPassModel
    local eventDailyQuestPassModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_DAILY_QUEST_PASS)
    if eventDailyQuestPassModel and eventDailyQuestPassModel:IsOpening() then
        local dataId = eventDailyQuestPassModel.timeData.dataId
        return ResourceMgr.EventDailyQuestPassConfig():GetDailyQuestBonusReward(dataId, questId)
    end

    --- @type EventDailyQuestPassModel
    local eventSeasonalModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SEASONAL)
    if eventSeasonalModel and eventSeasonalModel:IsOpening() then
        local dataId = eventSeasonalModel.timeData.dataId
        return ResourceMgr.GetEventSeasonalConfig():GetDailyQuestBonusReward(dataId, questId)
    end

    return nil
end

function UIDailyQuestLayout:OnHide()
    UIQuestLayout.OnHide(self)
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end
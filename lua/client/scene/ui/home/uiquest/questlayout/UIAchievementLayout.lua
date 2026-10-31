require "lua.client.scene.ui.home.uiQuest.questLayout.UIAchievementLayoutModel"

--- @class UIAchievementLayout : UIQuestLayout
UIAchievementLayout = Class(UIAchievementLayout, UIQuestLayout)

local UIAchievementTab = {
    LINKING_POWER = 1,
    LIFE_AND_DEATH = 2,
    SUMMONER_STRATEGY = 3,
    ENORMOUS_CHALLENGE = 4,
    OTHERS = 5,
}

--- @param view UIQuestView
--- @param opCodeClaim OpCode
function UIAchievementLayout:Ctor(view, opCodeClaim)
    --- @type Dictionary
    self.tabDict = Dictionary()
    UIQuestLayout.Ctor(self, view, opCodeClaim)
    --- @type UIAchievementLayoutModel
    self.layoutModel = UIAchievementLayoutModel()
    --- @type AchievementQuestInBound
    self.achievementQuestInBound = nil
end

function UIAchievementLayout:_InitConfig()
    --- @type UIAchievementLayoutConfig
    self.layoutConfig = UIBaseConfig(self.config.achivementLayout)
    self:_InitTabs()
end

function UIAchievementLayout:_InitTabs()
    self.selectTab = function(currentTab)
        self:OnSelectAchievementGroup(currentTab)
        --- @param v UITabItem
        for k, v in pairs(self.tabDict:GetItems()) do
            v:SetTabState(k == currentTab)
        end
    end
    local addTab = function(uiAchievementTab)
        local uiTabIndex = UIAchievementLayout.GetTabUiIndexByAchievementGroup(uiAchievementTab)
        self.tabDict:Add(uiAchievementTab, UITabItem(self.layoutConfig.tabAchievement:GetChild(uiTabIndex),
                self.selectTab, function()
                    return QuestDataInBound.GetAchievementGroupNameById(uiAchievementTab)
                end, uiAchievementTab))
    end
    addTab(UIAchievementTab.LINKING_POWER)
    addTab(UIAchievementTab.LIFE_AND_DEATH)
    addTab(UIAchievementTab.SUMMONER_STRATEGY)
    addTab(UIAchievementTab.ENORMOUS_CHALLENGE)
    addTab(UIAchievementTab.OTHERS)
end

function UIAchievementLayout:OnShow()
    UIQuestLayout.OnShow(self)
    self.achievementQuestInBound = self.questDataInBound.achievementQuestInBound
    self.layoutModel:SetAchievementData(self.achievementQuestInBound:GetListAchievementData())
    self:CheckTabNotify()
    self.selectTab(UIAchievementTab.LINKING_POWER)
end

function UIAchievementLayout:SetUpLayout()
    self.config.achivementLayout.gameObject:SetActive(true)
    self.config.scroll.gameObject:SetActive(true)
    self.view.questConfig = ResourceMgr.GetQuestConfig():GetAchievement()
end

function UIAchievementLayout:OnHide()
    UIQuestLayout.OnHide(self)
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
    self.achievementQuestInBound:CheckNotification()
    RxMgr.notificationRequestQuest:Next()
end

--- @param currentTab number
function UIAchievementLayout:OnSelectAchievementGroup(currentTab)
    self.currentTab = currentTab
    self:ShowData()
end

function UIAchievementLayout:SetData()
    self.view.listQuestData = self.layoutModel.tabAchievementDict:Get(self.currentTab)
    if self.view.listQuestData == nil then
        XDebug.Error("No Achievement by group " .. self.currentTab)
        return
    end
    self.view.listQuestData = QuestDataInBound.SortQuestByData(self.view.listQuestData)
end

function UIAchievementLayout:ShowData()
    self:SetData()
    self.uiScroll:Resize(self.view.listQuestData:Count())
end

function UIAchievementLayout:RefreshView()
    self:SetData()
    self.uiScroll:RefreshCells()
end

--- @param questId number
function UIAchievementLayout:OnClaimSuccess(questId)
    local listAchievement = self.achievementQuestInBound:GetListAchievementData()
    QuestDataInBound.SetCompleteQuestById(listAchievement, questId, self.opCodeClaim)
    self.layoutModel:SetAchievementData(listAchievement)
    self:RefreshView()
    self:CheckTabNotify()
    RxMgr.notificationRequestQuest:Next()
end

function UIAchievementLayout:CheckTabNotify()
    self:EnableTabNotification(UIAchievementTab.LINKING_POWER, self.layoutModel:IsHasAchievementNotifyByTab(UIAchievementTab.LINKING_POWER))
    self:EnableTabNotification(UIAchievementTab.LIFE_AND_DEATH, self.layoutModel:IsHasAchievementNotifyByTab(UIAchievementTab.LIFE_AND_DEATH))
    self:EnableTabNotification(UIAchievementTab.SUMMONER_STRATEGY, self.layoutModel:IsHasAchievementNotifyByTab(UIAchievementTab.SUMMONER_STRATEGY))
    self:EnableTabNotification(UIAchievementTab.ENORMOUS_CHALLENGE, self.layoutModel:IsHasAchievementNotifyByTab(UIAchievementTab.ENORMOUS_CHALLENGE))
    self:EnableTabNotification(UIAchievementTab.OTHERS, self.layoutModel:IsHasAchievementNotifyByTab(UIAchievementTab.OTHERS))
end

--- @param uiAchievementTab number
--- @param isEnableNotify boolean
function UIAchievementLayout:EnableTabNotification(uiAchievementTab, isEnableNotify)
    --- @type UITabItem
    local uiTabItem = self.tabDict:Get(uiAchievementTab)
    uiTabItem:EnableNotify(isEnableNotify)
end

function UIAchievementLayout.GetTabUiIndexByAchievementGroup(uiAchievementTab)
    return 5 - uiAchievementTab
end

function UIAchievementLayout:InitLocalization()
    UIQuestLayout.InitLocalization(self)
    if self.tabDict ~= nil then
        --- @param v UITabItem
        for _, v in pairs(self.tabDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

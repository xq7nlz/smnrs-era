require "lua.client.scene.ui.home.uiEventPuzzle.eventLayout.UIEventPuzzleLayout"
--- @class UIPuzzleQuestLayout : UIEventPuzzleLayout
UIPuzzleQuestLayout = Class(UIPuzzleQuestLayout, UIEventPuzzleLayout)

--- @param view UIEventPuzzleView
--- @param EventPuzzleTab EventPuzzleTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIPuzzleQuestLayout:Ctor(view, EventPuzzleTab, anchor,noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    UIEventPuzzleLayout.Ctor(self, view, EventPuzzleTab,anchor)
    self:InitLayoutConfig()
    self:CreateQuestList()
    --- @type boolean
    self.hasNoti = self:HasNoti()
end

--- @param objectView UnityEngine_GameObject
function UIPuzzleQuestLayout:InitLayoutConfig(objectView)
    local inst = PrefabLoadUtils.Instantiate("puzzle_quest_layout", self.anchor)
    UIEventPuzzleLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
end

function UIPuzzleQuestLayout:InitLocalization()
end

function UIPuzzleQuestLayout:SetUpLayout()
    UIEventPuzzleLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIPuzzleQuestLayout:InitButtons()

end

function UIPuzzleQuestLayout:OnShow()
    UIEventPuzzleLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
end

function UIPuzzleQuestLayout:HasNoti()
    return self:OnUpdateListQuest()
end

function UIPuzzleQuestLayout:OnHide()
    UIEventPuzzleLayout.OnHide(self)
end


function UIPuzzleQuestLayout:CreateQuestList()
    if self.listQuestData:Count() < 1 then
        self.listQuestData = self.eventModel.listQuestData
    end
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
            self:OnClickClaim(questUnitInBound.questId,questUnitInBound.config._questType, questUnitInBound)
        end)
        obj.config.specialDeal:SetActive(questUnitInBound.config.isSpecial)
        if (questUnitInBound.config.isSpecial) then
            self.updateQuestList:Add(obj.config.textEventSpecialTime)
        end
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.UIEventPuzzleQuestItem, onCreateItem)
    self.uiScroll:Resize(self.listQuestData:Count())
end


function UIPuzzleQuestLayout:OnClickClaim(questId,type,questUnitInBound)
    local opcode = OpCode.EVENT_PUZZLE_QUEST_CLAIM
    if type == QuestType.PURCHASE_PACKAGE and questId > 100 then
        opcode = OpCode.EVENT_PUZZLE_SPECIAL_QUEST_CLAIM
    end
    QuestDataInBound.RequestClaimQuest(opcode , questId,
            function(rewardList)
                TrackingUtils.AddFirebaseEventWithArgs(FBEvents.EARN_RESOURCE,
                        FBEvents.ITEM_BRAND, questUnitInBound.config:GetMainRewardData().type,
                        FBEvents.ITEM_ID, questUnitInBound.config:GetMainRewardData().id,
                        FBEvents.VALUE, questUnitInBound.config:GetMainRewardData().number,
                        FBEvents.SOURCE, "event_puzzle_quest_claim",
                        FBEvents.SOURCE_ID, questUnitInBound.config.orderInGroup)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

function UIPuzzleQuestLayout:OnClaimQuestSuccess(questId)
    self:GetModelConfig()
    self.eventModel:OnClaimQuestSuccess(questId)
    self:OnUpdateListQuest()
    self.view:UpdateNotificationAllTab()
end

function UIPuzzleQuestLayout:UpdateNotification()
    self.listQuestData = self.view.eventModel.listQuestData
    self:FilterTabQuest()
    local noti = false
    for i = 1, self.listQuestData:Count() do
        --- @type QuestUnitInBound
        local quest = self.listQuestData:Get(i)
        if quest.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            noti = true
        end
    end
    self.noti:SetActive(noti)
    return  noti
end


function UIPuzzleQuestLayout:OnUpdateListQuest()
    self.listQuestData = self.eventModel.listQuestData
    self:FilterTabQuest()
    self.uiScroll:Resize(self.listQuestData:Count())
end

function UIPuzzleQuestLayout:FilterTabQuest()
    local questCount = self.listQuestData:Count()
    for i = questCount, 1, -1 do
        --- @type QuestUnitInBound
        local questUnitData = self.listQuestData:Get(i)
        if questUnitData.questState == QuestState.HIDDEN then
            self.listQuestData:RemoveByIndex(i)
        end
    end
end

function UIPuzzleQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(UIPopupName.UIEventPuzzle)
    end)
end
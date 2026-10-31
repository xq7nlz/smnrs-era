--- @class UIEventQuestLayout : UIEventLayout
UIEventQuestLayout = Class(UIEventQuestLayout, UIEventLayout)

local cellSize = U_Vector2(1470, 195)
local spacing = U_Vector2(0, 10)

--- @param eventModel EventPopupQuestModel
function UIEventQuestLayout:OnShow(eventModel)
    --- @type EventPopupQuestModel
    self.eventPopupQuestModel = eventModel
    UIEventLayout.OnShow(self, eventModel)
    self:ResizeLoopScrollContent(self.eventPopupQuestModel:GetAllData():Count())
end

function UIEventQuestLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self:InitScrollContentQuest()
    self:ResizeLoopScrollContent(self.eventPopupQuestModel:GetAllData():Count())
    self.eventPopupQuestModel:SortListQuestData()
    self.view:SetGridContentSize(cellSize, spacing, 1)
    if self.eventPopupQuestModel.totalRound == 1 then
        self.config.textRound.text = ""
    else
        self.config.textRound.text = string.format("%s: (%d/%d)",
                LanguageUtils.LocalizeCommon("round"),
                self.eventPopupQuestModel.currentRound,
                self.eventPopupQuestModel.totalRound)
    end
end

function UIEventQuestLayout:InitScrollContentQuest()
    if self.eventPopupQuestModel:GetAllData():Count() > 0 then
        --- @param obj UIEventQuestItem
        --- @param index number
        local onCreateItem = function(obj, index)
            local dataIndex = index + 1
            --- @type QuestUnitInBound
            local questData = self.eventPopupQuestModel:GetDataByIndexOfList(dataIndex)
            obj:SetData(questData.config, questData)
            if questData.config:IsFeatureMappingAvailable() then
                obj:AddGoListener(function()
                    self:OnClickGo(questData.questId, questData.config)
                end)
            end
        end
        self.view.scrollLoopContent = UILoopScroll(self.config.VerticalScrollContent, UIPoolType.EventQuestItem, onCreateItem)
        self.view.scrollLoopContent:SetUpMotion(MotionConfig())
    else
        XDebug.Warning("Quest data count = 0")
    end
end

function UIEventQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.model.uiName)
    end)
end

function UIEventQuestLayout:OnHide()
    UIEventLayout.OnHide(self)
    UIEventLayout.EnableLoopScrollContent(self, false)
end

require "lua.client.scene.ui.home.uiDungeonMain.uiPreviewHeroDungeon.UIPreviewHeroDungeon"

--- @class UIDungeonClosedView : UIBaseView
UIDungeonClosedView = Class(UIDungeonClosedView, UIBaseView)

--- @return void
--- @param model UIDungeonClosedModel
function UIDungeonClosedView:Ctor(model, ctrl)
    --- @type UIDungeonClosedConfig
    self.config = nil
    --- @type UIPreviewHeroDungeon
    self.previewHeroDungeon = nil
    -- init variables here
    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIDungeonClosedModel
    self.model = model
end

--- @return void
function UIDungeonClosedView:OnReadyCreate()
    ---@type UIDungeonClosedConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:InitPreviewDungeon()
    self:InitButtonListener()
    self:InitUpdateTime()
end

--- @return void
function UIDungeonClosedView:InitLocalization()
    self.config.titleClosed.text = LanguageUtils.LocalizeCommon("closed")
end

--- @return void
function UIDungeonClosedView:InitPreviewDungeon()
    local transform = SmartPool.Instance:SpawnTransform(AssetType.UI, "preview_hero_dungeon")
    transform.position = U_Vector3(-1000, 0, 0)
    self.previewHeroDungeon = UIPreviewHeroDungeon(transform, self.model, self)
end

--- @return void
function UIDungeonClosedView:InitButtonListener()
    self.config.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        local info = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeHelpInfo("dungeon_info"), 50, 50)
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
    end)

    self.config.buttonLeaderBoard.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupUtils.ShowLeaderBoard(LeaderBoardType.DUNGEON)
    end)

    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIDungeonClosedView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.config.textOpenTime.text = string.format("%s %s",
                UIUtils.SetColorString(UIUtils.white, LanguageUtils.LocalizeCommon("will_open_in")),
                UIUtils.SetColorString(UIUtils.color2, TimeUtils.SecondsToClock(self.timeRefresh))
        )
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            local eventTimes = zg.playerData:GetEvents()
            eventTimes.lastTimeGetEventPopupModel = nil
            ---@type EventPopupModel
            local eventPopupModel = zg.playerData:GetEvents():GetEvent(EventTimeType.DUNGEON)
            if eventPopupModel:IsOpening() == true then
                PopupMgr.ShowPopup(UIPopupName.UIDungeonFormation, nil, UIPopupHideType.HIDE_ALL)
            end
        end
    end
end

function UIDungeonClosedView:SetTimeRefresh()
    ---@type EventTimeData
    local eventTime = zg.playerData:GetEvents():GetEvent(EventTimeType.DUNGEON):GetTime()
    self.timeRefresh = eventTime.startTime - zg.timeMgr:GetServerTime()
end

function UIDungeonClosedView:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

--- @return void
function UIDungeonClosedView:StartRefreshTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
    UIUtils.AlignText(self.config.textOpenTime)
end

--- @return void
function UIDungeonClosedView:OnReadyShow()
    self.previewHeroDungeon:OnShow()
    self:StartRefreshTime()
end

--- @return void
function UIDungeonClosedView:Hide()
    self:RemoveUpdateTime()
    self.previewHeroDungeon:OnHide()
    UIBaseView.Hide(self)
end

function UIDungeonClosedView:OnClickBackOrClose()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
end
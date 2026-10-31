--- @class UIDefenseStageRecordListView : UIBaseView
UIDefenseStageRecordListView = Class(UIDefenseStageRecordListView, UIBaseView)

--- @return void
--- @param model UIDefenseStageRecordListModel
function UIDefenseStageRecordListView:Ctor(model)
    --- @type UIDefenseStageRecordListConfig
    self.config = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    UIBaseView.Ctor(self, model)
    --- @type UIDefenseStageRecordListModel
    self.model = model
end

--- @return void
function UIDefenseStageRecordListView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtonListener()
    self:InitScroll()
end

function UIDefenseStageRecordListView:InitLocalization()
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
end

function UIDefenseStageRecordListView:InitButtonListener()
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIDefenseStageRecordListView:InitScroll()
    --- @param obj UITowerRecordItem
    local onCreateItem = function(obj, index)
        index = index + 1
        local defenseBasicRecordInBound = self.listRecordItem:Get(index)
        obj:SetDataDefense(defenseBasicRecordInBound)
        obj:AddOnReplayListener(function()
            self:OnClickDetail(defenseBasicRecordInBound)
        end)
    end
    self.uiScroll = UILoopScroll(self.config.scrollRecord, UIPoolType.UITowerRecordItem, onCreateItem)
end

--- @param data {land, stage, isPlayerRecord}
function UIDefenseStageRecordListView:OnReadyShow(data)
    --- @type {land, stage, isPlayerRecord}
    self.data = data
    self.config.empty:SetActive(false)
    if data.isPlayerRecord then
        self.config.localizeTittle.text = LanguageUtils.LocalizeCommon("player_stage_record")
    else
        self.config.localizeTittle.text = LanguageUtils.LocalizeCommon("stage_record")
    end
    --- @type DefenseModeInbound
    local defenseModeInBound = zg.playerData:GetMethod(PlayerDataMethod.DEFENSE_MODE)
    self.defenseRecordData = defenseModeInBound.defenseRecordData

    local onListRecordLoaded = function(listRecordItem)
        --- @type List
        self.listRecordItem = listRecordItem
        if self.listRecordItem then
            local recordCount = self.listRecordItem:Count()
            self.uiScroll:Resize(recordCount)
            self.config.empty:SetActive(recordCount == 0)
        end
    end
    self.defenseRecordData:GetListStageRecord(data.isPlayerRecord, data.land, data.stage, onListRecordLoaded)
end

function UIDefenseStageRecordListView:Hide()
    UIBaseView.Hide(self)
    self.uiScroll:Hide()
end

--- @param defenseBasicRecordInBound DefenseBasicRecordInBound
function UIDefenseStageRecordListView:OnClickDetail(defenseBasicRecordInBound)
    local onReceived = function(result)
        require("lua.client.core.network.defenseMode.DefenseBattleRecordInBound")
        ---@type DefenseBattleRecordInBound
        local defenseBattleRecordInBound = nil
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            defenseBattleRecordInBound = DefenseBattleRecordInBound(buffer)
        end
        local onSuccess = function()
            zg.playerData.rewardList = nil
            --- @type DefenseModeInbound
            local defenseModeInbound = zg.playerData:GetMethod(PlayerDataMethod.DEFENSE_MODE)
            if defenseModeInbound.defenseRecordData.selectedData == nil then
                defenseModeInbound.defenseRecordData.selectedData = {}
            end
            defenseModeInbound.defenseRecordData.selectedData.land = self.data.land
            defenseModeInbound.defenseRecordData.selectedData.stage = self.data.stage

            ---@type LandConfig
            local landConfig = ResourceMgr.GetDefenseModeConfig():GetLandConfig(self.data.land)
            ---@type List
            local listAttackerTeamStageConfig = landConfig:GetListAttackerTeamStageConfig(self.data.stage)
            defenseModeInbound.defenseChallengeResultInBound = defenseBattleRecordInBound
            defenseModeInbound.defenseChallengeResultInBound:RunTheFirstBattle(listAttackerTeamStageConfig)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.DEFENSE_RECORD_DETAIL_GET, UnknownOutBound.CreateInstance(PutMethod.Short, self.data.land,
            PutMethod.Int, self.data.stage, PutMethod.String, defenseBasicRecordInBound.recordId), onReceived)
end
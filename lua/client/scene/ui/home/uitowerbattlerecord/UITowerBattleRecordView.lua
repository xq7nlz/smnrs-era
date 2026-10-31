---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiTowerBattleRecord.UITowerBattleRecordConfig"

--- @class UITowerBattleRecordView : UIBaseView
UITowerBattleRecordView = Class(UITowerBattleRecordView, UIBaseView)

--- @return void
--- @param model UITowerBattleRecordModel
function UITowerBattleRecordView:Ctor(model)
    --- @type UITowerBattleRecordConfig
    self.config = nil
    --- @type UnityEngine_UI_LoopVerticalScrollRect
    self.scrollRecord = nil
    --- @type TowerInBound
    self.towerInBound = nil
    --- @type TowerRecordInBound
    self.record = nil
    UIBaseView.Ctor(self, model)
    --- @type UITowerBattleRecordModel
    self.model = model
end

--- @return void
function UITowerBattleRecordView:OnReadyCreate()
    ---@type UITowerBattleRecordConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:_InitButtonListener()
    self:_InitScroll()
end

function UITowerBattleRecordView:InitLocalization()
    self.config.localizeTittle.text = LanguageUtils.LocalizeCommon("record")
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
end

function UITowerBattleRecordView:_InitButtonListener()
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UITowerBattleRecordView:_InitScroll()
    --- @param obj UITowerRecordItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type TowerRecord
        local towerRecord = self.record:GetRecord(dataIndex)
        obj:SetData(towerRecord)
        obj:AddOnReplayListener(function()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            self:OnReplayRecord(towerRecord)
        end)
    end
    self.scrollRecord = UILoopScroll(self.config.scrollRecord, UIPoolType.UITowerRecordItem, onCreateItem)
end

--- @param selectedLevel number
function UITowerBattleRecordView:OnReadyShow(selectedLevel)
    self.towerInBound = zg.playerData:GetMethod(PlayerDataMethod.TOWER)
    self.towerInBound.selectedLevel = selectedLevel
    self.record = self.towerInBound:GetCacheRecord(selectedLevel)
    if self.record.listBattleRecord ~= nil and self.record.listBattleRecord:Count() > 0 then
        self.config.empty:SetActive(false)
    else
        self.config.empty:SetActive(true)
    end
    self:ShowRecordData()
end

function UITowerBattleRecordView:ShowRecordData()
    self.scrollRecord:Resize(self.record:TotalRecord())
end

function UITowerBattleRecordView:OnReadyHide()
    UIBaseView.OnReadyHide(self)
    self.scrollRecord:Hide()
end

--- @param towerRecord TowerRecord
function UITowerBattleRecordView:OnReplayRecord(towerRecord)
    local attackerTeamInfo = towerRecord.attackerTeam:CreateBattleTeamInfo()
    --- @return DefenderTeamData
    local defenderTeamData = ResourceMgr.GetTowerConfig().levelConfig:GetTowerLevelConfigById(self.towerInBound.selectedLevel)
    ---@type BattleTeamInfo
    local defenderTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(defenderTeamData)
    local randomHelper = RandomHelper()
    randomHelper:SetSeed(towerRecord.seed)
    zg.battleMgr:RunVirtualBattle(attackerTeamInfo, defenderTeamInfo, GameMode.TOWER_RECORD, randomHelper, RunMode.FASTEST, towerRecord.battleLog)
    if ClientBattleData.battleResult.winnerTeam ~= BattleConstants.ATTACKER_TEAM_ID then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("play_record_failed"))
        self.record.listBattleRecord:RemoveByReference(towerRecord)
        self:ShowRecordData()
        return
    end
    self:OnReadyHide()

    zg.playerData.rewardList = nil
    zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
    ClientBattleData.skipForReplay = true
    randomHelper:SetSeed(towerRecord.seed)
    zg.battleMgr:RunCalculatedBattleScene(attackerTeamInfo, defenderTeamInfo, GameMode.TOWER_RECORD, randomHelper, nil, towerRecord.battleLog)
end
--- @class UIArenaTeamLogView : UIBaseView
UIArenaTeamLogView = Class(UIArenaTeamLogView, UIBaseView)

--- @return void
--- @param model UIArenaTeamLogModel
function UIArenaTeamLogView:Ctor(model)
    --- @type UIArenaTeamLogConfig
    self.config = nil
    --- @type ItemsTableView
    self.itemsTableView = nil
    --- @type List
    self.listData = List()
    UIBaseView.Ctor(self, model)
    --- @type UIArenaTeamLogModel
    self.model = model
end

--- @return void
function UIArenaTeamLogView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self.itemsTableView = ItemsTableView(self.config.tableView, nil, UIPoolType.ArenaTeamLogItem)

    self:InitButtons()
end

function UIArenaTeamLogView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("detail")
end

function UIArenaTeamLogView:InitButtons()
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIArenaTeamLogView:OnReadyShow(data)
    self.isVictory = data

    self.battleMgr = zg.battleMgr
    self.arenaData = zg.playerData:GetArenaData()
    self.arenaTeamBattleData = self.arenaData.arenaTeamBattleData

    self.config.attackerName.text = self.battleMgr.attacker.name
    self.config.defenderName.text = self.battleMgr.defender.name

    self:CreateListData()
    self.itemsTableView:SetData(self.listData)
    self.itemsTableView:SetSize(1000, 140)

    self:ShowScoreChange()
end

function UIArenaTeamLogView:ShowScoreChange()
    local color = UIUtils.red_dark
    local signChar = "-"
    if self.isVictory == true then
        color = UIUtils.green_dark
        signChar = "+"
    end
    self.config.attackerPointChange.text = string.format("%s <color=#%s>(%s%s)</color>",
            self.battleMgr.attacker.score, color,
            signChar, self.battleMgr.attacker.scoreChange)

    color = UIUtils.red_dark
    signChar = "-"
    if self.isVictory == false then
        color = UIUtils.green_dark
        signChar = "+"
    end
    self.config.defenderPointChange.text = string.format("%s <color=#%s>(%s%s)</color>",
            self.battleMgr.defender.score, color,
            signChar, self.battleMgr.defender.scoreChange)
end

function UIArenaTeamLogView:Hide()
    UIBaseView.Hide(self)
    self.itemsTableView:Hide()
end

function UIArenaTeamLogView:CreateListData()
    self.listData:Clear()

    local gameMode = self.battleMgr.gameMode
    if gameMode == GameMode.ARENA_TEAM then
        --- @param v ArenaTeamBattleResultInfo || BattleResultInBound
        for k, v in pairs(self.arenaData.arenaTeamChallengeInBound.battleResults:GetItems()) do
            local dataItem = {}
            dataItem.match = k
            dataItem.isWin = self.arenaData.arenaTeamChallengeInBound:IsWin(k)
            dataItem.attacker = self.battleMgr.attacker
            dataItem.defender = self.battleMgr.defender
            dataItem.onClickDetail = function()
                local data = self.arenaData:GetBattleDetail(k)
                PopupMgr.ShowPopup(UIPopupName.UIBattleLog, data)
            end
            self.listData:Add(dataItem)
        end
    else
        --- @param v {battleResult : BattleResult, clientLogDetail: ClientLogDetail}
        for k, v in pairs(self.arenaData.battleDetailDict:GetItems()) do
            local dataItem = {}
            dataItem.match = k
            dataItem.isWin = v.battleResult.winnerTeam == BattleConstants.ATTACKER_TEAM_ID

            dataItem.attacker = self.battleMgr.attacker
            dataItem.defender = self.battleMgr.defender
            dataItem.onClickDetail = function()
                local data = self.arenaData:GetBattleDetail(k)
                PopupMgr.ShowPopup(UIPopupName.UIBattleLog, data)
            end
            self.listData:Add(dataItem)
        end
    end
end
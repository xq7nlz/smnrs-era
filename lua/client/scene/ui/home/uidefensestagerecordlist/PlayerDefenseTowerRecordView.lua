--- @class PlayerDefenseTowerRecordView
PlayerDefenseTowerRecordView = Class(PlayerDefenseTowerRecordView)

function PlayerDefenseTowerRecordView:Ctor(anchor, towerId)
    --- @type PlayerTowerRecordConfig
    self.config = UIBaseConfig(anchor)
    self.towerId = towerId

    self:Init()
end

function PlayerDefenseTowerRecordView:Init()
    --- @type BattleTeamView
    self.battleTeamView = BattleTeamView(self.config.teamAnchor)
end

--- @param defenseRecordFormationInBound DefenseRecordFormationInBound
function PlayerDefenseTowerRecordView:OnShow(playerLevel, defenseRecordFormationInBound)
    self.playerLevel = playerLevel
    self.config.textTower.text = string.format("%s %s", LanguageUtils.LocalizeCommon("tower"), self.towerId)

    if defenseRecordFormationInBound then
        self:ShowFormation(defenseRecordFormationInBound)
    else
        self:ShowEmptyTowerState()
    end
end

--- @param defenseRecordFormationInBound DefenseRecordFormationInBound
function PlayerDefenseTowerRecordView:ShowFormation(defenseRecordFormationInBound)
    self.config.textTowerLevel.text = string.format("%s %s", LanguageUtils.LocalizeCommon("level"), defenseRecordFormationInBound.towerLevel)

    --- @type BattleTeamInfo
    local battleTeamInfo = defenseRecordFormationInBound:GetBattleTeamInfo(self.playerLevel)
    battleTeamInfo.summonerBattleInfo.level = self.playerLevel
    battleTeamInfo.summonerBattleInfo.star = defenseRecordFormationInBound.summonerStar

    self.battleTeamView:Show()
    self.battleTeamView:SetDataDefender(UIPoolType.HeroIconView, battleTeamInfo, nil)
    self.battleTeamView.uiTeamView:SetSummonerInfo(battleTeamInfo.summonerBattleInfo)
    self.battleTeamView.uiTeamView:ActiveBuff(false)
    self.battleTeamView.uiTeamView:ActiveLinking(false)
end

function PlayerDefenseTowerRecordView:ShowEmptyTowerState()
    self.config.textTowerLevel.text = LanguageUtils.LocalizeCommon("lock")
end

function PlayerDefenseTowerRecordView:OnHide()
    self.battleTeamView:Hide()
end
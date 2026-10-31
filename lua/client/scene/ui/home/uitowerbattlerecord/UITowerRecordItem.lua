--- @class UITowerRecordItem : IconView
UITowerRecordItem = Class(UITowerRecordItem, IconView)

--- @return void
function UITowerRecordItem:Ctor()
    --- @type BattleTeamView
    self.battleTeamView = nil
    --- @type VipIconView
    self.vipIconView = nil
    IconView.Ctor(self)
end
--- @return void
function UITowerRecordItem:SetPrefabName()
    self.prefabName = 'ui_tower_record_item'
    self.uiPoolType = UIPoolType.UITowerRecordItem
end

--- @return void
--- @param transform UnityEngine_Transform
function UITowerRecordItem:SetConfig(transform)
    --- @type UITowerRecordItemConfig
    ---@type UITowerRecordItemConfig
    self.config = UIBaseConfig(transform)
    self.battleTeamView = BattleTeamView(self.config.battleTeamViewAnchor)
end

function UITowerRecordItem:InitLocalization()
    self.config.localizeReplay.text = LanguageUtils.LocalizeCommon("replay")
end

--- @param towerRecord TowerRecord
function UITowerRecordItem:SetData(towerRecord)
    local battleTeamInfo = towerRecord.attackerTeam:CreateBattleTeamInfo()
    battleTeamInfo.summonerBattleInfo.level = towerRecord.attackerTeam.playerLevel
    towerRecord.attackerTeam.summonerBattleInfoInBound.summonerBattleInfo.level = towerRecord.attackerTeam.playerLevel
    self.battleTeamView:Show()
    self.battleTeamView:SetDataDefender(UIPoolType.HeroIconView, battleTeamInfo)
    self.battleTeamView.uiTeamView:SetSummonerInfo(battleTeamInfo.summonerBattleInfo)
    self.battleTeamView.uiTeamView:ActiveBuff(false)
    self.battleTeamView.uiTeamView:ActiveLinking(false)

    self.config.playerName.text = towerRecord.attackerTeam.playerName
    if self.vipIconView == nil then
        self.vipIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.playerAvatarAnchor)
    end
    self.vipIconView:SetData2(towerRecord.attackerTeam.playerAvatar, towerRecord.attackerTeam.playerLevel)

    local cp = ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo)
    self.config.playerCp.text = tostring(math.floor(cp))
end

--- @param defenseBasicRecordInBound DefenseBasicRecordInBound
function UITowerRecordItem:SetDataDefense(defenseBasicRecordInBound)
    local battleTeamInfo = defenseBasicRecordInBound:GetBattleTeamInfo()
    battleTeamInfo.summonerBattleInfo.level = defenseBasicRecordInBound.playerLevel
    self.battleTeamView:Show()
    self.battleTeamView:SetDataDefender(UIPoolType.HeroIconView, battleTeamInfo)
    self.battleTeamView.uiTeamView:SetSummonerInfo(battleTeamInfo.summonerBattleInfo)
    self.battleTeamView.uiTeamView:ActiveBuff(false)
    self.battleTeamView.uiTeamView:ActiveLinking(false)

    self.config.playerName.text = defenseBasicRecordInBound.playerName
    if self.vipIconView == nil then
        self.vipIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.playerAvatarAnchor)
    end
    self.vipIconView:SetData2(defenseBasicRecordInBound.avatar, defenseBasicRecordInBound.playerLevel)

    self.config.playerCp.text = tostring(defenseBasicRecordInBound.defenseRecordFormationInBound.power)
end

--- @param func function
function UITowerRecordItem:AddOnReplayListener(func)
    self.config.buttonReplay.onClick:RemoveAllListeners()
    self.config.buttonReplay.onClick:AddListener(function ()
        if func ~= nil then
            func()
        end
    end)
end

function UITowerRecordItem:ReturnPool()
    IconView.ReturnPool(self)
    self.battleTeamView:Hide()
    if self.vipIconView ~= nil then
        self.vipIconView:ReturnPool()
        self.vipIconView = nil
    end
end

return UITowerRecordItem
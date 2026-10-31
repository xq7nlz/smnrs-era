require "lua.client.scene.ui.home.uiDefenseStageRecordList.PlayerDefenseTowerRecordView"

--- @class UIDefensePlayerRecordItem : IconView
UIDefensePlayerRecordItem = Class(UIDefensePlayerRecordItem, IconView)

--- @return void
function UIDefensePlayerRecordItem:Ctor()
    --- @type Dictionary
    self.playerDefenseTowerRecordViewDict = Dictionary()
    --- @type VipIconView
    self.vipIconView = nil
    IconView.Ctor(self)
end
--- @return void
function UIDefensePlayerRecordItem:SetPrefabName()
    self.prefabName = 'ui_defense_player_record_item'
    self.uiPoolType = UIPoolType.UIDefensePlayerRecordItem
end

--- @return void
--- @param transform UnityEngine_Transform
function UIDefensePlayerRecordItem:SetConfig(transform)
    --- @type UIDefensePlayerRecordItemConfig
    self.config = UIBaseConfig(transform)

    self:InitTowerTeamView()
end

function UIDefensePlayerRecordItem:InitTowerTeamView()
    local prefab = self.config.towerTeam.gameObject
    local addTowerTeamView = function(anchor, towerId)
        --- @type PlayerDefenseTowerRecordView
        local playerTowerRecordView = PlayerDefenseTowerRecordView(anchor, towerId)
        self.playerDefenseTowerRecordViewDict:Add(towerId, playerTowerRecordView)
    end
    addTowerTeamView(self.config.towerTeam, 1)
    local numberLand = ResourceMgr.GetDefenseModeConfig():GetBaseConfig().numberRoadMax
    for i = 2, numberLand do
        --- @type UnityEngine_GameObject
        local clone = U_GameObject.Instantiate(prefab, self.config.battleTeamViewAnchor)
        UIUtils.SetUIParent(clone.transform, self.config.battleTeamViewAnchor)
        clone.transform:SetAsLastSibling()
        addTowerTeamView(clone.transform, i)
    end
end

function UIDefensePlayerRecordItem:InitLocalization()
    self.config.textDetail.text = LanguageUtils.LocalizeCommon("detail")
end

--- @param defenseBasicRecordInBound DefenseBasicRecordInBound
function UIDefensePlayerRecordItem:SetData(defenseBasicRecordInBound)
    self.config.textTownCenterLevel.text = string.format("%s %s %s",
            LanguageUtils.LocalizeCommon("town_center"),
            LanguageUtils.LocalizeCommon("level"),
            defenseBasicRecordInBound.townCenterLevel)
    self.config.playerName.text = defenseBasicRecordInBound.playerName
    if self.vipIconView == nil then
        self.vipIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.playerAvatarAnchor)
    end
    self.vipIconView:SetData2(defenseBasicRecordInBound.avatar, defenseBasicRecordInBound.playerLevel)

    --- @param v PlayerDefenseTowerRecordView
    for k, v in pairs(self.playerDefenseTowerRecordViewDict:GetItems()) do
        local defenseRecordFormationInBound = defenseBasicRecordInBound:GetTowerFormation(k)
        v:OnShow(defenseBasicRecordInBound.playerLevel, defenseRecordFormationInBound)
    end
end

--- @param func function
function UIDefensePlayerRecordItem:AddOnDetailListener(func)
    self.config.buttonDetail.onClick:RemoveAllListeners()
    self.config.buttonDetail.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func ~= nil then
            func()
        end
    end)
end

function UIDefensePlayerRecordItem:ReturnPool()
    IconView.ReturnPool(self)
    if self.vipIconView ~= nil then
        self.vipIconView:ReturnPool()
        self.vipIconView = nil
    end
    --- @param v PlayerDefenseTowerRecordView
    for _, v in pairs(self.playerDefenseTowerRecordViewDict:GetItems()) do
        v:OnHide()
    end
end

return UIDefensePlayerRecordItem
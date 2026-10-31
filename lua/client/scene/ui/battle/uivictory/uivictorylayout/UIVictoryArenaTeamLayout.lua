--- @class UIVictoryArenaTeamLayout : UIVictoryLayout
UIVictoryArenaTeamLayout = Class(UIVictoryArenaTeamLayout, UIVictoryLayout)

function UIVictoryArenaTeamLayout:Ctor(view, anchor)
    --- @type AvatarGameOverView
    self.avatar1 = nil
    --- @type AvatarGameOverView
    self.avatar2 = nil
    UIVictoryLayout.Ctor(self, view, anchor)
end

function UIVictoryArenaTeamLayout:InitLayoutConfig()
    --- @type UIVictoryArenaLayoutConfig
    self.layoutConfig = UIBaseConfig(self.anchor)
end

function UIVictoryArenaTeamLayout:InitLocalization()
    UIVictoryLayout.InitLocalization(self)
    self.layoutConfig.textReward.text = LanguageUtils.LocalizeCommon("reward")
end

function UIVictoryArenaTeamLayout:SetUpLayout()
    UIVictoryLayout.SetUpLayout(self)
    self.config.rewardAnchor.anchoredPosition3D = U_Vector3(0, -364, 0)
end

--- @param data {}
function UIVictoryArenaTeamLayout:ShowData(data)
    local rewardList = zg.playerData.rewardList
    if zg.playerData ~= nil and zg.playerData:HasReward() then
        self.view:SetReward(rewardList)
    end
    self.layoutConfig.txtRewardContainer:SetActive(rewardList ~= nil and rewardList:Count() > 0 )
    local battleMgr = zg.battleMgr
    if battleMgr.attacker ~= nil and battleMgr.defender ~= nil then
        self:GetAvatar()

        local scoreChange = battleMgr.attacker.scoreChange
        AvatarGameOverView.SetAvatarGameOverView(self.avatar1, battleMgr.attacker.avatar,
                battleMgr.attacker.level,
                battleMgr.attacker.name,
                battleMgr.attacker.score,
                scoreChange)

        if battleMgr.defender.scoreChange ~= nil then
            scoreChange = -battleMgr.defender.scoreChange
        end

        AvatarGameOverView.SetAvatarGameOverView(self.avatar2, battleMgr.defender.avatar,
                battleMgr.defender.level,
                battleMgr.defender.name,
                battleMgr.defender.score,
                scoreChange)
    end
end

function UIVictoryArenaTeamLayout:GetAvatar()
    if self.avatar1 == nil then
        self.avatar1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.AvatarGameOverView, self.layoutConfig.avatar1)
    end
    if self.avatar2 == nil then
        self.avatar2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.AvatarGameOverView, self.layoutConfig.avatar2)
    end
end

function UIVictoryArenaTeamLayout:OnHide()
    UIVictoryLayout.OnHide(self)
    if self.avatar1 ~= nil then
        self.avatar1:ReturnPool()
        self.avatar1 = nil
    end
    if self.avatar2 ~= nil then
        self.avatar2:ReturnPool()
        self.avatar2 = nil
    end
    zg.battleMgr:ResetArenaPlayerData()
end

function UIVictoryArenaTeamLayout:OnClickBattleLog()
    PopupMgr.ShowPopup(UIPopupName.UIArenaTeamLog, true)
end

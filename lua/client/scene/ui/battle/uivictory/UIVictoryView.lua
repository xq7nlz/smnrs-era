require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryLayout"

--- @class UIVictoryView : UIBaseView
UIVictoryView = Class(UIVictoryView, UIBaseView)

--- @param model UIVictoryModel
function UIVictoryView:Ctor(model)
    --- @type UIVictoryConfig
    self.config = nil
    --- @type boolean
    self.isShowing = false
    --- @type ItemsTableView
    self.rewardTableView = nil
    --- @type UIVictoryLayout
    self.layout = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    UIBaseView.Ctor(self, model)
    --- @type UIVictoryModel
    self.model = model
end

function UIVictoryView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self.rewardTableView = ItemsTableView(self.config.rewardAnchor)
    self:_InitButtonListener()
end

function UIVictoryView:InitLocalization()
    --- @param v UIVictoryLayout
    for _, v in pairs(self.layoutDict:GetItems()) do
        v:InitLocalization()
    end
end

function UIVictoryView:_InitButtonListener()
    self.config.buttonBattleLog.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self.layout:OnClickBattleLog()
    end)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIVictoryView:OnClickBackOrClose()
    self.layout:OnClickBackOrClose()
end

--- @param data {gameMode : GameMode, isWin : boolean, result, clientLogDetail}
function UIVictoryView:OnReadyShow(data)
    if self.isShowing then
        return
    end
    self.model.isWin = data.isWin
    --- @type BattleResult
    self.model.battleResult = data.result
    self.model.clientLogDetail = data.clientLogDetail
    self:PlayEffect()
    ---@type number
    self.isShowing = true
    self:GetLayout(data.gameMode)
    self.layout:OnShow(data)
end

function UIVictoryView:CheckCallbackAnimation()

end

--- @return void
function UIVictoryView:PlayEffect()
    zg.audioMgr:PlaySfxUi(SfxUiType.VICTORY)
    self:PlayVictoryAnim()

    Coroutine.start(function()
        coroutine.waitforseconds(10.0 / ClientConfigUtils.FPS)
        self:EnableFxVictory(true)
    end)
    self.config.bgPannel.sizeDelta = U_Vector2(125, 50)
    DOTweenUtils.DOSizeDelta(self.config.bgPannel, U_Vector2(2400, 50), 0.5)
end

function UIVictoryView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self.layout:OnFinishAnimation()
end

function UIVictoryView:Hide()
    UIBaseView.Hide(self)
    self.isShowing = false
    self:EnableFxVictory(false)
    self:HideLayout()
    self.rewardTableView:Hide()
    self:RemoveListenerTutorial()
end

function UIVictoryView:PlayVictoryAnim()
    self.config.victoryAnim.AnimationState:ClearTracks()
    self.config.victoryAnim.Skeleton:SetToSetupPose()

    local trackEntry = self.config.victoryAnim.AnimationState:SetAnimation(0, "start", false)
    trackEntry:AddCompleteListenerFromLua(function()
        self.config.victoryAnim.AnimationState:SetAnimation(0, "loop", true)
        self:OnFinishAnimation()
    end)

    Coroutine.start(function()
        --- @type TouchObject
        local touchObject = TouchUtils.Spawn("UIVictoryView:PlayVictoryAnim")
        coroutine.waitforseconds(1.2)
        touchObject:Enable()
    end)
end

--- @param isEnable boolean
function UIVictoryView:EnableFxVictory(isEnable)
    self.config.vfxVictory:SetActive(isEnable)
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIVictoryView:ShowTutorial(tutorial, step)
    if step == TutorialStep.NEXT_STAGE then
        tutorial:ViewFocusCurrentTutorial(self.config.buttonClose, U_Vector2(500, 180), nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.BATTLE_CLOSE then
        tutorial:ViewFocusCurrentTutorial(self.config.buttonClose, 0.5, function()
            return self.config.transform.position + U_Vector3(4, -3, 0)
        end, nil, TutorialHandType.CLICK)
    end
end

--- @param gameMode GameMode
function UIVictoryView:GetLayout(gameMode)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(gameMode)
    if self.layout == nil then
        if gameMode == GameMode.CAMPAIGN then
            require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryCampaignLayout"
            self.layout = UIVictoryCampaignLayout(self, self.config.pveAnchor)
        elseif gameMode == GameMode.TOWER
                or gameMode == GameMode.DUNGEON
                or gameMode == GameMode.RAID
                or gameMode == GameMode.GUILD_BOSS
                or gameMode == GameMode.GUILD_DUNGEON
                or gameMode == GameMode.TEST then
            require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryPveLayout"
            self.layout = UIVictoryPveLayout(self, self.config.pveAnchor)
        elseif gameMode == GameMode.ARENA or gameMode == GameMode.FRIEND_BATTLE then
            require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryArenaLayout"
            self.layout = UIVictoryArenaLayout(self, self.config.arenaAnchor)
        elseif gameMode == GameMode.GUILD_WAR then
            require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryGuildWarLayout"
            self.layout = UIVictoryGuildWarLayout(self, self.config.guildWarAnchor)
        elseif gameMode == GameMode.DEFENSE_MODE then
            require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryDefenseLayout"
            self.layout = UIVictoryDefenseLayout(self, self.config.pveAnchor)
        elseif gameMode == GameMode.DEFENSE_MODE_RECORD then
            require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryDefenseRecordLayout"
            self.layout = UIVictoryDefenseRecordLayout(self, self.config.pveAnchor)
        elseif gameMode == GameMode.EVENT_CHRISTMAS then
            require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryXmasLayout"
            self.layout = UIVictoryXmasLayout(self, self.config.xmasAnchor)
        elseif gameMode == GameMode.EVENT_VALENTINE_BOSS then
            require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryValentineLayout"
            self.layout = UIVictoryValentineLayout(self, self.config.xmasAnchor)
        elseif gameMode == GameMode.EVENT_KAZETSU_BOSS then
            require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryKazetsuLayout"
            self.layout = UIVictoryKazetsuLayout(self, self.config.xmasAnchor)
        elseif gameMode == GameMode.EVENT_BOSS_CHALLENGE then
            require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryBossChallengeTowerLayout"
            self.layout = UIVictoryBossChallengeTowerLayout(self, self.config.pveAnchor)
        elseif gameMode == GameMode.EVENT_BIRTHDAY_BOSS then
            require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryBirthdayLayout"
            self.layout = UIVictoryBirthdayLayout(self, self.config.xmasAnchor)
        elseif gameMode == GameMode.EVENT_FINDE_BOSS then
            require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryFindeLayout"
            self.layout = UIVictoryFindeLayout(self, self.config.xmasAnchor)
        elseif gameMode == GameMode.ARENA_TEAM or gameMode == GameMode.ARENA_TEAM_RECORD then
            require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryArenaTeamLayout"
            self.layout = UIVictoryArenaTeamLayout(self, self.config.arenaAnchor)
        elseif gameMode == GameMode.CHRISTMAS_ARENA_RECORD then
            require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryChristmasRecordLayout"
            self.layout = UIVictoryChristmasRecordLayout(self, self.config.pveAnchor)
        elseif gameMode == GameMode.MID_AUTUMN_ARENA_RECORD then
            require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryMidAutumnArenaRecordLayout"
            self.layout = UIVictoryMidAutumnArenaRecordLayout(self, self.config.pveAnchor)
        else
            require "lua.client.scene.ui.battle.uiVictory.uiVictoryLayout.UIVictoryPveLayout"
            self.layout = UIVictoryPveLayout(self, self.config.pveAnchor)
        end
        self.layoutDict:Add(gameMode, self.layout)
    end
end

function UIVictoryView:DisableCommon()
    self.config.pveAnchor.gameObject:SetActive(false)
    self.config.arenaAnchor.gameObject:SetActive(false)
    self.config.guildWarAnchor.gameObject:SetActive(false)
    self.config.xmasAnchor.gameObject:SetActive(false)
    self.config.buttonBattleLog.gameObject:SetActive(true)
    self:HideLayout()
end

function UIVictoryView:HideLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end

--- @param listReward List -- ItemIconData
function UIVictoryView:SetReward(listReward)
    if self.rewardTableView == nil then
        self.rewardTableView = ItemsTableView(self.config.rewardAnchor)
    end
    self.rewardTableView:SetData(listReward)
end

function UIVictoryView:ShowLog()
    if ClientBattleData.IsValidData() == false then
        if ClientBattleData.calculationBattle ~= nil then
            ClientBattleData.calculationBattle()
        end
    end
    if ClientBattleData.IsValidData() == true then
        PopupMgr.ShowPopup(UIPopupName.UIBattleLog, {
            ["battleResult"] = ClientBattleData.battleResult,
            ["clientLogDetail"] = ClientBattleData.clientLogDetail })
    else
        XDebug.Error("ERROR battle log")
    end
end
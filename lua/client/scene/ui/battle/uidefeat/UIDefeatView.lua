require "lua.client.scene.ui.battle.uiDefeat.UIGuildWardDefeatView"
require "lua.client.scene.ui.battle.uiDefeat.uiDefeatLayout.UIDefeatLayout"

--- @class UIDefeatView : UIBaseView
UIDefeatView = Class(UIDefeatView, UIBaseView)

--- @return void
--- @param model UIDefeatModel
--- @param ctrl UIDefeatCtrl
function UIDefeatView:Ctor(model, ctrl)
    --- @type UIDefeatConfig
    self.config = nil
    --- @type ItemsTableView
    self.rewardView = nil

    self.rewardTableView = nil
    --- @type boolean
    self.isAllowClose = false
    --- @type boolean
    self.isShowing = false

    --- @type UIDefeatLayout
    self.layout = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()

    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIDefeatModel
    self.model = model
    --- @type UIDefeatCtrl
    self.ctrl = ctrl
end

--- @return void
function UIDefeatView:OnReadyCreate()
    ---@type UIDefeatConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:_InitButtonListener()
end

function UIDefeatView:InitLocalization()
    self.config.localizeTapToClose.gameObject:SetActive(false)
    self.config.localizeForce.text = LanguageUtils.LocalizeCommon("forge_equipment")
    self.config.localizeUpgrade.text = LanguageUtils.LocalizeCommon("upgrade_hero")
    self.config.localizeSummon.text = LanguageUtils.LocalizeCommon("summon_hero")
    self.config.localizeReward.text = LanguageUtils.LocalizeCommon("reward")
    self.config.localizeReward2.text = LanguageUtils.LocalizeCommon("reward")

    if self.guildWarDefeatView ~= nil then
        self.guildWarDefeatView:InitLocalize()
    end
end

function UIDefeatView:_InitButtonListener()
    self.config.buttonBattleLog.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBattleLog()
    end)

    self.config.buttonUpgrade1.onClick:AddListener(function()
        self:OnClickUpgrade1()
    end)

    self.config.buttonUpgrade2.onClick:AddListener(function()
        self:OnClickUpgrade2()
    end)

    self.config.buttonUpgrade3.onClick:AddListener(function()
        self:OnClickUpgrade3()
    end)

    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)

end

function UIDefeatView:OnClickBackOrClose()
    self.layout:OnClickBackOrClose()
end

function UIDefeatView:GetLayout(gameMode)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(gameMode)
    if self.layout == nil then
        if gameMode == GameMode.CAMPAIGN
                or gameMode == GameMode.TOWER
                or gameMode == GameMode.RAID
                or gameMode == GameMode.DUNGEON
                or gameMode == GameMode.GUILD_BOSS
                or gameMode == GameMode.GUILD_DUNGEON then
            require "lua.client.scene.ui.battle.uiDefeat.uiDefeatLayout.UIDefeatCampaignLayout"
            self.layout = UIDefeatCampaignLayout(self, self.config.pveAnchor)
        elseif gameMode == GameMode.TEST then
            require "lua.client.scene.ui.battle.uiDefeat.uiDefeatLayout.UIDefeatArenaLayout"
            self.layout = UIDefeatArenaLayout(self, self.config.pveAnchor)
        elseif gameMode == GameMode.ARENA or gameMode == GameMode.FRIEND_BATTLE then
            require "lua.client.scene.ui.battle.uiDefeat.uiDefeatLayout.UIDefeatArenaLayout"
            self.layout = UIDefeatArenaLayout(self, self.config.arenaAnchor)
        elseif gameMode == GameMode.GUILD_WAR then
            require "lua.client.scene.ui.battle.uiDefeat.uiDefeatLayout.UIDefeatGuildWarLayout"
            self.layout = UIDefeatGuildWarLayout(self, self.config.guildWarDefeat)
        elseif gameMode == GameMode.DEFENSE_MODE then
            require "lua.client.scene.ui.battle.uiDefeat.uiDefeatLayout.UIDefeatDefenseLayout"
            self.layout = UIDefeatDefenseLayout(self, self.config.pveAnchor)
        elseif gameMode == GameMode.EVENT_CHRISTMAS then
            require "lua.client.scene.ui.battle.uiDefeat.uiDefeatLayout.UIDefeatXmasLayout"
            self.layout = UIDefeatXmasLayout(self, self.config.xmasAnchor)
        elseif gameMode == GameMode.ARENA_TEAM or gameMode == GameMode.ARENA_TEAM_RECORD then
            require "lua.client.scene.ui.battle.uiDefeat.uiDefeatLayout.UIDefeatArenaTeamLayout"
            self.layout = UIDefeatArenaTeamLayout(self, self.config.arenaAnchor)
        elseif gameMode == GameMode.EVENT_KAZETSU_TRIAL or gameMode == GameMode.EVENT_SKIN_CHALLENGE then
            require "lua.client.scene.ui.battle.uiDefeat.uiDefeatLayout.UIDefeatKazetsuLayout"
            self.layout = UIDefeatKazetsuLayout(self, self.config.arenaAnchor)
        elseif gameMode == GameMode.EVENT_BOSS_CHALLENGE then
            require "lua.client.scene.ui.battle.uiDefeat.uiDefeatLayout.UIDefeatBossChallengeLayout"
            self.layout = UIDefeatBossChallengeLayout(self, self.config.pveAnchor)
        elseif gameMode == GameMode.CHRISTMAS_ARENA_RECORD then
            require "lua.client.scene.ui.battle.uiDefeat.uiDefeatLayout.UIDefeatChristmasRecordLayout"
            self.layout = UIDefeatChristmasRecordLayout(self, self.config.pveAnchor)
        elseif gameMode == GameMode.MID_AUTUMN_ARENA_RECORD then
            require "lua.client.scene.ui.battle.uiDefeat.uiDefeatLayout.UIDefeatMidAutumnArenaRecordLayout"
            self.layout = UIDefeatMidAutumnArenaRecordLayout(self, self.config.pveAnchor)
        else
            require "lua.client.scene.ui.battle.uiDefeat.uiDefeatLayout.UIDefeatCampaignLayout"
            self.layout = UIDefeatCampaignLayout(self, self.config.pveAnchor)
        end
        self.layout:InitLocalization()
    end
end
--- @param result {isWin, result, clientLogDetail}
function UIDefeatView:OnReadyShow(result)
    if self.isShowing then
        return
    end
    self.isShowing = true

    self.callbackUpgrade = result.callbackUpgrade
    self.config.reward.gameObject:SetActive(false)
    self.config.recommendAnchor.gameObject:SetActive(false)

    self.model.isWin = result.isWin
    --- @type BattleResult
    self.model.battleResult = result.result
    self.model.clientLogDetail = result.clientLogDetail
    local gameMode = result.gameMode
    self:GetLayout(gameMode)
    self:PlayEffect()
    self.layout:OnShow(result)
end

function UIDefeatView:PlayEffect()
    zg.audioMgr:PlaySfxUi(SfxUiType.DEFEAT)
    self:PlayDefeatAnim()

    self.config.bgPannel.sizeDelta = U_Vector2(125, 50)
    DOTweenUtils.DOSizeDelta(self.config.bgPannel, U_Vector2(2400, 50), 0.5)
end

function UIDefeatView:SetReward(listReward)
    if self.rewardTableView == nil then
        self.rewardTableView = ItemsTableView(self.config.rewardAnchor)
    end
    self.rewardTableView:SetData(listReward)
end

function UIDefeatView:DisableCommon()
    self.config.pveAnchor.gameObject:SetActive(false)
    self.config.arenaAnchor.gameObject:SetActive(false)
    self.config.guildWarDefeat.gameObject:SetActive(false)
    self.config.xmasAnchor.gameObject:SetActive(false)
    self.config.buttonBattleLog.gameObject:SetActive(true)
    self:HideLayout()
end

function UIDefeatView:HideLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end
--- @return void
function UIDefeatView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self.layout:OnFinishAnimation()
end

function UIDefeatView:Hide()
    self:RemoveListenerTutorial()
    UIBaseView.Hide(self)
    self.isShowing = false
    if self.rewardView ~= nil then
        self.rewardView:Hide()
    end
    if self.rewardTableView ~= nil then
        self.rewardTableView:Hide()
    end
    self:HideLayout()
end

--- @return void
--- @param uiOpen UIPopupName
function UIDefeatView:OnClickClose(uiOpen)
    --XDebug.Log("Call defeat view: " .. tostring(uiOpen))
    PopupMgr.HidePopup(UIPopupName.UIDefeat)
    RxMgr.unloadUnusedResource:Next()
    zg.sceneMgr:SwitchScene(SceneConfig.HomeScene, { ["popup"] = uiOpen })
end

function UIDefeatView:CheckCallbackAnimation()

end

function UIDefeatView:PlayDefeatAnim()
    self.config.defeatAnim.AnimationState:ClearTracks()
    self.config.defeatAnim.Skeleton:SetToSetupPose()
    local trackEntry = self.config.defeatAnim.AnimationState:SetAnimation(0, "start", false)
    trackEntry:AddCompleteListenerFromLua(function()
        self.config.defeatAnim.AnimationState:SetAnimation(0, "loop", true)
        self:OnFinishAnimation()
    end)

    Coroutine.start(function()
        --- @type TouchObject
        local touchObject = TouchUtils.Spawn("UIDefeatView:PlayDefeatAnim")
        coroutine.waitforseconds(1.3)
        touchObject:Enable()
    end)
end

function UIDefeatView:OnClickUpgrade1()
    if self.callbackUpgrade ~= nil then
        self.callbackUpgrade(UIPopupName.UIBlackSmith)
    else
        self:OnClickClose(UIPopupName.UIBlackSmith)
    end
end

function UIDefeatView:OnClickUpgrade2()
    if self.callbackUpgrade ~= nil then
        self.callbackUpgrade(UIPopupName.UIHeroCollection)
    else
        self:OnClickClose(UIPopupName.UIHeroCollection)
    end
end

function UIDefeatView:OnClickUpgrade3()
    if self.callbackUpgrade ~= nil then
        self.callbackUpgrade(UIPopupName.UIHeroSummonRemake)
    else
        self:OnClickClose(UIPopupName.UIHeroSummonRemake)
    end
end

function UIDefeatView:OnClickBgAutoBattle()
    self.config.autoBattleView.gameObject:SetActive(false)
    PlayerSetting.SetAutoNextBattle(false)
    self:StopCoroutine()
end

function UIDefeatView:SetActiveAutoNextBattle(isEnable)
    self.config.autoBattleView.gameObject:SetActive(isEnable)
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIDefeatView:ShowTutorial(tutorial, step)
    if step == TutorialStep.DEFEATED_FORGE_EQUIPMENT then
        tutorial:ViewFocusCurrentTutorial(self.config.buttonUpgrade1, 0.5, nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.DEFEATED_UPGRADE_HERO then
        tutorial:ViewFocusCurrentTutorial(self.config.buttonUpgrade2, 0.5, nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.DEFEATED_SUMMON_HERO then
        tutorial:ViewFocusCurrentTutorial(self.config.buttonUpgrade3, 0.5, nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.BATTLE_CLOSE then
        tutorial:ViewFocusCurrentTutorial(self.config.buttonClose, 3, function()
            return self.config.transform.position + U_Vector3(4, -3, 0)
        end, nil, TutorialHandType.CLICK)
    end
end

function UIDefeatView:OnClickBattleLog()
    self.layout:OnClickBattleLog()
end

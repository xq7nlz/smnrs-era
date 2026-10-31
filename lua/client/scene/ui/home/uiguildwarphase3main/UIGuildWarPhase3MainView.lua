require "lua.client.scene.ui.home.uiGuildWarPhase3Main.UIGuildWarPhase3MainTopInfoView"

--- @class UIGuildWarPhase3MainView : UIBaseView
UIGuildWarPhase3MainView = Class(UIGuildWarPhase3MainView, UIBaseView)

--- @return void
--- @param model UIGuildWarPhase3MainModel
function UIGuildWarPhase3MainView:Ctor(model)
    --- @type UIGuildWarPhase3MainConfig
    self.config = nil

    --- @type UIGuildWarPhase3MainTopInfoView
    self.allyGuildTopInfo = nil
    --- @type UIGuildWarPhase3MainTopInfoView
    self.opponentGuildTopInfo = nil

    --- @type GuildWarArea
    self.guildWarArea = nil

    --- @type GuildWarEloPositionConfig
    self.eloPositionConfig = nil

    --- @type GuildBasicInfoInBound
    self.guildBasicInfo = nil
    --- @type GuildWarTimeInBound
    self.guildWarTimeInBound = nil
    --- @type GuildWarConfig
    self.guildWarConfig = nil
    --- @type GuildData
    self.guildData = nil
    --- @type GuildWarInBound
    self.allyWarInBound = nil
    --- @type GuildWarPlayerInBound
    self.opponentGuildWarInBound = nil

    --- @type UnityEngine_Transform
    self.uiAttackRemaining = nil
    UIBaseView.Ctor(self, model)
    --- @type UIGuildWarPhase3MainModel
    self.model = model
end

--- @return void
function UIGuildWarPhase3MainView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self.eloPositionConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarEloPositionConfig()

    self.allyGuildTopInfo = UIGuildWarPhase3MainTopInfoView(self.config.allyTopInformation)
    self.opponentGuildTopInfo = UIGuildWarPhase3MainTopInfoView(self.config.enemyTopInformation)
    self:InitButtonListener()

    self:_InitUpdateTime()
end

function UIGuildWarPhase3MainView:_InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        local onSeasonEnd = function()
            self:OnClickBackOrClose()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("season_end"))
            PopupMgr.HidePopup(UIPopupName.UIGuildWarReward)
        end
        if isSetTime == true then
            if self.guildWarTimeInBound:CurrentPhase() ~= GuildWarPhase.BATTLE then
                onSeasonEnd()
            else
                self.timeRefresh = self.guildWarTimeInBound:GetTimeToCurrentPhaseEnd()
            end
        else
            self.timeRefresh = self.timeRefresh - 1
            if self.timeRefresh >= 0 then
                self.config.textBattleDayTime.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
                        UIUtils.SetColorString(UIUtils.color7, TimeUtils.SecondsToClock(self.timeRefresh)))
            else
                onSeasonEnd()
            end
        end
    end
end

function UIGuildWarPhase3MainView:InitLocalization()
    self.config.textAttackRemaining.text = LanguageUtils.LocalizeCommon("remaining")
end

function UIGuildWarPhase3MainView:InitButtonListener()
    self.config.backButton.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickInfo()
    end)
    self.config.buttonLeaderboard.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLeaderBoard()
    end)
    self.config.buttonReward.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickReward()
    end)
end

--- @return void
function UIGuildWarPhase3MainView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	self:OnReadyHide()
end

--- @return void
function UIGuildWarPhase3MainView:OnReadyHide()
	PopupMgr.HidePopup(self.model.uiName)
	PopupMgr.ShowPopup(UIPopupName.UIGuildArea)
end

function UIGuildWarPhase3MainView:OnClickInfo()
    local info = LanguageUtils.LocalizeHelpInfo("battle_phase_info")
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

function UIGuildWarPhase3MainView:OnClickLeaderBoard()
    PopupMgr.ShowPopup(UIPopupName.UILeaderBoard, LeaderBoardType.GUILD_WAR_SEASON_RANKING)
end

--- @return void
function UIGuildWarPhase3MainView:OnReadyShow()
    self.guildData = zg.playerData:GetGuildData()
    self.guildBasicInfo = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
    self.guildWarTimeInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR_TIME)
    self.allyWarInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR)

    self:CheckShowAttackRemaining()
    self:InitWorldArea()
    self:OnShowGuildWarWorldArea()
    self:PlayGateMotion()
    self:UpdateCurrency()

    self.allyGuildTopInfo:SetInfo(self.allyWarInBound, true)
    self.opponentGuildTopInfo:SetPointGain(self.allyWarInBound)

    self:ValidateOpponent()
    self:StartUpdateTime()
end

function UIGuildWarPhase3MainView:UpdateCurrency()
    self.config.textAttackPoint.text = tostring(InventoryUtils.GetMoney(MoneyType.GUILD_WAR_STAMINA))
end

function UIGuildWarPhase3MainView:InitWorldArea()
    self:HideWorldArea()
    self.guildWarArea = SmartPool.Instance:SpawnLuaGameObject(AssetType.UIPool, UIPoolType.GuildWarAreaWorld)
end

function UIGuildWarPhase3MainView:HideWorldArea()
    if self.guildWarArea ~= nil then
        self.guildWarArea:Hide()
        self.guildWarArea = nil
    end
end

function UIGuildWarPhase3MainView:Hide()
    UIBaseView.Hide(self)
    self:HideWorldArea()
    self:RemoveUpdateTime()
end

function UIGuildWarPhase3MainView:OnShowGuildWarWorldArea()
    self.guildWarArea:Show(GuildWarArea.CLAMP_LEFT, GuildWarArea.CLAMP_RIGHT)
    self.guildWarArea:EnableUpdateScroll(true)

    self.guildWarArea:SetListSelectedMember(true, self.allyWarInBound:GetListSelectedMemberInGuildWar())
    self.guildWarArea.onSelectBaseSlot = function(isLeftSide, slotIndex)
        self:OnSelectBaseSlot(isLeftSide, slotIndex)
    end
end
--- @param isLeftSide boolean
--- @param slotIndex number
function UIGuildWarPhase3MainView:OnSelectBaseSlot(isLeftSide, slotIndex)
    if isLeftSide then
        self.currentSelectedMember = self.allyWarInBound:FindSelectedMemberByPosition(slotIndex)
    else
        self.currentSelectedMember = self.opponentGuildWarInBound:FindSelectedMemberByPosition(slotIndex)
    end
    if self.currentSelectedMember ~= nil then
        local data = {}
        data.guildWarPlayerInBound = self.currentSelectedMember
        data.position = slotIndex
        data.isAlly = isLeftSide
        PopupMgr.ShowPopup(UIPopupName.UIGuildWarPhase3TeamInfo, data)
    else
        print("No Member Assigned")
    end
end

function UIGuildWarPhase3MainView:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIGuildWarPhase3MainView:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIGuildWarPhase3MainView:PlayGateMotion()
    local lastSeasonCheckOut = zg.playerData:GetGuildData().lastGuildWarSeasonCheckOut
    if lastSeasonCheckOut == self.allyWarInBound.season then
        self.config.gateAnim.gameObject:SetActive(false)
        return
    end
    self.config.gateAnim.gameObject:SetActive(true)
    self.config.gateAnim.AnimationState:ClearTracks()
    self.config.gateAnim.Skeleton:SetToSetupPose()
    --- @type Spine_TrackEntry
    local trackEntry = self.config.gateAnim.AnimationState:SetAnimation(0, "gate3", false)
    trackEntry:AddCompleteListenerFromLua(function ()
        self.config.gateAnim.gameObject:SetActive(false)
        zg.playerData:GetGuildData():SetGuildDungeonSeasonCheckIn(self.allyWarInBound.season)
    end)
end

function UIGuildWarPhase3MainView:ValidateOpponent()
    self.guildData:ValidateGuildWarOpponent(function ()
        self.opponentGuildWarInBound = zg.playerData:GetGuildData().guildWarOpponentInBound
        self.opponentGuildTopInfo:SetInfo(self.opponentGuildWarInBound, false)
        self.opponentGuildTopInfo:SetPointGain(self.allyWarInBound)

        self.allyGuildTopInfo:SetPointGain(self.opponentGuildWarInBound)

        if self.guildWarArea ~= nil then
            self.guildWarArea:SetListSelectedMember(false, self.opponentGuildWarInBound:GetListSelectedMemberInGuildWar())
        end
    end)
end

function UIGuildWarPhase3MainView:CheckShowAttackRemaining()
    if self.uiAttackRemaining == nil then
        self.uiAttackRemaining = self.config.transform:Find("anchor_top/current_attack_point")
    end
    if self.uiAttackRemaining ~= nil then
        self.uiAttackRemaining.gameObject:SetActive(self.allyWarInBound.selectedForGuildWar)
    end
end

function UIGuildWarPhase3MainView:OnClickReward()
    PopupMgr.ShowPopup(UIPopupName.UIGuildWarReward)
end
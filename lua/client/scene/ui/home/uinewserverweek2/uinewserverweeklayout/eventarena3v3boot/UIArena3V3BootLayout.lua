require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.UINewServerWeekLayout"
--- @class UIArena3V3BootLayout : UINewServerWeekLayout
UIArena3V3BootLayout = Class(UIArena3V3BootLayout, UINewServerWeekLayout)

--- @param view UINewServerWeekView
--- @param newServerWeekTab NewServerWeekTab
--- @param anchor UnityEngine_RectTransform
function UIArena3V3BootLayout:Ctor(view, newServerWeekTab, anchor)
    --- @type UnityEngine_Vector3
    local itemSize = U_Vector2(1300, 148)
    --- @type UnityEngine_Vector3
    local rankInfoAnchorPosition = U_Vector3(-37.5, 0, 0)

    self.anchor = anchor
    --- @type UIArenaBootLayoutConfig
    self.layoutConfig = nil
    ---@type EventNewServerWeekArena3vs3Model
    self.eventModel = nil

    ---@type SingleArenaRanking
    self.userSingleArenaRanking = nil
    self:InitLayoutConfig()
    self:InitScroll()
    self:InitUpdateTime()

    UINewServerWeekLayout.Ctor(self, view, newServerWeekTab, anchor)

end

function UIArena3V3BootLayout:UpdateLocalizeTime()
    self.arenaDescTime = LanguageUtils.LocalizeCommon("new_server_arena_boot_2_desc")
end


function UIArena3V3BootLayout:InitUpdateTime()

    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self.arenaEndTime = self:GetArenaEndTime()

            self.arenaEndDuration =  self.arenaEndTime - zg.timeMgr:GetServerTime()
            if  self.arenaEndDuration > 0 then

            else
                --XDebug.Log("NO TIME GET")
            end
            --UIUtils.AlignText(self.layoutConfig.textEventNextDay)
        else
            if self.arenaEndDuration ~= nil then
                self.arenaEndDuration = self.arenaEndDuration - 1
            end
        end
        if self.arenaEndDuration > 0 then
            local time = TimeUtils.GetDeltaTime(self.arenaEndDuration)
            self.layoutConfig.textDesc.text = string.format(self.arenaDescTime,
                    UIUtils.SetColorString(UIUtils.green_light, time))
            --LanguageUtils.LocalizeCommon("new_server_arena_boot_desc", UIUtils.SetColorString(UIUtils.green_light,time)
            --self.layoutConfig.timeCountDown.text = LanguageUtils.LocalizeCommon("next_force_refresh") .. " " .. UIUtils.SetColorString(UIUtils.white, time)
        else
            self:StopTime()
            --self:SetTimeTextWhenStop()
        end
    end
end

function UIArena3V3BootLayout:StartTime()
    if self.updateTime ~= nil then
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end

function UIArena3V3BootLayout:StopTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end

--- @param objectView UnityEngine_GameObject
function UIArena3V3BootLayout:InitLayoutConfig(objectView)
    local inst = PrefabLoadUtils.Instantiate("new_server_arena_3vs3_boot_layout", self.anchor)
    UINewServerWeekLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
end

function UIArena3V3BootLayout:GetArenaEndTime()
    local arenaEvent = zg.playerData:GetEvents():GetEvent(EventTimeType.ARENA_TEAM)
    if (arenaEvent ~= nil) then
        return arenaEvent:GetTime().endTime
    else
        XDebug.Log("error cannot get end time")
        return 0
    end
end




function UIArena3V3BootLayout:InitLocalization()
    self:UpdateLocalizeTime()
    self.layoutConfig.textEmpty.text =  LanguageUtils.LocalizeCommon("empty")
    self.layoutConfig.textBanner.text = LanguageUtils.LocalizeCommon("new_server_arena_boot_2")
    --self.layoutConfig.textDesc.text  = LanguageUtils.LocalizeCommon("new_server_arena_boot_desc", self:GetArenaEndTime())
    --self.layoutConfig.packageTitle.text = LanguageUtils.LocalizeCommon()
end
function UIArena3V3BootLayout:InitButtons()
    self.layoutConfig.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
end

--- @return void
function UIArena3V3BootLayout:OnClickHelpInfo()
    local info = LanguageUtils.LocalizeHelpInfo("event_server_week_arena_2_info")
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end


function UIArena3V3BootLayout:InitScroll()

    --- @param obj ArenaBootCampLeaderBoardItemView
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        ---@type SingleArenaRanking
        local singleArenaRanking = self.eventModel.listRanking:Get(dataIndex)
        self:SetUpItemViewLayout(obj)
        local isUser = false

        if (singleArenaRanking.playerId == self.playerId) then
            isUser = true
            -- XDebug.Log("is user true")
        else
            --  XDebug.Log("opp id " .. tostring(singleArenaRanking.playerId) .. "player id " .. tostring(playerId))
        end

        self:SetItemViewData(obj, singleArenaRanking, dataIndex, isUser)
        ---@type EventNewServerWeekArenaConfig
        local eventConfig = self.eventModel:GetConfig()
        local listRewardIcon = eventConfig:GetListRewardByRank(dataIndex)
        obj:SetDataReward(listRewardIcon)
    end
    --[[    --- @param obj ArenaBootCampLeaderBoardItemView
        local onUpdateItem = function(obj, index)

        end]]
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollContent, UIPoolType.UIArenaBootCampLeaderBoardItem, onCreateItem) -- ,onUpdateItem
    --self.uiScroll:Resize(self.eventModel.listRanking:Count())
    --self.uiScroll:SetUpMotion(MotionConfig())
end

--- @param obj ArenaBootCampLeaderBoardItemView
function UIArena3V3BootLayout:SetUpItemViewLayout(obj)
    -- obj:SetItemSize(itemSize)
    -- obj:SetRankInfoAnchorPosition(rankInfoAnchorPosition)
end

--- @param obj ArenaBootCampLeaderBoardItemView
--- @param singleArenaRanking SingleArenaRanking
--- @param rankValue number
--- @param isUser boolean
function UIArena3V3BootLayout:SetItemViewData(obj, singleArenaRanking, rankValue, isUser)

    --obj:SetName(singleArenaRanking.playerName)

    if (rankValue > 0) then
        obj:SetRankValue(rankValue,isUser)
    else
        obj:SetRankValue(-1,true)
    end

    local arenaPoint = singleArenaRanking.score
    obj:SetRecordInfo(arenaPoint,isUser)

    local rankIcon
    if (rankValue > 0 and rankValue <= LeaderBoardItemView.MaxTopRankHasIcon) then
        rankIcon = ResourceLoadUtils.LoadTopRankingIcon3V3(rankValue)
    end
    obj:SetRankIcon(rankIcon)
    obj:SetBgText(isUser,singleArenaRanking.playerName)

    --- @type VipIconView
    local vipIconView = obj:InitAvatarInfo(UIPoolType.VipIconView)

    --- @return number
    local avatar
    if (isUser) then
        avatar = singleArenaRanking.avatarData:GetMyPlayerAvatar()
    else
        avatar = singleArenaRanking.avatarData:GetOtherPlayerAvatar()
    end
    vipIconView:SetData2(avatar, singleArenaRanking.playerLevel)



    local rankIcon
    if (rankValue > 0 and rankValue <= LeaderBoardItemView.MaxTopRankHasIcon) then
        rankIcon = ResourceLoadUtils.LoadTopRankingIcon3V3(rankValue)
    end
    obj:SetRankIcon(rankIcon)

end

function UIArena3V3BootLayout:SetUpLayout()
    UINewServerWeekLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIArena3V3BootLayout:InitItemShow()

end

function UIArena3V3BootLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SERVER_OPEN_ARENA_3V3)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    else
        XDebug.Log("NIL EVENT MODEL")
    end
end

function UIArena3V3BootLayout:OnShow()
    self:GetData()
    self:CheckDataOnOpen()
    self:StartTime()
    UINewServerWeekLayout.OnShow(self)

end
function UIArena3V3BootLayout:CheckDataOnOpen()
    --[[    if self:IsNeedRequestData() then
            self.layoutConfig.loading:SetActive(true)
        else
            self:OnLoadedLeaderBoardData()
        end]]
    self:OnLoadedLeaderBoardData()
end
function UIArena3V3BootLayout:OnLoadedLeaderBoardData()
    --self.layoutConfig.loading:SetActive(false)
    self:ShowLeaderBoardData()
end

function UIArena3V3BootLayout:SetUpSelfRankingInfo()
    self:_SetUserRankingItemView()
    -- self.layoutConfig.scrollRect.sizeDelta = U_Vector2(1355, 635)
end

function UIArena3V3BootLayout:GetUserRankingItemView()
    ---@type ArenaBootCampLeaderBoardItemView
    if self.userLeaderBoardItemView == nil then
        self.userLeaderBoardItemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIArenaBootCampLeaderBoardItem, self.layoutConfig.userLeaderboardItemAnchor)
    end
    self:SetUpItemViewLayout(self.userLeaderBoardItemView)
end

function UIArena3V3BootLayout:GetData()
    self.playerId = PlayerSettingData.playerId
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SERVER_OPEN_ARENA_3V3)
end

function UIArena3V3BootLayout:_SetUserRankingItemView()
    self:GetUserRankingItemView()
    local userScore = self.eventModel.elo
    --[[    self.config.packTimer.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh, 4)))]]
    ---@type BasicInfoInBound
    local basicInfo = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    self.userSingleArenaRanking = SingleArenaRanking()
    self.userSingleArenaRanking.score = userScore
    self.userSingleArenaRanking.avatarData = basicInfo.avatarData
    self.userSingleArenaRanking.playerLevel = basicInfo.playerLevel
    self.userSingleArenaRanking.playerName = basicInfo.name
    local rankValue
    if (userScore == 0) then
        rankValue = -2
    else
        rankValue = self.eventModel.rankingOrder
    end



    self:SetItemViewData(self.userLeaderBoardItemView,
            self.userSingleArenaRanking,
            self.eventModel.rankingOrder + 1,
            true)
    --XDebug.Log("rank value " .. tostring(rankValue))
    if (rankValue >= 0) then

        local listRewardIcon = self.eventModel:GetConfig():GetListRewardByRank(rankValue + 1)
        self.userLeaderBoardItemView:SetDataReward(listRewardIcon)
    end
end

function UIArena3V3BootLayout:ShowLeaderBoardData()
    self:SetUpSelfRankingInfo()
    --self:InitScroll()
    local size = self.eventModel.listRanking:Count()
    --self.view:ResizeScroll(size, true)
    self.layoutConfig.empty.gameObject:SetActive(size == 0)
    self.uiScroll:Resize(self.eventModel.listRanking:Count())
    --XDebug.Log("RESIZE " .. tostring(size))
end

function UIArena3V3BootLayout:OnHide()
    if (self.userLeaderBoardItemView ~= nil) then
        self.userLeaderBoardItemView:ReturnPool()
        self.userLeaderBoardItemView = nil
    end
    UINewServerWeekLayout.OnHide(self)
end



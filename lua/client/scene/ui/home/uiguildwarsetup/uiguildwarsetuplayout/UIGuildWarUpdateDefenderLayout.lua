--- @class UIGuildWarUpdateDefenderLayout : UIGuildWarSetupLayout
UIGuildWarUpdateDefenderLayout = Class(UIGuildWarUpdateDefenderLayout, UIGuildWarSetupLayout)

--- @param view UIGuildWarSetupView
function UIGuildWarUpdateDefenderLayout:Ctor(view)
    --- @type GuildWarEloPositionConfig
    self.eloPositionConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarEloPositionConfig()
    self.listParticipants = List()
    --- @type GuildWarPlayerInBound
    self.currentSelectedMember = nil
    --- @type boolean
    self.isDirty = false
    UIGuildWarSetupLayout.Ctor(self, view)
end

function UIGuildWarUpdateDefenderLayout:InitTableMember()
    if self.view.uiScroll ~= nil then
        self.view.uiScroll:Hide()
    end
    --- @param obj UIGuildWarRegistrationItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type GuildWarPlayerInBound
        local guildWarPlayerInBound = self.model:GetListMemberInPages():Get(dataIndex)
        obj:SetData(guildWarPlayerInBound)
        if guildWarPlayerInBound.isSelectedForGuildWar then
            local pos = guildWarPlayerInBound.positionInGuildWarBattle
            local elo = self.eloPositionConfig:GetEloByPosition(pos)
            obj:SetMedalData(pos, elo)
            obj:SetBattleTeamViewPosition(false)
        else
            obj:EnableMedalInfo(false)
            obj:EnableIconTick(false)
            obj:SetBattleTeamViewPosition(true)
        end
        if self.currentSelectedMember ~= nil
                and self.currentSelectedMember.compactPlayerInfo.playerId ~= guildWarPlayerInBound.compactPlayerInfo.playerId then
            obj:AddOnClickSwapListener(function()
                self:OnSwapMemberFromTable(guildWarPlayerInBound)
            end)
        end
    end
    self.view.uiScroll = UILoopScroll(self.config.tableMember, UIPoolType.GuildWarRegistrationItem, onCreateItem)

    --- @param obj UIBlackMarketPageConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect)
        obj.imageOn:SetActive(isSelect)
    end

    --- @param indexTab number
    local onChangePage = function(indexTab, lastTab)
    end
    self.view.uiSelectPage = UISelect(self.config.pageMember, UIBaseConfig, onSelect, onChangePage)
end

function UIGuildWarUpdateDefenderLayout:Show()
    self:SetDirty(false)
    UIGuildWarSetupLayout.Show(self)
    self:ShowSetupProgress()
    self:OnShowGuildWarWorldArea()
end

function UIGuildWarUpdateDefenderLayout:OnShowGuildWarWorldArea()
    self.guildWarArea:Show(GuildWarArea.CLAMP_LEFT, 0)
    self.guildWarArea:EnableUpdateScroll(true)

    self:FillSelectedToWorld()
end

function UIGuildWarUpdateDefenderLayout:GetListParticipants()
    self.listParticipants = List()
    local listSelectedForGuildWar = self.view.guildWarInBound:GetListSelectedMemberInGuildWar()
    for i = 1, listSelectedForGuildWar:Count() do
        local member = listSelectedForGuildWar:Get(i)
        self.listParticipants:Add(member)
    end
    local listParticipants = self.view.guildWarInBound:GetListParticipants()
    for i = 1, listParticipants:Count() do
        local member = listParticipants:Get(i)
        self.listParticipants:Add(member)
    end
    self.model:SetListParticipants(self.listParticipants)
end

function UIGuildWarUpdateDefenderLayout:FillSelectedToWorld()
    self.guildWarArea:SetListSelectedMember(true, self.view.guildWarInBound:GetListSelectedMemberInGuildWar())
    self.guildWarArea.onSelectBaseSlot = function(isLeftSide, slotIndex)
        self:OnSelectBaseSlot(isLeftSide, slotIndex)
    end
end

--- @param isLeftSide boolean
--- @param slotIndex number
function UIGuildWarUpdateDefenderLayout:OnSelectBaseSlot(isLeftSide, slotIndex)
    self.currentSelectedMember = self.view.guildWarInBound:FindSelectedMemberByPosition(slotIndex)
    if self.currentSelectedMember ~= nil then
        local onClickSwapButton = function()
            self:GetListParticipants()
            self:InitTableMember()

            self.guildWarArea:EnableUpdateScroll(false)
            self.guildWarArea:HighlightBasePosition(isLeftSide, slotIndex)

            self:EnableTableMember(true)
            self:OnShowPage()

            self.config.buttonSave.gameObject:SetActive(false)
            self.config.popupFoxy.gameObject:SetActive(false)
        end

        local data = {}
        data.onClickSwapButton = onClickSwapButton
        data.guildWarPlayerInBound = self.currentSelectedMember
        data.medal = self.eloPositionConfig:GetEloByPosition(slotIndex)
        PopupMgr.ShowPopup(UIPopupName.UIGuildWarSelectedSwapMember, data)
    else
        print("No Member Assigned")
    end
end

function UIGuildWarUpdateDefenderLayout:OnShowPage()
    self.view.uiScroll:Resize(self.model:GetListMemberInPages():Count())
    self.config.buttonPrev.gameObject:SetActive(self.model.currentPage > 1)
    self.config.buttonNext.gameObject:SetActive(self.model.currentPage < self.model.pageCount)

    self.view.uiSelectPage:SetPagesCount(self.model.pageCount)
    self.view.uiSelectPage:Select(self.model.currentPage)
end

--- @param guildWarPlayerInBound GuildWarPlayerInBound
function UIGuildWarUpdateDefenderLayout:OnSwapMemberFromTable(guildWarPlayerInBound)
    if self.currentSelectedMember == nil
            or self.currentSelectedMember.compactPlayerInfo.playerId == guildWarPlayerInBound.compactPlayerInfo.playerId then
        return
    end
    self:SetDirty(true)

    self:EnableTableMember(false)
    self.guildWarArea:EnableUpdateScroll(true)
    self.guildWarArea:DisableHighlight()
    self.config.popupFoxy.gameObject:SetActive(true)

    self.view.guildWarInBound:SwapMemberSlot(self.currentSelectedMember, guildWarPlayerInBound)
    self:FillSelectedToWorld()

    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("swap_member_successful"))
end

function UIGuildWarUpdateDefenderLayout:OnClickBack()
    local onClickBackOrClose = function()
        PopupMgr.HidePopup(self.model.uiName)
        PopupMgr.ShowPopup(UIPopupName.UIGuildWarRegistration)
    end
    if self.isDirty == true then
        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("ask_for_save_the_change_guild_war_defenders"),
                function()
                    GuildWarInBound.ValidateData(onClickBackOrClose, true)
                end,
                function()
                    local onSuccess = function()
                        PopupMgr.ShowAndHidePopup(UIPopupName.UIGuildWarRegistration, nil, self.model.uiName)
                    end
                    self:SaveTheChange(onSuccess)
                end)
        return
    end
    onClickBackOrClose()
end

function UIGuildWarUpdateDefenderLayout:SaveTheChange(onSuccess)
    local listSelectedForGuildWar = List()
    for i = 1, self.listParticipants:Count() do
        --- @type GuildWarPlayerInBound
        local member = self.listParticipants:Get(i)
        if member.isSelectedForGuildWar == true then
            listSelectedForGuildWar:Add(member)
        end
    end
    local onSaveSuccess = function()
        self.view.guildWarInBound:SeparateSelectedMember(self.listParticipants)
        if onSuccess ~= nil then
            onSuccess()
        end
    end
    local onFailed = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIGuildWarRegistration, nil, self.model.uiName)
    end
    listSelectedForGuildWar:SortWithMethod(GuildWarInBound.SortMemberByPositionIndex)
    GuildWarInBound.RequestGuildWarRegister(listSelectedForGuildWar, onSaveSuccess, onFailed)
end

function UIGuildWarUpdateDefenderLayout:OnClickSaveChange()
    if self.isDirty == true then
        self:SaveTheChange(function()
            self:SetDirty(false)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("save_successful"))
        end)
    end
end

function UIGuildWarUpdateDefenderLayout:SetUpLayout()
    self:EnableTableMember(false)
    self.config.popupFoxy.gameObject:SetActive(true)
    self.config.buttonSave.gameObject:SetActive(false)
    UIGuildWarSetupLayout.SetPopupFoxyPosX(self, 0)
end

function UIGuildWarUpdateDefenderLayout:ShowSetupProgress()
    local message = LanguageUtils.LocalizeCommon("guild_war_setup_can_be_modified")
    message = string.gsub(message, "{1}", UIUtils.SetColorString(UIUtils.color7, LanguageUtils.LocalizeCommon("guild_war_phase_3_name")))
    self.config.messageSetup.text = message
end

function UIGuildWarUpdateDefenderLayout:SetDirty(isDirty)
    self.isDirty = isDirty
    self.config.buttonSave.gameObject:SetActive(isDirty)
end

--- @param isNext
function UIGuildWarUpdateDefenderLayout:OnClickSwitchPage(isNext)
    UIGuildWarSetupLayout.OnClickSwitchPage(self, isNext)
    self:OnShowPage()
end

function UIGuildWarUpdateDefenderLayout:SortByPower()
    UIGuildWarSetupLayout.SortByPower(self)
    self:OnShowPage()
end

function UIGuildWarUpdateDefenderLayout:SortByLevel()
    UIGuildWarSetupLayout.SortByLevel(self)
    self:OnShowPage()
end

function UIGuildWarUpdateDefenderLayout:OnDefenderUpdated()
    local update = function()
        GuildWarInBound.ValidateData(function()
            self.view.guildWarInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR)
            self:Show()
        end, true, true)
    end
    PopupUtils.ShowPopupNotificationOK(LanguageUtils.LocalizeCommon("guild_war_register_notification"), update, update)
end
--- @class UIGuildWarSetupBattleLayout : UIGuildWarSetupLayout
UIGuildWarSetupBattleLayout = Class(UIGuildWarSetupBattleLayout, UIGuildWarSetupLayout)

--- @param view UIGuildWarSetupView
function UIGuildWarSetupBattleLayout:Ctor(view)
    --- @type List
    self.listSelectedForGuildWar = nil
    UIGuildWarSetupLayout.Ctor(self, view)
end

function UIGuildWarSetupBattleLayout:InitTableMember()
    --- @param obj UIGuildWarRegistrationItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type GuildWarPlayerInBound
        local guildWarPlayerInBound = self.model:GetListMemberInPages():Get(dataIndex)
        obj:SetData(guildWarPlayerInBound)
        obj:EnableMedalInfo(false)
        obj:EnableIconTick(false)
        obj:AddOnClickSetUpListener(function()
            self:SelectMemberIntoWar(guildWarPlayerInBound)
        end)
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

function UIGuildWarSetupBattleLayout:Show()
    self.listSelectedForGuildWar = List()
    UIGuildWarSetupLayout.Show(self)
    self:ShowSetupProgress()
    self:InitTableMember()

    self.model:SetListParticipants(self.view.guildWarInBound.listParticipants)

    self:OnShowPage()

    self:OnShowGuildWarWorldArea()

    self:HighlightNextBase()

    self:EnableTableMember(true)
end

function UIGuildWarSetupBattleLayout:OnShowPage()
    self.view.uiScroll:Resize(self.model:GetListMemberInPages():Count())
    self.config.buttonPrev.gameObject:SetActive(self.model.currentPage > 1)
    self.config.buttonNext.gameObject:SetActive(self.model.currentPage < self.model.pageCount)

    self.view.uiSelectPage:SetPagesCount(self.model.pageCount)
    self.view.uiSelectPage:Select(self.model.currentPage)
end

--- @param isNext
function UIGuildWarSetupBattleLayout:OnClickSwitchPage(isNext)
    UIGuildWarSetupLayout.OnClickSwitchPage(self, isNext)
    self:OnShowPage()
end

--- @param guildWarPlayerInBound GuildWarPlayerInBound
function UIGuildWarSetupBattleLayout:SelectMemberIntoWar(guildWarPlayerInBound)
    self.listSelectedForGuildWar:Add(guildWarPlayerInBound)
    self.model:SelectParticipantForGuildWar(guildWarPlayerInBound)
    self.view.uiScroll:Resize(self.model:GetListMemberInPages():Count())

    local countSelected = self.listSelectedForGuildWar:Count()
    self:OnShowPage()
    self.guildWarArea:SetListSelectedMember(true, self.listSelectedForGuildWar)

    self:ShowSetupProgress()

    if countSelected == self.view.guildWarConfig.numberMemberJoin then
        self.guildWarArea:DisableHighlight()
        local onSuccess = function()
            local onConfirm = function()
                PopupMgr.ShowAndHidePopup(UIPopupName.UIGuildWarRegistration, nil, self.model.uiName)
            end
            PopupUtils.ShowPopupNotificationOK(LanguageUtils.LocalizeCommon("guild_war_member_setup_successful"), onConfirm)
        end
        local onFailed = function()
            PopupMgr.ShowAndHidePopup(UIPopupName.UIGuildArea, nil, self.model.uiName)
        end
        GuildWarInBound.RequestGuildWarRegister(self.listSelectedForGuildWar, onSuccess, onFailed)
    else
        self:HighlightNextBase()
    end
end

function UIGuildWarSetupBattleLayout:OnClickBack()
    local countSelected = self.listSelectedForGuildWar:Count()
    if countSelected > 0 and countSelected < self.view.guildWarConfig.numberMemberJoin then
        PopupUtils.ShowPopupNotificationYesNo("You are not finished setting up defender. Are you sure wanna quit?", nil,
                function()
                    self.view:OnReadyHide()
                end)
    else
        UIGuildWarSetupLayout.OnClickBack(self)
    end
end

function UIGuildWarSetupBattleLayout:OnShowGuildWarWorldArea()
    self.guildWarArea:Show()
    self.guildWarArea:SetBaseSlot(true, self.view.guildWarConfig.numberMemberJoin)
    self.guildWarArea:SetListSelectedMember(true, self.listSelectedForGuildWar)
end

function UIGuildWarSetupBattleLayout:HighlightNextBase()
    self.guildWarArea:EnableUpdateScroll(false)
    local pos = self.listSelectedForGuildWar:Count() + 1
    self.guildWarArea:HighlightBasePosition(true, pos)
end

function UIGuildWarSetupBattleLayout:ShowSetupProgress()
    local countSelected = self.listSelectedForGuildWar:Count()
    local limit = self.view.guildWarConfig.numberMemberJoin

    local content
    if countSelected == limit then
        content = LanguageUtils.LocalizeCommon("guild_war_member_setup_successful")
        self.config.messageSetup.text = content
    else
        content = LanguageUtils.LocalizeCommon("guild_war_member_setup_progress")
        self.config.messageSetup.text = string.format("%s %s", content,
                UIUtils.SetColorString(UIUtils.color7, string.format("%s/%s", countSelected, limit)))
    end
end

function UIGuildWarSetupBattleLayout:SetUpLayout()
    UIGuildWarSetupLayout.SetUpLayout(self)
    UIGuildWarSetupLayout.SetPopupFoxyPosX(self, -357)
end

function UIGuildWarSetupBattleLayout:SortByPower()
    UIGuildWarSetupLayout.SortByPower(self)
    self:OnShowPage()
end

function UIGuildWarSetupBattleLayout:SortByLevel()
    UIGuildWarSetupLayout.SortByLevel(self)
    self:OnShowPage()
end

function UIGuildWarSetupBattleLayout:OnDefenderUpdated()
    local update = function()
        GuildWarInBound.ValidateData(function ()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("save_successful"))
            self.view:OnReadyHide()
        end, true, true)
    end
    PopupUtils.ShowPopupNotificationOK(LanguageUtils.LocalizeCommon("guild_war_register_notification"), update, update)
end

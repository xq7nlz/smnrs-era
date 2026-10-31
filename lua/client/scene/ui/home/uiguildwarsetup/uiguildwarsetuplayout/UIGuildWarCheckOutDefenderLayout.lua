--- @class UIGuildWarCheckOutDefenderLayout : UIGuildWarSetupLayout
UIGuildWarCheckOutDefenderLayout = Class(UIGuildWarCheckOutDefenderLayout, UIGuildWarSetupLayout)

--- @param view UIGuildWarSetupView
function UIGuildWarCheckOutDefenderLayout:Ctor(view)
    --- @type GuildWarEloPositionConfig
    self.eloPositionConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarEloPositionConfig()

    UIGuildWarSetupLayout.Ctor(self, view)
end

function UIGuildWarCheckOutDefenderLayout:Show()
    UIGuildWarSetupLayout.Show(self)
    self:ShowSetupProgress()
    self:OnShowGuildWarWorldArea()
end

function UIGuildWarCheckOutDefenderLayout:SetUpLayout()
    self:EnableTableMember(false)
    self.config.popupFoxy.gameObject:SetActive(true)
    self.config.buttonSave.gameObject:SetActive(false)
    UIGuildWarSetupLayout.SetPopupFoxyPosX(self, 0)
end

function UIGuildWarCheckOutDefenderLayout:OnSwitchPage()
    self.view:OnShowPage()
end

function UIGuildWarCheckOutDefenderLayout:ShowSetupProgress()
    local countSelected = self.view.guildWarInBound:CountSelectedForGuildWar()
    local limit = self.view.guildWarConfig.numberMemberJoin

    local content
    if countSelected == limit then
        content = LanguageUtils.LocalizeCommon("guild_war_setup_can_be_modified")
        content = string.gsub(content, "{1}", UIUtils.SetColorString(UIUtils.color7, LanguageUtils.LocalizeCommon("guild_war_phase_3_name")))
        self.config.messageSetup.text = content
    else
        content = LanguageUtils.LocalizeCommon("guild_war_member_setup_progress")
        self.config.messageSetup.text = string.format("%s %s", content,
                UIUtils.SetColorString(UIUtils.color7, string.format("%s/%s", countSelected, limit)))
    end
end

function UIGuildWarCheckOutDefenderLayout:OnShowGuildWarWorldArea()
    self.guildWarArea:Show(GuildWarArea.CLAMP_LEFT, 0)
    self.guildWarArea:EnableUpdateScroll(true)

    self:FillSelectedToWorld()
end

function UIGuildWarCheckOutDefenderLayout:FillSelectedToWorld()
    self.guildWarArea:SetListSelectedMember(true, self.view.guildWarInBound:GetListSelectedMemberInGuildWar())
    self.guildWarArea.onSelectBaseSlot = function(isLeftSide, slotIndex)
        self:OnSelectBaseSlot(isLeftSide, slotIndex)
    end
end

--- @param isLeftSide boolean
--- @param slotIndex number
function UIGuildWarCheckOutDefenderLayout:OnSelectBaseSlot(isLeftSide, slotIndex)
    self.currentSelectedMember = self.view.guildWarInBound:FindSelectedMemberByPosition(slotIndex)
    if self.currentSelectedMember ~= nil then
        local data = {}
        data.guildWarPlayerInBound = self.currentSelectedMember
        data.medal = self.eloPositionConfig:GetEloByPosition(slotIndex)
        PopupMgr.ShowPopup(UIPopupName.UIGuildWarSelectedSwapMember, data)
    else
        print("No Member Assigned")
    end
end
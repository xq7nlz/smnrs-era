--- @class UIGuildWarSetupLayout
UIGuildWarSetupLayout = Class(UIGuildWarSetupLayout)

--- @param view UIGuildWarSetupView
function UIGuildWarSetupLayout:Ctor(view)
    self.view = view
    --- @type UIGuildWarSetupModel
    self.model = view.model
    --- @type UIGuildWarSetupConfig
    self.config = view.config
end

function UIGuildWarSetupLayout:Init()

end

function UIGuildWarSetupLayout:InitTableMember()

end

function UIGuildWarSetupLayout:Show()
    self.guildWarArea = self.view.guildWarArea
    self:SetUpLayout()
end

function UIGuildWarSetupLayout:Hide()

end

function UIGuildWarSetupLayout:OnClickBack()
    self.view:OnReadyHide()
end

--- @param isNext
function UIGuildWarSetupLayout:OnClickSwitchPage(isNext)
    if (isNext == true and self.model.currentPage == self.model.pageCount)
            or (isNext == false and self.model.currentPage == 1) then
        return
    end
    if isNext == true then
        self.model.currentPage = self.model.currentPage + 1
    else
        self.model.currentPage = self.model.currentPage - 1
    end
    self.model.currentPage = MathUtils.Clamp(self.model.currentPage, 1, self.model.pageCount)
end

function UIGuildWarSetupLayout:ShowSetupProgress()

end

function UIGuildWarSetupLayout:SetUpLayout()
    self:EnableTableMember(true)
    self.config.popupFoxy.gameObject:SetActive(true)
    self.config.buttonSave.gameObject:SetActive(false)
end

function UIGuildWarSetupLayout:SetPopupFoxyPosX(x)
    local pos = self.config.popupFoxy.anchoredPosition3D
    pos.x = x
    self.config.popupFoxy.anchoredPosition3D = pos
end

--- @param isEnable boolean
function UIGuildWarSetupLayout:EnableTableMember(isEnable)
    self.config.popupSetup:SetActive(isEnable)
end

function UIGuildWarSetupLayout:OnClickSaveChange()

end

function UIGuildWarSetupLayout:SortByPower()
    self.model.listParticipants:SortWithMethod(GuildWarPlayerInBound.SortMemberByPower)
end

function UIGuildWarSetupLayout:SortByLevel()
    self.model.listParticipants:SortWithMethod(GuildWarPlayerInBound.SortMemberByLevel)
end

function UIGuildWarSetupLayout:OnDefenderUpdated()

end

--- @class GuildWarSetupLayoutType
GuildWarSetupLayoutType = {
    SET_UP = 1,
    MODIFY = 2,
    CHECK_OUT = 3,
}

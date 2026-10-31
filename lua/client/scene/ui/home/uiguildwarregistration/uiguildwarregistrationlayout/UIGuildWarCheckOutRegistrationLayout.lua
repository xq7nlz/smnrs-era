--- @class UIGuildWarCheckOutRegistrationLayout : UIGuildWarRegistrationLayout
UIGuildWarCheckOutRegistrationLayout = Class(UIGuildWarCheckOutRegistrationLayout, UIGuildWarRegistrationLayout)

--- @param view UIGuildWarRegistrationView
function UIGuildWarCheckOutRegistrationLayout:Ctor(view)
    UIGuildWarRegistrationLayout.Ctor(self, view)
end

function UIGuildWarCheckOutRegistrationLayout:OnShow()
    self.view.currentPhase = GuildWarPhase.REGISTRATION

    UIGuildWarRegistrationLayout.OnShow(self)
    self:SetDataRegistrationPhase()
    self.config.buttonChangeFormation.gameObject:SetActive(true)
end

function UIGuildWarCheckOutRegistrationLayout:SetDataRegistrationPhase()
    self:_InitScrollMember()
    self.view.scrollMember:Resize(self.view.guildWarInBound:GetListParticipants():Count())
end

function UIGuildWarCheckOutRegistrationLayout:_InitScrollMember()
    --- @param obj UIGuildWarRegistrationItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type GuildWarPlayerInBound
        local guildWarPlayerInBound = self.view.guildWarInBound:GetListParticipants():Get(dataIndex)
        obj:SetData(guildWarPlayerInBound, self.view.guildBasicInfo:GetMemberRoleById(guildWarPlayerInBound.compactPlayerInfo.playerId))
        obj:EnableMedalInfo(false)
        obj:EnableIconTick(false)
        obj:SetBattleTeamViewPosition(true)
    end
    self.view.scrollMember = UILoopScroll(self.config.scrollMember, UIPoolType.GuildWarRegistrationItem, onCreateItem)
end

function UIGuildWarCheckOutRegistrationLayout:OnDefenderUpdated()

end
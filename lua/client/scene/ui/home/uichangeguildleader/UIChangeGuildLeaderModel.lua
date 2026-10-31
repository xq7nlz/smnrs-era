--- @class UIChangeGuildLeaderModel : UIBaseModel
UIChangeGuildLeaderModel = Class(UIChangeGuildLeaderModel, UIBaseModel)

--- @return void
function UIChangeGuildLeaderModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIChangeGuildLeader, "change_guild_leader")

    self.bgDark = true
end


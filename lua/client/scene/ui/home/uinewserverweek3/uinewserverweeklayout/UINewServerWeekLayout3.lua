--- @class UINewServerWeekLayout3 : UINewServerWeekLayout
UINewServerWeekLayout3 = Class(UINewServerWeekLayout3,UINewServerWeekLayout)
function UINewServerWeekLayout:GetModelConfig()
    self.newServerWeekModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK)
    if self.newServerWeekModel ~= nil then
        self.eventConfig = self.newServerWeekModel:GetConfig()
    end
end
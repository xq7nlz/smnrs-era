require "lua.client.scene.ui.battle.uiFactionInfo.UIFactionInfoModel"
require "lua.client.scene.ui.battle.uiFactionInfo.UIFactionInfoView"

--- @class UIFactionInfo : UIBase
UIFactionInfo = Class(UIFactionInfo, UIBase)

--- @return void
function UIFactionInfo:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UIFactionInfo:OnCreate()
    UIBase.OnCreate(self)

    self.model = UIFactionInfoModel()
    --self.ctrl = UIFormationCtrl(self.model)
    self.view = UIFactionInfoView(self.model, self.ctrl)
end

return UIFactionInfo

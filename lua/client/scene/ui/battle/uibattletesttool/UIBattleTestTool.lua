require "lua.client.scene.ui.battle.uiBattleTestTool.UIBattleTestToolModel"
require "lua.client.scene.ui.battle.uiBattleTestTool.UIBattleTestToolView"

--- @class UIBattleTestTool : UIBase
UIBattleTestTool = Class(UIBattleTestTool, UIBase)

--- @return void
function UIBattleTestTool:Ctor()
    UIBase.Ctor(self)
end

--- @return void
function UIBattleTestTool:OnCreate()
    UIBase.OnCreate(self)

    self.model = UIBattleTestToolModel()
    self.view = UIBattleTestToolView(self.model)
end

function UIBattleTestTool.NotificationToggleSkipVideo()
    if PlayerSettingData.isSkipVideoBattle then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("skip_cut_scene"))
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("turn_on_cut_scene"))
    end
end

return UIBattleTestTool
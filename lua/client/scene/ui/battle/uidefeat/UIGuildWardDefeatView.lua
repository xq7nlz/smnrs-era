require "lua.client.scene.ui.battle.uiVictory.UIGuildWarEndBattleView"

--- @class UIGuildWarDefeatView : UIGuildWarEndBattleView
UIGuildWarDefeatView = Class(UIGuildWarDefeatView, UIGuildWarEndBattleView)

--- @return void
function UIGuildWarDefeatView:Ctor(object)
    UIGuildWarEndBattleView.Ctor(self, object)
end
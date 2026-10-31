require "lua.client.scene.ui.home.uiBossChallengeQuickBattle.UIBossChallengeQuickBattleModel"
require "lua.client.scene.ui.home.uiBossChallengeQuickBattle.UIBossChallengeQuickBattleView"

--- @class UIBossChallengeQuickBattle : UIBase
UIBossChallengeQuickBattle = Class(UIBossChallengeQuickBattle, UIBase)

--- @return void
function UIBossChallengeQuickBattle:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIBossChallengeQuickBattle:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIBossChallengeQuickBattleModel()
	self.view = UIBossChallengeQuickBattleView(self.model)
end

return UIBossChallengeQuickBattle

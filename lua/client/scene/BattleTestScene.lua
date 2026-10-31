require "lua.client.scene.BaseScene"
require "lua.client.scene.ui.battle.uiBattleTestTool.UIBattleTestTool"

--- @class BattleTestScene
local BattleTestScene = Class(BattleTestScene, BaseScene)

--- @return void
--- @param sceneMgr SceneMgr
function BattleTestScene:Ctor(sceneMgr)
    self.sceneMgr = sceneMgr
    BaseScene.Ctor(self, SceneConfig.BattleTestScene)
    self:InitListener()
end

--- @return void
function BattleTestScene:InitListener()
end

--- @return void
function BattleTestScene:ActiveScene()
    self.hideLoading = RxMgr.hideLoading:Subscribe(RxMgr.CreateFunction(self, self.SetTest))

    Coroutine.start(function()
        coroutine.waitforseconds(0.4)

        BaseScene.ActiveScene(self)
        PopupMgr.ShowPopup(UIPopupName.UIBattleTestMain)
    end)
end

--- @return void
function BattleTestScene:SetTest()
    PopupMgr.ShowPopup(UIPopupName.UIBattleTestTool)
end

--- @return void
function BattleTestScene:DeactiveScene()
    BaseScene.DeactiveScene(self)
    self.hideLoading:Unsubscribe()
end

return BattleTestScene
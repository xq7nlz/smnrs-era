require "lua.client.scene.BaseScene"
require "lua.client.scene.ui.battle.uiBattleMain.UIBattleMain"
require "lua.client.scene.ui.battle.uiBattleTestTool.UIBattleTestTool"

--- @class BattleScene
local BattleScene = Class(BattleScene, BaseScene)

--- @return void
--- @param sceneMgr SceneMgr
function BattleScene:Ctor(sceneMgr)
    self.sceneMgr = sceneMgr
    BaseScene.Ctor(self, SceneConfig.BattleScene)
    self:InitListener()
end

--- @return void
function BattleScene:InitListener()
end

--- @return void
function BattleScene:ActiveScene()
    zg.audioMgr:StopMusic(MusicCtrl.mainMenuMusic)
    if self.hideLoading then
        self.hideLoading:Unsubscribe()
    end
    self.hideLoading = RxMgr.hideLoading:Subscribe(function()
        if zg.canPlayPVEMode then
            PopupMgr.ShowPopup(UIPopupName.UIBattleTestTool)
        else
            zg.battleMgr:StartTheShow()
        end
    end)

    Coroutine.start(function()
        coroutine.waitforseconds(0.4)
        BaseScene.ActiveScene(self)
        PopupMgr.ShowPopup(UIPopupName.UIBattleMain)
    end)
end

--- @return void
function BattleScene:DeactiveScene()
    BaseScene.DeactiveScene(self)
    self.hideLoading:Unsubscribe()
end

return BattleScene
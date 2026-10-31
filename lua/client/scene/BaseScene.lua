--- @class BaseScene
BaseScene = Class(BaseScene)

--- @return void
--- @param sceneName SceneConfig
function BaseScene:Ctor(sceneName)
    self.sceneName = sceneName
    --XDebug.Log("Init Scene " .. self.sceneName)
end

--- @return void
function BaseScene:ActiveScene()

end

--- @return void
function BaseScene:DeactiveScene()
    PopupMgr.ShowPopup(UIPopupName.UILoading, nil, UIPopupHideType.HIDE_ALL)
end
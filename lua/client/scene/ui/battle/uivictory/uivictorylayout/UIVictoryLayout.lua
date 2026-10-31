--- @class UIVictoryLayout
UIVictoryLayout = Class(UIVictoryLayout)

--- @param view UIVictoryView
--- @param anchor UnityEngine_RectTransform
function UIVictoryLayout:Ctor(view, anchor)
    --- @type UIVictoryView
    self.view = view
    --- @type UIVictoryConfig
    self.config = view.config
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type BattleResult
    self.battleResult = nil

    self:InitLayoutConfig()
    self:InitLocalization()
end

function UIVictoryLayout:InitLayoutConfig()

end

function UIVictoryLayout:InitLocalization()

end

--- @param data {gameMode : GameMode, isWin : boolean, result, clientLogDetail}
function UIVictoryLayout:OnShow(data)
    self.config.autoBattleView.gameObject:SetActive(false)
    self:SetUpLayout()
    self:ShowData(data)
    self:CheckLevelUpAndUnlockFeature()
end

function UIVictoryLayout:SetUpLayout()
    self.anchor.gameObject:SetActive(true)
end

function UIVictoryLayout:OnHide()

end

--- @param data {}
function UIVictoryLayout:ShowData(data)

end

function UIVictoryLayout:OnFinishAnimation()

end

function UIVictoryLayout:CheckLevelUpAndUnlockFeature()
    if zg.canPlayPVEMode == false then
        ClientConfigUtils.CheckLevelUpAndUnlockFeature()
    end
end

function UIVictoryLayout:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self.view:OnReadyHide()
end

function UIVictoryLayout:OnClickBattleLog()
    self.view:ShowLog()
end
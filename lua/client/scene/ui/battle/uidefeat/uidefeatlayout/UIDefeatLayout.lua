--- @class UIDefeatLayout
UIDefeatLayout = Class(UIDefeatLayout)

--- @param view UIDefeatView
--- @param anchor UnityEngine_RectTransform
function UIDefeatLayout:Ctor(view, anchor)
    --- @type UIDefeatView
    self.view = view
    --- @type UIDefeatConfig
    self.config = view.config
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type BattleResult
    self.battleResult = nil
    ---@type number
    self.animIndex = 0

    self:InitLayoutConfig()
    self:InitLocalization()
    self:InitCloseButton()
end

function UIDefeatLayout:InitCloseButton()
    self.config.autoBattleView.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBgAutoBattle()
    end)
end

function UIDefeatLayout:InitLayoutConfig()

end

function UIDefeatLayout:InitLocalization()

end

--- @param data {}
function UIDefeatLayout:OnShow(data)
    self:SetUpLayout()
    self:ShowData(data)
end

function UIDefeatLayout:SetUpLayout()
    self.anchor.gameObject:SetActive(true)
end

function UIDefeatLayout:OnHide()

end

--- @param data {}
function UIDefeatLayout:ShowData(data)

end

function UIDefeatLayout:OnFinishAnimation()

end

function UIDefeatLayout:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self.view:OnReadyHide()
end

function UIDefeatLayout:OnClickBattleLog()
    if ClientBattleData.IsValidData() == false then
        if ClientBattleData.calculationBattle ~= nil then
            ClientBattleData.calculationBattle()
        end
    end
    if ClientBattleData.IsValidData() == true then
        PopupMgr.ShowPopup(UIPopupName.UIBattleLog, {
            ["battleResult"] = ClientBattleData.battleResult,
            ["clientLogDetail"] = ClientBattleData.clientLogDetail })
    else
        XDebug.Error("ERROR battle log")
    end
end

function UIDefeatLayout:OnClickBgAutoBattle()
    self.config.autoBattleView.gameObject:SetActive(false)
    PlayerSetting.SetAutoNextBattle(false)
    self:StopCoroutine()
end

function UIDefeatLayout:DoCountdownAutoNext()
    self.coroutineWaitNextBattle = Coroutine.start(function()
        ---@type number
        local numberOfSecs = 5

        while (numberOfSecs > 0) do
            self.config.textAutoEnd.text = self:GetTextAutoNext(numberOfSecs)
            coroutine.waitforseconds(1)
            numberOfSecs = numberOfSecs - 1
        end
        if (PlayerSettingData.isAutoNextBattle) then
            self:ChallengeCurrentStageAgain()
        end
    end)

    self.coroutineUpdateLoadingImage = Coroutine.start(function()
        while true do
            self:UpdateImageAnim()
            coroutine.waitforseconds(0.1)
        end
    end)
end

function UIDefeatLayout:ChallengeCurrentStageAgain()
    print("need override")
end

function UIDefeatLayout:GetTextAutoNext(numberOfSecs)
    return string.format("%s: %s", LanguageUtils.LocalizeCommon("auto_rematch_in"), numberOfSecs)
end

function UIDefeatLayout:UpdateImageAnim()
    self.animIndex = math.max(1, (self.animIndex + 1) % 8)
    local sprite = ResourceLoadUtils.LoadSpriteFromAtlas("RufusRun", "icon_loading_rufus_0" .. self.animIndex)
    self.config.rufusImage.sprite = sprite
end

function UIDefeatLayout:StopCoroutine()
    if self.coroutineWaitNextBattle then
        ClientConfigUtils.KillCoroutine(self.coroutineWaitNextBattle)
        self.coroutineWaitNextBattle = nil
    end
    if self.coroutineUpdateLoadingImage then
        ClientConfigUtils.KillCoroutine(self.coroutineUpdateLoadingImage)
        self.coroutineUpdateLoadingImage = nil
    end
end
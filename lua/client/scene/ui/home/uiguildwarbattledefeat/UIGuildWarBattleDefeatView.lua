--- @class UIGuildWarBattleDefeatView : UIBaseView
UIGuildWarBattleDefeatView = Class(UIGuildWarBattleDefeatView, UIBaseView)

--- @return void
--- @param model UIGuildWarBattleDefeatModel
function UIGuildWarBattleDefeatView:Ctor(model)
    ---@type GuildWarBattleResultView
    self.battleResultView = nil
    -- init variables here
    UIBaseView.Ctor(self, model)
    --- @type UIGuildWarBattleDefeatModel
    self.model = model
end

--- @return void
function UIGuildWarBattleDefeatView:OnReadyCreate()
    ---@type UIDefeatGuildWarConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UIGuildWarBattleDefeatView:InitLocalization()
    self.config.localizeTapToClose.gameObject:SetActive(false)
end

--- @return void
function UIGuildWarBattleDefeatView:OnReadyShow(result)
    if self.battleResultView == nil then
        self.battleResultView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.GuildWarBattleResultView, self.config.guildWarResult)
    end
    self.battleResultView:SetData(result.data, function()
        PopupMgr.HidePopup(self.model.uiName)
        PopupMgr.HidePopup(UIPopupName.UIGuildArea)
    end)
    Coroutine.start(function()
        local touchObject = TouchUtils.Spawn("UIGuildWarBattleDefeatView")
        coroutine.waitforseconds(0.5)
        touchObject:Enable()
    end)
    self:PlayEffect()
end

function UIGuildWarBattleDefeatView:PlayEffect()
    zg.audioMgr:PlaySfxUi(SfxUiType.DEFEAT)
    self:PlayDefeatAnim()

    self.config.bgPannel.sizeDelta = U_Vector2(125, 50)
    DOTweenUtils.DOSizeDelta(self.config.bgPannel, U_Vector2(2400, 50), 0.5)
end

function UIGuildWarBattleDefeatView:PlayDefeatAnim()
    self.config.defeatAnim.AnimationState:ClearTracks()
    self.config.defeatAnim.Skeleton:SetToSetupPose()

    local trackEntry = self.config.defeatAnim.AnimationState:SetAnimation(0, "start", false)
    trackEntry:AddCompleteListenerFromLua(function()
        self.config.defeatAnim.AnimationState:SetAnimation(0, "loop", true)
        self:OnFinishAnimation()
    end)
end

--- @return void
function UIGuildWarBattleDefeatView:Hide()
    UIBaseView.Hide(self)
    if self.battleResultView ~= nil then
        self.battleResultView:ReturnPool()
        self.battleResultView = nil
    end
end
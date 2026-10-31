--- @class UIGuildWarBattleVictoryView : UIBaseView
UIGuildWarBattleVictoryView = Class(UIGuildWarBattleVictoryView, UIBaseView)

--- @return void
--- @param model UIGuildWarBattleVictoryModel
function UIGuildWarBattleVictoryView:Ctor(model)
    ---@type GuildWarBattleResultView
    self.battleResultView = nil
    UIBaseView.Ctor(self, model)
    --- @type UIGuildWarBattleVictoryModel
    self.model = model
end

--- @return void
function UIGuildWarBattleVictoryView:OnReadyCreate()
    ---@type UIVictoryGuildWarConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UIGuildWarBattleVictoryView:InitLocalization()
    self.config.localizeTapToClose.gameObject:SetActive(false)
end

--- @return void
function UIGuildWarBattleVictoryView:OnReadyShow(result)
    if self.battleResultView == nil then
        self.battleResultView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.GuildWarBattleResultView, self.config.guildWarResult)
    end
    self.battleResultView:SetData(result.data, function()
        PopupMgr.HidePopup(self.model.uiName)
        PopupMgr.HidePopup(UIPopupName.UIGuildArea)
    end)

    Coroutine.start(function()
        local touchObject = TouchUtils.Spawn("UIGuildWarBattleVictoryView")
        coroutine.waitforseconds(0.5)
        touchObject:Enable()
    end)

    self:PlayEffect()
end

--- @return void
function UIGuildWarBattleVictoryView:Hide()
    UIBaseView.Hide(self)
    if self.battleResultView ~= nil then
        self.battleResultView:ReturnPool()
        self.battleResultView = nil
    end
end

--- @return void
function UIGuildWarBattleVictoryView:PlayEffect()
    zg.audioMgr:PlaySfxUi(SfxUiType.VICTORY)
    self:PlayVictoryAnim()

    Coroutine.start(function()
        coroutine.waitforseconds(10.0 / ClientConfigUtils.FPS)
        self:EnableFxVictory(true)
    end)
    self.config.bgPannel.sizeDelta = U_Vector2(125, 50)
    DOTweenUtils.DOSizeDelta(self.config.bgPannel, U_Vector2(2400, 50), 0.5)
end

function UIGuildWarBattleVictoryView:PlayVictoryAnim()
    self.config.victoryAnim.AnimationState:ClearTracks()
    self.config.victoryAnim.Skeleton:SetToSetupPose()
    --- @type TouchObject
    local touchObject = TouchUtils.Spawn("UIVictoryView:PlayVictoryAnim")
    local trackEntry = self.config.victoryAnim.AnimationState:SetAnimation(0, "start", false)
    trackEntry:AddCompleteListenerFromLua(function()
        self.config.victoryAnim.AnimationState:SetAnimation(0, "loop", true)
        self:OnFinishAnimation()
        touchObject:Enable()
    end)
end

--- @param isEnable boolean
function UIGuildWarBattleVictoryView:EnableFxVictory(isEnable)
	self.config.vfxVictory:SetActive(isEnable)
end
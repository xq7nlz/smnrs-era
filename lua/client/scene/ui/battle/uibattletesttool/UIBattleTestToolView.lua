local UIConfig = {
    buttonNextTurn = "next_turn",
    buttonSwitchMode = "switch_mode",
    buttonAuto = "mode_selection/auto_battle",
    buttonManual = "mode_selection/manual_battle",
    objectMode = "mode_selection",
    textAuto = "text_auto",
}

--- @class UIBattleTestToolView : UIBaseView
UIBattleTestToolView = Class(UIBattleTestToolView, UIBaseView)

--- @return void
function UIBattleTestToolView:Ctor(model)
    --- @type UnityEngine_UI_Button
    self.btnNextTurn = nil
    --- @type UnityEngine_UI_Button
    self.btnSwitchMode = nil
    --- @type UnityEngine_UI_Button
    self.btnAutoBattle = nil
    --- @type UnityEngine_UI_Button
    self.btnManualBattle = nil
    --- @type TMPro_TextMeshProUGUI
    self.textAuto = nil
    --- @type UnityEngine_GameObject
    self.objectMode = nil

    UIBaseView.Ctor(self, model)
end

--- @return void
function UIBattleTestToolView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self:InitUI()
    self:InitListener()
end

--- @return void
function UIBattleTestToolView:InitUI()
    --- @type UnityEngine_Transform
    local buttonNextTurn = self.uiTransform:Find(UIConfig.buttonNextTurn)
    self.btnNextTurn = buttonNextTurn:GetComponent(ComponentName.UnityEngine_UI_Button)
    self.btnNextTurn.onClick:AddListener(function()
        self:SetNextTurn()
    end)

    --- @type UnityEngine_Transform
    local buttonSwitchMode = self.uiTransform:Find(UIConfig.buttonSwitchMode)
    self.btnSwitchMode = buttonSwitchMode:GetComponent(ComponentName.UnityEngine_UI_Button)
    self.btnSwitchMode.onClick:AddListener(function()
        self.model.isAuto =  not self.model.isAuto
        if self.model.isAuto and self.btnNextTurn.gameObject.activeInHierarchy then
            self:SetNextTurn()
        end
        self:SetSwitchMode()
        RxMgr.switchMode:Next({ ["isAuto"] = self.model.isAuto})
    end)

    --- @type UnityEngine_Transform
    local buttonAuto = self.uiTransform:Find(UIConfig.buttonAuto)
    self.btnAutoBattle = buttonAuto:GetComponent(ComponentName.UnityEngine_UI_Button)
    self.btnAutoBattle.onClick:AddListener(function()
        XDebug.Log("Auto battle")
        self:SelectMode(true)
        RxMgr.startBattle:Next({ ["isAuto"] = self.model.isAuto})
    end)

    --- @type UnityEngine_Transform
    local buttonManual = self.uiTransform:Find(UIConfig.buttonManual)
    self.btnManualBattle = buttonManual:GetComponent(ComponentName.UnityEngine_UI_Button)
    self.btnManualBattle.onClick:AddListener(function()
        self:SelectMode(false)
        RxMgr.startBattle:Next({ ["isAuto"] = self.model.isAuto})
    end)

    --- @type UnityEngine_GameObject
    self.objectMode = self.uiTransform:Find(UIConfig.objectMode)

    --- @type UnityEngine_Transform
    local textAuto = buttonSwitchMode:Find(UIConfig.textAuto)
    self.textAuto = textAuto:GetComponent(ComponentName.TMPro_TextMeshProUGUI)
end

function UIBattleTestToolView:InitListener()
    RxMgr.finishTurn:Subscribe(RxMgr.CreateFunction(self, self.FinishTurn))
    RxMgr.finishBattle:Subscribe(RxMgr.CreateFunction(self, self.FinishBattle))
end

--- return void
function UIBattleTestToolView:OnReadyShow()
    self:SetButtonNextTurn(false)
    self:SetButtonSwitchMode(false)
    self:SetObjectMode(true)
end

--- @return void
--- @param isActive boolean
function UIBattleTestToolView:SetButtonNextTurn(isActive)
    self.btnNextTurn.gameObject:SetActive(isActive)
end

--- @return void
--- @param isActive boolean
function UIBattleTestToolView:SetButtonSwitchMode(isActive)
    self.btnSwitchMode.gameObject:SetActive(isActive)
end

--- @return void
--- @param isActive boolean
function UIBattleTestToolView:SetObjectMode(isActive)
    self.objectMode.gameObject:SetActive(isActive)
end

--- @return void
function UIBattleTestToolView:SetNextTurn()
    RxMgr.nextTurn:Next()
    self:SetButtonNextTurn(false)
end

--- @return void
function UIBattleTestToolView:SetSwitchMode()
    if self.model.isAuto then
        self.textAuto.text = "Auto"
        self:SetButtonNextTurn(false)
    else
        self.textAuto.text = "Manual"
        self:SetButtonNextTurn(true)
    end
end

--- @return void
--- @param isAuto boolean
function UIBattleTestToolView:SelectMode(isAuto)
    self.model.isAuto = isAuto
    self:SetButtonSwitchMode(true)
    self:SetObjectMode(false)
    self:SetSwitchMode()
    RxMgr.switchMode:Next({ ["isAuto"] = self.model.isAuto})
end

--- @return void
function UIBattleTestToolView:FinishTurn()
    if self.model.isAuto == false then
        self:SetButtonNextTurn(true)
    end
end

--- @return void
function UIBattleTestToolView:FinishBattle()
    self.btnSwitchMode.gameObject:SetActive(false)
    self:SetObjectMode(false)
    self:SetButtonNextTurn(false)
end
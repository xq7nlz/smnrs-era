--- @class UIGameStatsView : UIBaseView
UIGameStatsView = Class(UIGameStatsView, UIBaseView)

--- @return void
--- @param model UIGameStatsModel
--- @param ctrl UIGameStatsCtrl
function UIGameStatsView:Ctor(model, ctrl)
    -- init variables here
    UIBaseView.Ctor(self, model, ctrl)
    --- @type GameStatsModel
    self.model = model
    --- @type GameStatsCtrl
    self.ctrl = ctrl
end

--- @return void
function UIGameStatsView:OnReadyCreate()
    ---@type GameStatsConfig
    self.config = UIBaseConfig(self.uiTransform)
    self:Init()
end

--- @return void
function UIGameStatsView:Init()
    self.config.customizer:SetActive(true)
    self.config.advance:SetActive(true)
    self:AddButtonListener()
end

--- @return void
function UIGameStatsView:AddButtonListener()
    local hideCustom = function()
        self.config.customizer:SetActive(false)
    end
    self.config.HideCustomButton.onClick:AddListener(hideCustom)
    local hideAdvance = function()
        self.config.advance:SetActive(false)
    end
    self.config.HideAdvancedButton.onClick:AddListener(hideAdvance)
    local close = function()
        self:OnReadyHide()
    end
    self.config.CloseButton.onClick:AddListener(close)
end

--- @return void
function UIGameStatsView:OnReadyHide()
    PopupMgr.HidePopup(self.model.uiName)
end
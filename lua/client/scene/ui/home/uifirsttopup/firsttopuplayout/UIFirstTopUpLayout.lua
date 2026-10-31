
--- @class UIFirstTopUpLayout
UIFirstTopUpLayout = Class(UIFirstTopUpLayout)

--- @param view UIFirstTopUpView
function UIFirstTopUpLayout:Ctor(view, anchor)
    self.view = view
    ---@type UIFirstTopUpConfig
    self.config = view.config
--[[    ---@type UIFirstTopUpView
    self.baseView =  nil]]
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    self:OnHide()

    --- @type UIFirstTopUpView
    self:_InitConfig()
    self:InitLocalization()
    self:InitButtons()
end

function UIFirstTopUpLayout:InitButtons()

end

---@param  _view UIFirstTopUpView
--[[function UIFirstTopUpLayout:SetBaseView(_view)
    self.baseView = _view
end]]

function UIFirstTopUpLayout:_InitConfig()

end

function UIFirstTopUpLayout:OnShow()
    self.anchor.gameObject:SetActive(true)
end

function UIFirstTopUpLayout:OnHide()
    self.anchor.gameObject:SetActive(false)
end

function UIFirstTopUpLayout:InitLocalization()

end

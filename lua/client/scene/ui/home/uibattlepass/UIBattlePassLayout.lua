
--- @class UIBattlePassLayout
UIBattlePassLayout = Class(UIBattlePassLayout)

--- @param view UIFirstTopUpView
function UIBattlePassLayout:Ctor(view, anchor)
    self.view = view
    ---@type UIBattlePassConfig
    self.config = view.config
    --- @type UnityEngine_RectTransform
    self.anchor = anchor

    self.anchor.gameObject:SetActive(false)

    self:OnHide()
    self:_InitConfig()
    self:InitLocalization()
    self:InitButtons()
end

function UIBattlePassLayout:InitButtons()

end



function UIBattlePassLayout:_InitConfig()

end

function UIBattlePassLayout:OnShow()
    self.anchor.gameObject:SetActive(true)
end

function UIBattlePassLayout:OnHide()
    self.anchor.gameObject:SetActive(false)
end

function UIBattlePassLayout:InitLocalization()

end

function UIBattlePassLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIBattlePassLayout:GetDataAndUpdateView()

end
--- @class UIPopupMultiScrollRewardItemView : UIBaseView
UIPopupMultiScrollRewardItemView = Class(UIPopupMultiScrollRewardItemView, UIBaseView)

--- @return void
--- @param model UIPopupRewardModel
function UIPopupMultiScrollRewardItemView:Ctor(model, ctrl)
    --- @type UIPopupMultiScrollRewardItemConfig
    self.config = nil
    ---@type Dictionary
    self.rewardDict = Dictionary()
    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIPopupRewardModel
    self.model = self.model
end

--- @return void
function UIPopupMultiScrollRewardItemView:OnReadyCreate()
    ---@type UIPopupRewardConfig
    self.config = UIBaseConfig(self.uiTransform)
    self:InitButton()

end

--- @return void
function UIPopupMultiScrollRewardItemView:InitButton()
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonOk.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UIPopupMultiScrollRewardItemView:InitLocalization()
    self.config.textOk.text = LanguageUtils.LocalizeCommon("ok")
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")
    self.config.buttonClaimText.text = LanguageUtils.LocalizeCommon("claim")
end

--- @return void
function UIPopupMultiScrollRewardItemView:InitButton2(func, localize)
    self.config.buttonClaim.gameObject:SetActive(true)
    self.config.buttonClaimText.text = localize
    self.config.buttonClaim.onClick:RemoveAllListeners()
    self.config.buttonClaim.onClick:AddListener(function()
        func()
        self:ResizeScroll()
    end)
end

--- @return void
function UIPopupMultiScrollRewardItemView:HideButtonClaim()
    self.config.buttonClaim.gameObject:SetActive(false)
end

--- @return void
function UIPopupMultiScrollRewardItemView:ShowOneButton(isOneButton)
    self.config.buttonOk.gameObject:SetActive(not isOneButton)
end

--- @return void
---@param data {titleText, localize, itemDict|Dictionary, type, isOneButton, buttonClaim}
function UIPopupMultiScrollRewardItemView:OnReadyShow(data)
    self:InitLocalization()
    self.config.empty.gameObject:SetActive(false)
    self.config.textTitle.text = data.titleText
    if data ~= nil and data.itemDict ~= nil then
        if data.itemDict:Count() > 0 then
            self:InitScroll(data.type, data.itemDict, data.localize)
            self.scroll:Resize(data.itemDict:Count())
        else
            self.config.empty.gameObject:SetActive(true)
        end
    end
    self:ShowOneButton(data.isOneButton)
    if data.buttonClaim then
        self:InitButton2(data.buttonClaim.OnClick, data.buttonClaim.localize)
    end
end

--- @return void
function UIPopupMultiScrollRewardItemView:ResizeScroll()

end

--- @return void
--- @param itemDict List
function UIPopupMultiScrollRewardItemView:InitScroll(type, itemDict, localize)
    --- @param obj DifficultRewardItem | BattleHistoryItem | ServerBuildingProgress
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        ---@type List
        local data = itemDict:Get(dataIndex)
        local text
        if type == PopupMulti.ServerBuildingProgress then
            text = localize
        else
            text = string.format("%s - %s", localize or "", UIUtils.SetColorString(UIUtils.green_light, dataIndex))
        end
        obj:SetItemData(data, text)
    end
    if type == PopupMulti.DifficultRewardItem then
        self.scroll = UILoopScroll(self.config.scroll, UIPoolType.DifficultRewardItem, onCreateItem)
    elseif type == PopupMulti.TrialBattleHistoryItem then
        self.scroll = UILoopScroll(self.config.scroll, UIPoolType.BattleHistoryItem, onCreateItem)
    elseif type == PopupMulti.ServerBuildingProgress then
        self.scroll = UILoopScroll(self.config.scroll, UIPoolType.ServerBuildingProgress, onCreateItem)
    elseif type == PopupMulti.TowerOfEitriPopupQuestItem then
        self.scroll = UILoopScroll(self.config.scroll, UIPoolType.TowerOfEitriPopupQuestItem, onCreateItem)
    end
end

--- @return void
function UIPopupMultiScrollRewardItemView:ReturnScroll()
    if self.scroll then
        self.scroll:Hide()
    end
end

--- @return void
function UIPopupMultiScrollRewardItemView:Hide()
    UIBaseView.Hide(self)
    self.rewardDict:Clear()
    self.config.empty.gameObject:SetActive(false)
    self:ReturnScroll()
    self:HideButtonClaim()
    self:ShowOneButton(false)

end

--- @return void
function UIPopupMultiScrollRewardItemView:OnReadyHide()
    UIBaseView.OnReadyHide(self)
    zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
end
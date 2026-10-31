--- @class UIEventEasterEggSelectDiceViewView : UIBaseView
UIEventEasterEggSelectDiceViewView = Class(UIEventEasterEggSelectDiceViewView, UIBaseView)

--- @param model UIEventEasterEggSelectDiceModel
function UIEventEasterEggSelectDiceViewView:Ctor(model)
    --- @type SuperDicePopupConfig
    self.config = nil
    --- @type UILoopScroll
    self.scroll = nil
    --- @type function
    self.callback = nil
    UIBaseView.Ctor(self, model)
    --- @type UIEventEasterEggSelectDiceModel
    self.model = model
end

function UIEventEasterEggSelectDiceViewView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:InitButtons()
    self:InitScroll()
    self:InitData()
end

function UIEventEasterEggSelectDiceViewView:InitData()

end

function UIEventEasterEggSelectDiceViewView:InitButtons()
    self.config.bgButton.onClick:AddListener(
            function()
                self:Hide()
            end
    )
end
function UIEventEasterEggSelectDiceViewView:InitScroll()
    --- @param obj DiceItemView
    local onCreateItem = function(obj, index)
        index = index + 1
        obj:SetIconData(index,function(value)
            self.callback(value)
            self:Hide()
        end)
    end
    self.scroll = UILoopScroll(self.config.scroll, UIPoolType.DiceItemView, onCreateItem)
end

function UIEventEasterEggSelectDiceViewView:InitLocalization()

end

--- @param callback function
function UIEventEasterEggSelectDiceViewView:OnReadyShow(callback)
    self.callback = callback
    self.scroll:Resize(6)
end

function UIEventEasterEggSelectDiceViewView:Hide()
    UIBaseView.Hide(self)
    self.scroll:Hide()
end


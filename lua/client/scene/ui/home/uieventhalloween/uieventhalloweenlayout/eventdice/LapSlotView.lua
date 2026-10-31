--- @class LapSlotView : DiceSlotView
LapSlotView = Class(LapSlotView, DiceSlotView)

function LapSlotView:Ctor(anchor, id, require)
    --- @type LapViewConfig
    self.config = nil
    self.require = require
    DiceSlotView.Ctor(self, anchor , id)
end

function LapSlotView:InitButtons()
end

function LapSlotView:InitLocalize()
    self.config.title.text = string.format(LanguageUtils.LocalizeCommon("lap_x"), self.require)
end

function LapSlotView:SetView(lapCurrent)
    self:InitLocalize()
    self.config.hideView:SetActive(self.index <= lapCurrent)
end








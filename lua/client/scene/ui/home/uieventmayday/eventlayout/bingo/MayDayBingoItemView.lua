--- @class MayDayBingoItemView : RootIconView
MayDayBingoItemView = Class(MayDayBingoItemView, RootIconView)
function MayDayBingoItemView:Ctor()
    RootIconView.Ctor(self)
end

--- @return void
function MayDayBingoItemView:SetPrefabName()
    self.prefabName = 'may_day_bingo_item'
    self.uiPoolType = UIPoolType.MayDayBingoItemView
end

--- @return void
--- @param transform UnityEngine_RectTransform
function MayDayBingoItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type MayDayBingoItem
    self.config = UIBaseConfig(transform)
end

--- @return void
function MayDayBingoItemView:SetTextBingo(text)
    self.config.textBingo.text = text
    self.config.textBingo1.text = text
end

--- @return void
function MayDayBingoItemView:SetBarActive(isActive)
    self.config.barOff.gameObject:SetActive(isActive)
end

--- @return void
function MayDayBingoItemView:SetClaimed(isClaimed)
    self.config.iconStageOff.gameObject:SetActive(isClaimed == false)
    self.config.iconStageOn.gameObject:SetActive(isClaimed)
end

return MayDayBingoItemView

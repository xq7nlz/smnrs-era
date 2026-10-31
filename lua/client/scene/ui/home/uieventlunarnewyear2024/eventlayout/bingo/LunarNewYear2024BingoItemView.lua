--- @class LunarNewYear2024BingoItemView : RootIconView
LunarNewYear2024BingoItemView = Class(LunarNewYear2024BingoItemView, RootIconView)
function LunarNewYear2024BingoItemView:Ctor()
    RootIconView.Ctor(self)
end

--- @return void
function LunarNewYear2024BingoItemView:SetPrefabName()
    self.prefabName = 'lunar_new_year_2024_bingo_item'
    self.uiPoolType = UIPoolType.LunarNewYear2024BingoItemView
end

--- @return void
--- @param transform UnityEngine_RectTransform
function LunarNewYear2024BingoItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type LunarNewYear2024BingoItem
    self.config = UIBaseConfig(transform)
end

--- @return void
function LunarNewYear2024BingoItemView:SetTextBingo(text)
    self.config.textBingo.text = text
    self.config.textBingo1.text = text
end

--- @return void
function LunarNewYear2024BingoItemView:SetBarActive(isActive)
    self.config.barOff.gameObject:SetActive(isActive)
end

--- @return void
function LunarNewYear2024BingoItemView:SetClaimed(isClaimed)
    self.config.iconStageOff.gameObject:SetActive(isClaimed == false)
    self.config.iconStageOn.gameObject:SetActive(isClaimed)
end

return LunarNewYear2024BingoItemView

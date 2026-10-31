--- @class LunarNewYearBingo2024RewardItemView : MotionIconView
LunarNewYearBingo2024RewardItemView = Class(LunarNewYearBingo2024RewardItemView, MotionIconView)

function LunarNewYearBingo2024RewardItemView:Ctor()
    --- @type PieceAdventureLevelRewardConfig
    self.config = nil
    --- @type ItemsTableView
    self.itemsTableView = nil
    MotionIconView.Ctor(self)
end

function LunarNewYearBingo2024RewardItemView:SetPrefabName()
    self.prefabName = 'lunar_new_year_bingo_2024_reward_item_view'
    self.uiPoolType = UIPoolType.LunarNewYearBingo2024RewardItemView
end

--- @param transform UnityEngine_Transform
function LunarNewYearBingo2024RewardItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    self.config = UIBaseConfig(transform)
    self.itemsTableView = ItemsTableView(self.config.rewardAnchor)
end

function LunarNewYearBingo2024RewardItemView:InitLocalization()
    self.config.textLevel.text = LanguageUtils.LocalizeCommon("bingo")
end

function LunarNewYearBingo2024RewardItemView:ReturnPool()
    IconView.ReturnPool(self)
    self.itemsTableView:Hide()
end

--- @param level number
--- @param listRewardInBound List
function LunarNewYearBingo2024RewardItemView:SetData(level, listRewardInBound)
    self.config.textLevel.text = string.format("%s %s", LanguageUtils.LocalizeCommon("bingo"), level)
    self.itemsTableView:SetData(RewardInBound.GetItemIconDataList(listRewardInBound))
end

--- @param isClaimed boolean
function LunarNewYearBingo2024RewardItemView:SetClaim(isClaimed)
    self.itemsTableView:ActiveMaskSelect(isClaimed)
end

--- @param isHighlight boolean
function LunarNewYearBingo2024RewardItemView:Highlight(isHighlight)
    self.config.highLight:SetActive(isHighlight)
end

return LunarNewYearBingo2024RewardItemView
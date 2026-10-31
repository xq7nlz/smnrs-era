--- @class MayDayBingoRewardItemView : MotionIconView
MayDayBingoRewardItemView = Class(MayDayBingoRewardItemView, MotionIconView)

function MayDayBingoRewardItemView:Ctor()
    --- @type PieceAdventureLevelRewardConfig
    self.config = nil
    --- @type ItemsTableView
    self.itemsTableView = nil
    MotionIconView.Ctor(self)
end

function MayDayBingoRewardItemView:SetPrefabName()
    self.prefabName = 'may_day_bingo_reward_item_view'
    self.uiPoolType = UIPoolType.MayDayBingoRewardItemView
end

--- @param transform UnityEngine_Transform
function MayDayBingoRewardItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    self.config = UIBaseConfig(transform)
    self.itemsTableView = ItemsTableView(self.config.rewardAnchor)
end

function MayDayBingoRewardItemView:InitLocalization()
    self.config.textLevel.text = LanguageUtils.LocalizeCommon("bingo")
end

function MayDayBingoRewardItemView:ReturnPool()
    IconView.ReturnPool(self)
    self.itemsTableView:Hide()
end

--- @param level number
--- @param listRewardInBound List
function MayDayBingoRewardItemView:SetData(level, listRewardInBound)
    self.config.textLevel.text = string.format("%s %s", LanguageUtils.LocalizeCommon("bingo"), level)
    self.itemsTableView:SetData(RewardInBound.GetItemIconDataList(listRewardInBound))
end

--- @param isClaimed boolean
function MayDayBingoRewardItemView:SetClaim(isClaimed)
    self.itemsTableView:ActiveMaskSelect(isClaimed)
end

--- @param isHighlight boolean
function MayDayBingoRewardItemView:Highlight(isHighlight)
    self.config.highLight:SetActive(isHighlight)
end

return MayDayBingoRewardItemView
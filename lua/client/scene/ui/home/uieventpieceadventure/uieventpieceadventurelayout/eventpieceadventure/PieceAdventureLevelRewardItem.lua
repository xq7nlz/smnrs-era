--- @class PieceAdventureLevelRewardItem : MotionIconView
PieceAdventureLevelRewardItem = Class(PieceAdventureLevelRewardItem, MotionIconView)

function PieceAdventureLevelRewardItem:Ctor()
    --- @type PieceAdventureLevelRewardConfig
    self.config = nil
    --- @type ItemsTableView
    self.itemsTableView = nil
    MotionIconView.Ctor(self)
end

function PieceAdventureLevelRewardItem:SetPrefabName()
    self.prefabName = 'piece_adventure_level_reward'
    self.uiPoolType = UIPoolType.PieceAdventureLevelRewardItem
end

--- @param transform UnityEngine_Transform
function PieceAdventureLevelRewardItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    self.config = UIBaseConfig(transform)
    self.itemsTableView = ItemsTableView(self.config.rewardAnchor)
end

function PieceAdventureLevelRewardItem:InitLocalization()
    self.config.textLevel.text = LanguageUtils.LocalizeCommon("floor")
end

function PieceAdventureLevelRewardItem:ReturnPool()
    IconView.ReturnPool(self)
    self.itemsTableView:Hide()
end

--- @param level number
--- @param listRewardInBound List
function PieceAdventureLevelRewardItem:SetData(level, listRewardInBound)
    self.config.textLevel.text = string.format("%s %s", LanguageUtils.LocalizeCommon("floor"), level)
    self.itemsTableView:SetData(RewardInBound.GetItemIconDataList(listRewardInBound))
end

--- @param isClaimed boolean
function PieceAdventureLevelRewardItem:SetClaim(isClaimed)
    --- @param iconView IconView
    for _, iconView in ipairs(self.itemsTableView.iconViewList:GetItems()) do
        iconView:ActiveMask(isClaimed)
    end
end

--- @param isHighlight boolean
function PieceAdventureLevelRewardItem:Highlight(isHighlight)
    self.config.highLight:SetActive(isHighlight)
end

return PieceAdventureLevelRewardItem
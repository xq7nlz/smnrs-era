--- @class FeedBeastLevelRewardItem : MotionIconView
FeedBeastLevelRewardItem = Class(FeedBeastLevelRewardItem, MotionIconView)

function FeedBeastLevelRewardItem:Ctor()
    --- @type FeedBeastLevelRewardItemConfig
    self.config = nil
    --- @type ItemsTableView
    self.itemsTableView = nil
    MotionIconView.Ctor(self)
end

function FeedBeastLevelRewardItem:SetPrefabName()
    self.prefabName = 'feed_beast_level_reward'
    self.uiPoolType = UIPoolType.FeedBeastLevelRewardItem
end

--- @param transform UnityEngine_Transform
function FeedBeastLevelRewardItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    self.config = UIBaseConfig(transform)
    self.itemsTableView = ItemsTableView(self.config.rewardAnchor)
end

function FeedBeastLevelRewardItem:InitLocalization()
    self.config.textLevel.text = LanguageUtils.LocalizeCommon("level")
end

function FeedBeastLevelRewardItem:ReturnPool()
    IconView.ReturnPool(self)
    self.itemsTableView:Hide()
end

--- @param level number
--- @param listRewardInBound List
function FeedBeastLevelRewardItem:SetData(level, listRewardInBound)
    self.config.textLevel.text = string.format("%s %s", LanguageUtils.LocalizeCommon("level"), level)
    self.itemsTableView:SetData(RewardInBound.GetItemIconDataList(listRewardInBound))
end

--- @param isClaimed boolean
function FeedBeastLevelRewardItem:SetClaim(isClaimed)
    self.itemsTableView:ActiveMaskSelect(isClaimed)
end

--- @param isHighlight boolean
function FeedBeastLevelRewardItem:Highlight(isHighlight)
    self.config.highLight:SetActive(isHighlight)
end

return FeedBeastLevelRewardItem
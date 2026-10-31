--- @class WishRewardItem : MotionIconView
WishRewardItem = Class(WishRewardItem, MotionIconView)

function WishRewardItem:Ctor()
    --- @type WishRewardItemConfig
    self.config = nil
    --- @type ItemsTableView
    self.itemsTableView = nil
    MotionIconView.Ctor(self)
end

function WishRewardItem:SetPrefabName()
    self.prefabName = 'wish_reward_item'
    self.uiPoolType = UIPoolType.WishRewardItem
end

--- @param transform UnityEngine_Transform
function WishRewardItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    self.config = UIBaseConfig(transform)
    self.itemsTableView = ItemsTableView(self.config.rewardAnchor)
end

function WishRewardItem:InitLocalization()
    self.config.textLevel.text = LanguageUtils.LocalizeCommon("roll")
end

function WishRewardItem:ReturnPool()
    IconView.ReturnPool(self)
    self.itemsTableView:Hide()
end

--- @param level number
--- @param listRewardInBound List
function WishRewardItem:SetData(level, listRewardInBound)
    self.config.textLevel.text = string.format("%s %s", LanguageUtils.LocalizeCommon("roll"), level)
    self.itemsTableView:SetData(RewardInBound.GetItemIconDataList(listRewardInBound))
end

--- @param isClaimed boolean
function WishRewardItem:SetClaim(isClaimed)
    self.itemsTableView:ActiveMaskSelect(isClaimed)
end

--- @param isHighlight boolean
function WishRewardItem:Highlight(isHighlight)
    self.config.highLight:SetActive(isHighlight)
end

return WishRewardItem
--- @class ScrollRewardItem : MotionIconView
ScrollRewardItem = Class(ScrollRewardItem, MotionIconView)

--- @return void
function ScrollRewardItem:Ctor()
    ---@type ScrollRewardItemConfig
    self.config = nil
    --- @type UILoopScroll
    self.scroll = nil
    MotionIconView.Ctor(self)
end

function ScrollRewardItem:SetPrefabName()
    self.prefabName = 'scroll_reward_item'
    self.uiPoolType = UIPoolType.ScrollRewardItem
end

--- @param transform UnityEngine_Transform
function ScrollRewardItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type ScrollRewardItemConfig
    self.config = UIBaseConfig(transform)
end

function ScrollRewardItem:SetItemData(rewardList, localize)
    self.config.labelText.text = localize or "N/a"
    --- @param obj RootIconView
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        ---@type RewardInBound
        local rewardInBound = rewardList:Get(dataIndex)
        --- @type EventBattlePassModel
        obj:SetIconData(rewardInBound:GetIconData())
        obj:RegisterShowInfo()
        obj:SetSize()
    end
    self.scroll = UILoopScroll(self.config.scrollReward, UIPoolType.RootIconView, onCreateItem)
end

function ScrollRewardItem:Resize(count)
    self.scroll:Resize(count)
end
function ScrollRewardItem:ReturnPool()
    MotionIconView.ReturnPool(self)
    if self.scroll then
        self.scroll:Hide()
    end
end

return ScrollRewardItem
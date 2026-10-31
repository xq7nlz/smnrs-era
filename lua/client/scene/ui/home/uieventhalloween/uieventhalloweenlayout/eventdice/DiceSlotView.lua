--- @class DiceSlotView
DiceSlotView = Class(DiceSlotView)

function DiceSlotView:Ctor(anchor, index)
    --- @type DiceViewConfig
    self.config = nil

    self.anchor = anchor

    self.index = index
    ---@type RewardInBound
    self:InitView()
end

function DiceSlotView:InitView()
    self.config = UIBaseConfig(self.anchor)
    ---@type MoneyIconView
end

--- @param rewardList List -- RewardInBound
function DiceSlotView:SetReward(rewardList)
    ---@type List<RewardInBound>
    self.rewardList = rewardList
    self.rewardDataList = List()
    for i = 1, self.rewardList:Count() do
        local data = self.rewardList:Get(i)
        self.rewardDataList:Add(data:GetIconData())
    end
    if self.rewardList:Count() > 0 then
        --- @type RootIconView
        local moneyView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardAnchor)
        --- @type RewardInBound
        local reward = self.rewardList:Get(1)

        moneyView:SetIconData(reward:GetIconData())
        moneyView:RegisterShowInfo()
    end
end

function DiceSlotView:SetEnableFrame(isEnable)
    if isEnable == false then
        return
    end
    self.config.lightFrame.color = U_Color(1,1,1,1)
    self.config.lightFrame.gameObject:SetActive(true)
    self.config.lightFrame:DOColor(U_Color(1,1,1,0), 0.5):OnComplete(function()
        self.config.lightFrame.gameObject:SetActive(false)
    end)
end

function DiceSlotView:SetEnableArrow(isEnable)
    self.config.arrow:SetActive(isEnable)
end

function DiceSlotView:SetView(isEnable)
    self.config.hideView:SetActive(isEnable)
    self.config.diceResetEffect:SetActive(false)
end

function DiceSlotView:IsEnableBg(isEnable)
    self.config.bg.enabled = isEnable
end

function DiceSlotView:ShowEffect()
    self.config.diceResetEffect:SetActive(true)
end


---@param effectScale UnityEngine_Vector3
---@param frameScale UnityEngine_Vector3
function DiceSlotView:SetScale(effectScale, frameScale)
    self.config.diceResetEffect.transform.localScale = effectScale
    self.config.lightFrame.transform.localScale = frameScale
end

function DiceSlotView:ShowRewardInbound()
    for i = 1, self.rewardList:Count() do
        local data = self.rewardList:Get(i)
        InventoryUtils.Add(data.type, data.id, data.number, data.data or nil)
    end
    PopupUtils.ShowRewardList(self.rewardDataList)
end





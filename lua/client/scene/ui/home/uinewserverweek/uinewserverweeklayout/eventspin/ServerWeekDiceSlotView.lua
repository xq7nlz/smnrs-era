--- @class EventServerWeekDiceSlotView
EventServerWeekDiceSlotView = Class(EventServerWeekDiceSlotView)

function EventServerWeekDiceSlotView:Ctor(anchor, index)
    --- @type ServerWeekDiceSlotViewConfig
    self.config = nil

    self.anchor = anchor

    self.index = index
    ---@type RewardInBound
    self:InitView()
end

function EventServerWeekDiceSlotView:InitView()
    self.config = UIBaseConfig(self.anchor)
    ---@type MoneyIconView
end

--- @param rewardList List -- RewardInBound
function EventServerWeekDiceSlotView:SetReward(reward)
    --- @type RewardInBound
    self.reward = reward
    self.rewardData = reward:GetIconData()
    --- @type RootIconView
    local moneyView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardAnchor)
    moneyView:SetIconData(reward:GetIconData())
    moneyView:RegisterShowInfo()
end

function EventServerWeekDiceSlotView:SetEnableFrame(isEnable)
    if isEnable == false then
        return
    end
    self.config.lightFrame.color = U_Color(1,1,1,1)
    self.config.lightFrame.gameObject:SetActive(true)
    self.config.lightFrame:DOColor(U_Color(1,1,1,0), 0.5):OnComplete(function()
        self.config.lightFrame.gameObject:SetActive(false)
    end)
end

function EventServerWeekDiceSlotView:SetEnableArrow(isEnable)
    self.config.arrow:SetActive(isEnable)
end

function EventServerWeekDiceSlotView:SetView(isEnable) -- true is checked
    self.config.hideView:SetActive(isEnable)
    self.config.diceResetEffect:SetActive(false)
end

function EventServerWeekDiceSlotView:IsEnableBg(isEnable)
    self.config.bg.enabled = isEnable
end

function EventServerWeekDiceSlotView:ShowEffect()
    self.config.diceResetEffect:SetActive(true)
end


---@param effectScale UnityEngine_Vector3
---@param frameScale UnityEngine_Vector3
function EventServerWeekDiceSlotView:SetScale(effectScale, frameScale)
    self.config.diceResetEffect.transform.localScale = effectScale
    self.config.lightFrame.transform.localScale = frameScale
end

function EventServerWeekDiceSlotView:ShowRewardInbound(callback)
    local listReward = List()
    listReward:Add(self.reward)
    PopupUtils.ClaimAndShowRewardList(listReward)
   -- SmartPoolUtils.ShowReward1Item(, callback)
end





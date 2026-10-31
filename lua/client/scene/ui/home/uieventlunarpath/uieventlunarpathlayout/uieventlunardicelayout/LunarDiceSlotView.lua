--- @class LunarDiceSlotView
LunarDiceSlotView = Class(LunarDiceSlotView)

--- @param anchor UnityEngine_Transform
function LunarDiceSlotView:Ctor(anchor, index, isLastIndex)
    --- @type LunarDiceSlotConfig
    self.config = nil
    --- @type RootIconView
    self.rootIconView = nil
    --- @type UnityEngine_Transform
    self.anchor = anchor
    --- @type number
    self.index = index
    --- @type boolean
    self.isLastIndex = isLastIndex
    ---@type RewardInBound
    self:InitView(isLastIndex)
end

function LunarDiceSlotView:InitView(isLastIndex)
    self.config = UIBaseConfig(self.anchor)
    self.config.bgStart:SetActive(false)
    self.config.bgFinish:SetActive(false)
    self.config.bgNormal:SetActive(false)

    if self.index == 0 then
        self.config.bgStart:SetActive(true)
    elseif isLastIndex then
        self.config.bgFinish:SetActive(true)
    else
        self.config.bgNormal:SetActive(true)
        self.config.textStartEnd.text = ""
    end

    if self.index > 0 then
        self.config.textSlot.text = tostring(self.index)
    else
        self.config.textSlot.text = ""
    end

    self:InitLocalization()
end

function LunarDiceSlotView:InitLocalization()
    if self.index == 0 then
        self.config.textStartEnd.text = LanguageUtils.LocalizeCommon("start")
    elseif self.isLastIndex then
        self.config.textStartEnd.text = LanguageUtils.LocalizeCommon("finish")
    end
end

--- @param parent UnityEngine_RectTransform
function LunarDiceSlotView:SetParent(parent)
    UIUtils.SetParent(self.config.transform, parent)
end

--- @param rewardInBound RewardInBound
function LunarDiceSlotView:SetReward(rewardInBound)
    self.config.textSlot.gameObject:SetActive(rewardInBound == nil)
    if rewardInBound == nil then
        self:HideReward()
        return
    end
    if self.rootIconView == nil then
        self.rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardAnchor)
    end
    self.rootIconView:SetIconData(rewardInBound:GetIconData())
    self.rootIconView:RegisterShowInfo()
end

function LunarDiceSlotView:SetEnableFrame(isEnable)
    if isEnable == false then
        return
    end
    self.config.lightFrame.color = U_Color(1, 1, 1, 1)
    self.config.lightFrame.gameObject:SetActive(true)
    self.config.lightFrame:DOColor(U_Color(1, 1, 1, 0), 0.5):OnComplete(function()
        self.config.lightFrame.gameObject:SetActive(false)
    end)
end
function LunarDiceSlotView:SetEnableArrow(isEnable)
    self.config.arrow:SetActive(isEnable)
end

function LunarDiceSlotView:SetView(isEnable)
    self:ShowEffect(isEnable)
    self:EnableClaim(isEnable)
end

function LunarDiceSlotView:HideEffect()
    self:ShowEffect(false)
    self:EnableClaim(false)
end

function LunarDiceSlotView:IsEnableBg(isEnable)
    self.config.bg.enabled = isEnable
end

function LunarDiceSlotView:ShowEffect(isShow)
    self.config.diceResetEffect:SetActive(isShow)
end

---@param effectScale UnityEngine_Vector3
---@param frameScale UnityEngine_Vector3
function LunarDiceSlotView:SetScale(effectScale, frameScale)
    self.config.diceResetEffect.transform.localScale = effectScale
    self.config.lightFrame.transform.localScale = frameScale
end

function LunarDiceSlotView:ShowRewardInbound()
    for i = 1, self.rewardList:Count() do
        local data = self.rewardList:Get(i)
        InventoryUtils.Add(data.type, data.id, data.number)
    end
    PopupUtils.ShowRewardList(self.rewardDataList)
end

function LunarDiceSlotView:HideReward()
    if self.rootIconView ~= nil then
        self.rootIconView:ReturnPool()
        self.rootIconView = nil
    end
end

function LunarDiceSlotView:EnableClaim(isEnable)
    if self.rootIconView ~= nil then
        self.rootIconView:ActiveMaskSelect(isEnable)
    end
end

function LunarDiceSlotView:DoShake()
    --- @type DG_Tweening_LoopType
    local U_LoopType = CS.DG.Tweening.LoopType
    DOTweenUtils.DOLocalMoveY(self.config.visual.transform, -20, 0.15, U_Ease.InQuad, nil, 2, U_LoopType.Yoyo)
end
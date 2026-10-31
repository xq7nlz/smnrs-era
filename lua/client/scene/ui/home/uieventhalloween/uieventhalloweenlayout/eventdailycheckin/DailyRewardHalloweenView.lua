--- @class DailyRewardHalloweenView : DailyRewardMultiItemView
DailyRewardHalloweenView = Class(DailyRewardHalloweenView, DailyRewardMultiItemView)

--- @return void
function DailyRewardHalloweenView:Ctor(onClickClaim)
    ---@type DailyRewardHalloweenConfig
    self.config = nil

    DailyRewardMultiItemView.Ctor(self)

    self.onClickClaim = onClickClaim

    self.config.freeText.text = LanguageUtils.LocalizeCommon("free")
    self:InitButtons()
end

--- @return void
function DailyRewardHalloweenView:SetPrefabName()
    self.prefabName = 'daily_reward_halloween'
    self.uiPoolType = UIPoolType.DailyRewardHalloweenView
end

--- @return void
function DailyRewardHalloweenView:InitButtons()
    self.config.buyButton.onClick:AddListener(function()
        local canBuy = InventoryUtils.IsEnoughSingleResourceRequirement(self.priceReward)
        if canBuy then
            if self.onClickClaim ~= nil then
                self.onClickClaim(self.day, self.priceReward, false)
            end
        end
    end)
    self.config.freeButton.onClick:AddListener(function()
        if self.onClickClaim ~= nil then
            self.onClickClaim(self.day, self.priceReward, true)
        end
    end)
end
---@param loginDataConfig EventHalloweenLoginDataConfig
function DailyRewardHalloweenView:FillLoginData(loginDataConfig, day)
    DailyRewardMultiItemView.FillData(self, loginDataConfig:GetRewardList(), day)
    ---@type RewardInBound
    self.priceReward = loginDataConfig:GetBuyPrice()
    self.config.iconCurrency.sprite = ResourceLoadUtils.LoadMoneyIcon(self.priceReward.id)
    self.config.buyPriceText.text = self.priceReward.number
end

--- @return void
function DailyRewardHalloweenView:SetClaim(isClaimed)
    self.light:SetActive(isClaimed == false)
    self.config.bg2.gameObject:SetActive(isClaimed == true)
    if isClaimed ~= nil then
        self:SetActiveColor2(not isClaimed)
    else
        self:SetActiveColor2(true)
    end
end
--- @return void
function DailyRewardHalloweenView:TurnOffColor2()
    for i = 1, self.iconViewList:Count() do
        self.iconViewList:Get(i):SetActiveColor2(false)
    end
end
function DailyRewardHalloweenView:SetLock()
    for i = 1, self.iconViewList:Count() do
        ---@type IconView
        local iconView = self.iconViewList:Get(i)
        iconView:ActiveMaskLockMini(true)
    end
end

function DailyRewardHalloweenView:SetEnableFreeButton(isEnable)
    Coroutine.start(function()
        coroutine.waitforendofframe()
        if isEnable == nil then
            self.config.freeButton.gameObject:SetActive(false)
            self.config.buyButton.gameObject:SetActive(false)
        else
            self.config.freeButton.gameObject:SetActive(isEnable)
            self.config.buyButton.gameObject:SetActive(not isEnable)
        end
    end)
end

function DailyRewardHalloweenView:SetUnLock()
    for i = 1, self.iconViewList:Count() do
        ---@type IconView
        local iconView = self.iconViewList:Get(i)
        iconView:ActiveMaskLockMini(false)
    end
end

function DailyRewardHalloweenView:SetDay7()
    self.light = self.config.light2
    self.config.verticalReward.transform.localScale = U_Vector3(1.2, 1.2, 1.2)
    self.config.textDailyCheckinDay.transform.localPosition = U_Vector3(0, 215, 0)
    self.config.textDailyCheckinDay.transform.localScale = U_Vector3(1, 1, 1)
    self.config.bgItemReward.gameObject:SetActive(true)
    self.config.dailyCheckinTag2.gameObject:SetActive(true)
    self.config.dailyCheckinTag.gameObject:SetActive(false)
end

function DailyRewardHalloweenView:SetNormalDay()
    self.light = self.config.light
    self.config.verticalReward.transform.localScale = U_Vector3(1, 1, 1)
    self.config.textDailyCheckinDay.transform.localPosition = U_Vector3(0, 154.2, 0)
    self.config.bgItemReward.gameObject:SetActive(false)
    self.config.dailyCheckinTag2.gameObject:SetActive(false)
    self.config.dailyCheckinTag.gameObject:SetActive(true)
end

return DailyRewardHalloweenView


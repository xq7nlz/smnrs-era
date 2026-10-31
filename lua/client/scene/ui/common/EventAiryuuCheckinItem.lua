--- @class EventAiryuuCheckinItem : MotionIconView
EventAiryuuCheckinItem = Class(EventAiryuuCheckinItem, MotionIconView)

--- @return void
function EventAiryuuCheckinItem:Ctor()
    ---@type UIEventAiryuuCheckinItemConfig
    self.config = nil
    --- @type RootIconView
    self.rootIconView = nil
    ---@type MoneyIconView
    self.itemIconView = nil
    ---@type function
    self.onClickCheckin = nil
    MotionIconView.Ctor(self)
end

function EventAiryuuCheckinItem:SetPrefabName()
    self.prefabName = 'event_airyuu_checkin_item'
    self.uiPoolType = UIPoolType.EventAiryuuCheckinItem
end

--- @param transform UnityEngine_Transform
function EventAiryuuCheckinItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIEventAiryuuCheckinItemConfig
    self.config = UIBaseConfig(transform)
    self:InitButton()
    self:InitLocalize()
end

function EventAiryuuCheckinItem:InitButton()
    --self.config.button.onClick:AddListener(function()
    --    if self.onClickCheckin then
    --        self.onClickCheckin()
    --    end
    --end)
    self.config.checkinButton.onClick:AddListener(function()
        if self.onClickCheckin then
            self.onClickCheckin()
        end
    end)
    self.config.recheckinButton.onClick:AddListener(function()
        if self.onClickCheckin then
            self.onClickCheckin()
        end
    end)
    --UIUtils.SetActiveColorByMaterial(self.config.claimedButton.gameObject, true, "ui_disable_mat")
    self.config.claimedButton.onClick:AddListener(function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("claimed"))
    end)
end

---@param available boolean
function EventAiryuuCheckinItem:InitLocalize()
    self.config.checkinLocalize.text = LanguageUtils.LocalizeCommon("daily_checkin")
    self.config.recheckinLocalize.text = LanguageUtils.LocalizeCommon("recheckin")
    self.config.claimedLocalize.text = LanguageUtils.LocalizeCommon("claimed")
end

function EventAiryuuCheckinItem:IsFreeButton(isFree)
    if isFree ~= nil then
        self.config.checkinButton.gameObject:SetActive(isFree)
        self.config.recheckinButton.gameObject:SetActive(not isFree)
    else
        self.config.checkinButton.gameObject:SetActive(false)
        self.config.recheckinButton.gameObject:SetActive(false)
    end
end

function EventAiryuuCheckinItem:IsLock(isLock)
    --self.config.darkBg.gameObject:SetActive(isLock or false)
    if isLock then
        self:IsFreeButton()
        self:HasNoti()
    end
end

function EventAiryuuCheckinItem:IsClaimed(isClaimed)
    self.config.claimedButton.gameObject:SetActive(isClaimed or false)
    if isClaimed then
        self:IsLock()
        self:IsFreeButton()
        self:HasNoti()
    end
end

function EventAiryuuCheckinItem:HasNoti(hasNoti)
    self.config.noti.gameObject:SetActive(hasNoti or false)
end

function EventAiryuuCheckinItem:SetItemData(day, loginRewardDict, isReclaim)
    local moneyData = loginRewardDict.moneyData
    local rewardInBound = loginRewardDict.rewardInBound
    self.day = day
    self.rewardInBound = rewardInBound
    self.isReclaim = isReclaim
    self:SetMoneyReward(moneyData)
    self:SetItemReward(rewardInBound)
    self.config.textDay.text = string.format("%s: %s", LanguageUtils.LocalizeCommon("day_only"), tostring(day))
    self:InitLocalize()
end

function EventAiryuuCheckinItem:SetMoneyReward(moneyData)
    self.config.recheckinIconMoney.sprite = ResourceLoadUtils.LoadMoneyIcon(moneyData.moneyType)
    self.config.recheckinPrice.text = moneyData.moneyValue
end

---@param rewardInBound RewardInBound
function EventAiryuuCheckinItem:SetItemReward(rewardInBound)
    if self.rootIconView == nil and rewardInBound ~= nil then
        self.rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.itemAnchor)
    end
    self.rootIconView:SetIconData(rewardInBound:GetIconData())
    self.rootIconView:RegisterShowInfo()
end

function EventAiryuuCheckinItem:ReturnPool()
    MotionIconView.ReturnPool(self)
end

return EventAiryuuCheckinItem
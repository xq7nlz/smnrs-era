--- @class EventSeasonalCheckinItem : MotionIconView
EventSeasonalCheckinItem = Class(EventSeasonalCheckinItem, MotionIconView)

--- @return void
function EventSeasonalCheckinItem:Ctor()
    ---@type EventSeasonalCheckinItemConfig
    self.config = nil
    --- @type RootIconView
    self.rootIconView = nil
    ---@type MoneyIconView
    self.itemIconView = nil
    ---@type List
    self.listRewardIcon = List()
    MotionIconView.Ctor(self)
end

function EventSeasonalCheckinItem:SetPrefabName()
    self.prefabName = 'event_seasonal_checkin_item'
    self.uiPoolType = UIPoolType.EventSeasonalCheckinItem
end

--- @param transform UnityEngine_Transform
function EventSeasonalCheckinItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type EventSeasonalCheckinItemConfig
    self.config = UIBaseConfig(transform)
end

function EventSeasonalCheckinItem:AddListener(func)
    self:RemoveAllListeners()
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    self.config.button.onClick:AddListener(function()
        if func then
            func()
        end
    end)
end

function EventSeasonalCheckinItem:RemoveAllListeners()
    self.config.button.onClick:RemoveAllListeners()
end

function EventSeasonalCheckinItem:IsLock(isLock)
    self.config.darkBg.gameObject:SetActive(isLock)
    if isLock then
        self:HasNoti(false)
    end
end

function EventSeasonalCheckinItem:IsClaimed(isClaimed)
    self:EnableListRewardIconTick(isClaimed)
    if isClaimed then
        self:IsLock(false)
        self:AddListener(function()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("claimed"))
        end)
    end
end

function EventSeasonalCheckinItem:HasNoti(hasNoti)
    self.config.noti.gameObject:SetActive(hasNoti or false)
end

function EventSeasonalCheckinItem:SetTextDay(day)
    self.config.textDay.text = string.format("%s %s", LanguageUtils.LocalizeCommon("day_only"), tostring(day))
end

function EventSeasonalCheckinItem:SetItemData(day, loginRewardDict)
    self:SetTextDay(day)
    if day % 2 == 0 then
        local vector3 = self.config.dOTween.endValueV3
        vector3.y = 10
        self.config.dOTween.endValueV3 = vector3
        self.config.dOTween:DORestart()
    end
    self:SetItemReward(loginRewardDict.listReward)
    self:AddListener(function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("not_day_checkin"))
    end)
end

---@param listReward List | RewardInBound
function EventSeasonalCheckinItem:SetItemReward(listReward)
    ---@param v RewardInBound
    for _, v in pairs(listReward:GetItems()) do
        ---@type RootIconView
        local rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.itemAnchor)
        rootIconView:SetIconData(v:GetIconData())
        rootIconView:RegisterShowInfo()
        self.listRewardIcon:Add(rootIconView)
    end
end

function EventSeasonalCheckinItem:EnableListRewardIconTick(isEnable)
    ---@param v RootIconView
    for _, v in pairs(self.listRewardIcon:GetItems()) do
        if v ~= nil then
            v:ActiveTickSelect(isEnable)
        end
    end
end

function EventSeasonalCheckinItem:ListRewardIconReturnPool()
    ---@param v RootIconView
    for _, v in pairs(self.listRewardIcon:GetItems()) do
        if v ~= nil then
            v:ReturnPool()
        end
    end
    self.listRewardIcon:Clear()
end

function EventSeasonalCheckinItem:ReturnPool()
    MotionIconView.ReturnPool(self)
    self:RemoveAllListeners()
    self:ListRewardIconReturnPool()
    self:HasNoti(false)
    self:IsLock(false)
end

return EventSeasonalCheckinItem
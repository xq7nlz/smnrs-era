--- @class BlackFridayDailyRewardView : MotionIconView
BlackFridayDailyRewardView = Class(BlackFridayDailyRewardView, MotionIconView)

--- @return void
function BlackFridayDailyRewardView:Ctor()
    ---@type List -- <RootIconView>
    self.iconViewList = List()
    MotionIconView.Ctor(self)
end

--- @return void
function BlackFridayDailyRewardView:SetPrefabName()
    self.prefabName = 'black_friday_daily_reward_item'
    self.uiPoolType = UIPoolType.BlackFridayRewardMultiItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function BlackFridayDailyRewardView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type DailyRewardMultiItemConfig
    self.config = UIBaseConfig(transform)
end

function BlackFridayDailyRewardView:FillData(dataList, day)
    self.dataList = dataList
    self.day = day
    self:SetTile( string.format(LanguageUtils.LocalizeCommon("day_x"), day))
    local count = self.iconViewList:Count()
    if count > 0 then
        for i = 1, count do
            local iconView = self.iconViewList:Get(i)
            if iconView == nil then
                iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.item)
            end
            iconView:SetIconData(dataList:Get(i):GetIconData())
        end
    else
        count = dataList:Count()
        for i = 1, count do
            local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.item)
            iconView:SetIconData(dataList:Get(i):GetIconData())
            self.iconViewList:Add(iconView)
        end
    end
    self:RegisterShowInfo()
end

function BlackFridayDailyRewardView:SetTile(tile)
    self.config.textDailyCheckinDay.text = tile
    if self.config.textDailyCheckinDay7 ~= nil then
        self.config.textDailyCheckinDay7.text = tile
    end
end

function BlackFridayDailyRewardView:SetItemName(name)
    self.config.textHeroName.text = name
end

--- @return void
function BlackFridayDailyRewardView:SetClaim(isClaimed)
    self.config.light:SetActive(isClaimed == false)
    self.config.bg2.gameObject:SetActive(isClaimed == true)
end

function BlackFridayDailyRewardView:EnableHighlight()

end

--- @return void
function BlackFridayDailyRewardView:RegisterShowInfo()
    local count = self.iconViewList:Count()
    if count > 0 then
        for i = 1, count do
            self.iconViewList:Get(i):RegisterShowInfo()
        end
    end
end

--- @return void
function BlackFridayDailyRewardView:RemoveAllListeners()
    local count = self.iconViewList:Count()
    if count > 0 then
        for i = 1, count do
            self.iconViewList:Get(i):RemoveAllListeners()
        end
    end
end
--- @return void
---@param func function
function BlackFridayDailyRewardView:AddListener(func)
    self:EnableButton(true)
    self.config.button.onClick:AddListener(func)
end

--- @return void
function BlackFridayDailyRewardView:RemoveAllListeners()
    self:EnableButton(false)
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function BlackFridayDailyRewardView:EnableButton(enabled)
    UIUtils.SetInteractableButton(self.config.button, enabled)
    self.config.bg.raycastTarget = enabled
    self.config.bg2.raycastTarget = enabled
end

--- @return void
--- @param enabled boolean
function BlackFridayDailyRewardView:EnableRaycast(enabled)
    self.config.bg.raycastTarget = enabled
    self.config.bg2.raycastTarget = enabled
end

--- @return void
function BlackFridayDailyRewardView:ReturnPool()
    MotionIconView.ReturnPool(self)
    self:ReturnPoolItem()
end

function BlackFridayDailyRewardView:ReturnPoolItem()
    local count = self.iconViewList:Count()
    if count > 0 then
        for i = 1, count do
            self.iconViewList:Get(i):ReturnPool()
        end
        self.iconViewList:Clear()
    end
end

return BlackFridayDailyRewardView
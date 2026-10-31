--- @class DailyRewardMultiItemView : MotionIconView
DailyRewardMultiItemView = Class(DailyRewardMultiItemView, MotionIconView)

--- @return void
function DailyRewardMultiItemView:Ctor()
    ---@type List -- <RootIconView>
    self.iconViewList = List()
    MotionIconView.Ctor(self)
end

--- @return void
function DailyRewardMultiItemView:SetPrefabName()
    self.prefabName = 'daily_multi_reward_item'
    self.uiPoolType = UIPoolType.DailyRewardMultiItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function DailyRewardMultiItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type DailyRewardMultiItemConfig
    self.config = UIBaseConfig(transform)
end

function DailyRewardMultiItemView:FillData(dataList, day)
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

function DailyRewardMultiItemView:SetTile(tile)
    self.config.textDailyCheckinDay.text = tile
    if self.config.textDailyCheckinDay7 ~= nil then
        self.config.textDailyCheckinDay7.text = tile
    end
end

function DailyRewardMultiItemView:SetItemName(name)
    self.config.textHeroName.text = name
end

--- @return void
function DailyRewardMultiItemView:SetClaim(isClaimed)
    self.config.light:SetActive(isClaimed == false)
    self.config.bg2.gameObject:SetActive(isClaimed == true)
end

function DailyRewardMultiItemView:EnableHighlight()

end

--- @return void
function DailyRewardMultiItemView:RegisterShowInfo()
    local count = self.iconViewList:Count()
    if count > 0 then
        for i = 1, count do
            self.iconViewList:Get(i):RegisterShowInfo()
        end
    end
end

--- @return void
function DailyRewardMultiItemView:RemoveAllListeners()
    local count = self.iconViewList:Count()
    if count > 0 then
        for i = 1, count do
            self.iconViewList:Get(i):RemoveAllListeners()
        end
    end
end
--- @return void
---@param func function
function DailyRewardMultiItemView:AddListener(func)
    self:EnableButton(true)
    self.config.button.onClick:AddListener(func)
end

--- @return void
function DailyRewardMultiItemView:RemoveAllListeners()
    self:EnableButton(false)
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function DailyRewardMultiItemView:EnableButton(enabled)
    UIUtils.SetInteractableButton(self.config.button, enabled)
    self.config.bg.raycastTarget = enabled
    self.config.bg2.raycastTarget = enabled
end

--- @return void
--- @param enabled boolean
function DailyRewardMultiItemView:EnableRaycast(enabled)
    self.config.bg.raycastTarget = enabled
    self.config.bg2.raycastTarget = enabled
end

--- @return void
function DailyRewardMultiItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
    self:ReturnPoolItem()
end

function DailyRewardMultiItemView:ReturnPoolItem()
    local count = self.iconViewList:Count()
    if count > 0 then
        for i = 1, count do
            self.iconViewList:Get(i):ReturnPool()
        end
        self.iconViewList:Clear()
    end
end

return DailyRewardMultiItemView
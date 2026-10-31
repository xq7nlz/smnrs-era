--- @class DailyRewardItemView : MotionIconView
DailyRewardItemView = Class(DailyRewardItemView, MotionIconView)

--- @return void
function DailyRewardItemView:Ctor(transform)
    ---@type RootIconView
    self.iconView = nil
    MotionIconView.Ctor(self, transform)
end

--- @return void
function DailyRewardItemView:SetPrefabName()
    self.prefabName = 'daily_reward_item'
    self.uiPoolType = UIPoolType.DailyRewardItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function DailyRewardItemView:SetConfig(transform)
    --- @type DailyRewardItemConfig
    self.config = UIBaseConfig(transform)
    MotionIconView.SetConfig(self, transform)
end

--- @return void
--- @param iconData IconData
function DailyRewardItemView:SetIconData(iconData, day)
    assert(iconData)
    self:SetTile(string.format(LanguageUtils.LocalizeCommon("day_x"), day))
    self:SetItemName(LanguageUtils.GetStringResourceName(iconData.type, iconData.itemId))

    if self.iconView == nil then
        self.iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.item)
        if self.registerShowInfo == true then
            self.iconView:RegisterShowInfo()
        end
    end
    self.iconView:SetIconData(iconData)
end

function DailyRewardItemView:SetTile(tile)
    self.config.textDailyCheckinDay.text = tile
    if self.config.textDailyCheckinDay7 ~= nil then
        self.config.textDailyCheckinDay7.text = tile
    end
end

function DailyRewardItemView:SetItemName(name)
    self.config.textHeroName.text = name
end

--- @return void
function DailyRewardItemView:SetClaim(isClaimed)
    self.config.light:SetActive(isClaimed == false)
    self.config.bg2.gameObject:SetActive(isClaimed == true)
end

function DailyRewardItemView:EnableHighlight()

end

--- @return void
function DailyRewardItemView:RegisterShowInfo()
    self.registerShowInfo = true
    if self.iconView ~= nil then
        self.iconView:RegisterShowInfo()
    end
end

--- @return void
---@param func function
function DailyRewardItemView:AddListener(func)
    self:EnableButton(true)
    self.config.button.onClick:AddListener(func)
end

--- @return void
function DailyRewardItemView:RemoveAllListeners()
    self:EnableButton(false)
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function DailyRewardItemView:EnableButton(enabled)
    UIUtils.SetInteractableButton(self.config.button, enabled)
    self.config.bg.raycastTarget = enabled
    self.config.bg2.raycastTarget = enabled
end

--- @return void
--- @param enabled boolean
function DailyRewardItemView:EnableRaycast(enabled)
    self.config.bg.raycastTarget = enabled
    self.config.bg2.raycastTarget = enabled
end

--- @return void
function DailyRewardItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
    self:ReturnPoolItem()
end

function DailyRewardItemView:ReturnPoolItem()
    if self.iconView ~= nil then
        self.iconView:ReturnPool()
        self.iconView = nil
    end
    self.registerShowInfo = nil
end

return DailyRewardItemView
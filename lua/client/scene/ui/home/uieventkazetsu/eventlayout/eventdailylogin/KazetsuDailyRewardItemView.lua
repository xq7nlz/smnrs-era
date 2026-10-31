--- @class KazetsuDailyRewardItemView : MotionIconView
KazetsuDailyRewardItemView = Class(KazetsuDailyRewardItemView, MotionIconView)

--- @return void
function KazetsuDailyRewardItemView:Ctor()
    ---@type List -- <RootIconView>
    self.iconViewList = List()
    MotionIconView.Ctor(self)
end

--- @return void
function KazetsuDailyRewardItemView:SetPrefabName()
    self.prefabName = 'kazetsu_daily_reward_item'
    self.uiPoolType = UIPoolType.KazetsuDailyRewardItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function KazetsuDailyRewardItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type DailyRewardMultiItemConfig
    self.config = UIBaseConfig(transform)
end

function KazetsuDailyRewardItemView:FillData(dataList, day)
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

function KazetsuDailyRewardItemView:SetTile(tile)
    self.config.textDailyCheckinDay.text = tile
    if self.config.textDailyCheckinDay7 ~= nil then
        self.config.textDailyCheckinDay7.text = tile
    end
end

function KazetsuDailyRewardItemView:SetItemName(name)
    self.config.textHeroName.text = name
end

--- @return void
function KazetsuDailyRewardItemView:SetClaim(isClaimed)
    self.config.light:SetActive(isClaimed == false)
    self.config.bg2.gameObject:SetActive(isClaimed == true)
end

function KazetsuDailyRewardItemView:EnableHighlight()

end

--- @return void
function KazetsuDailyRewardItemView:RegisterShowInfo()
    local count = self.iconViewList:Count()
    if count > 0 then
        for i = 1, count do
            self.iconViewList:Get(i):RegisterShowInfo()
        end
    end
end

--- @return void
function KazetsuDailyRewardItemView:RemoveAllListeners()
    local count = self.iconViewList:Count()
    if count > 0 then
        for i = 1, count do
            self.iconViewList:Get(i):RemoveAllListeners()
        end
    end
end
--- @return void
---@param func function
function KazetsuDailyRewardItemView:AddListener(func)
    self:EnableButton(true)
    self.config.button.onClick:AddListener(func)
end

--- @return void
function KazetsuDailyRewardItemView:RemoveAllListeners()
    self:EnableButton(false)
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function KazetsuDailyRewardItemView:EnableButton(enabled)
    UIUtils.SetInteractableButton(self.config.button, enabled)
    self.config.bg.raycastTarget = enabled
    self.config.bg2.raycastTarget = enabled
end

--- @return void
--- @param enabled boolean
function KazetsuDailyRewardItemView:EnableRaycast(enabled)
    self.config.bg.raycastTarget = enabled
    self.config.bg2.raycastTarget = enabled
end

--- @return void
function KazetsuDailyRewardItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
    self:ReturnPoolItem()
end

function KazetsuDailyRewardItemView:ReturnPoolItem()
    local count = self.iconViewList:Count()
    if count > 0 then
        for i = 1, count do
            self.iconViewList:Get(i):ReturnPool()
        end
        self.iconViewList:Clear()
    end
end

return KazetsuDailyRewardItemView

--- @class UITreasureItemView : MotionIconView
UITreasureItemView = Class(UITreasureItemView, MotionIconView)

--- @return void
function UITreasureItemView:Ctor()
    ---@type TreasureRewardConfig
    self.treasureRewardConfig = nil
    MotionIconView.Ctor(self)
end

--- @return void
function UITreasureItemView:SetPrefabName()
    self.prefabName = 'treasure_item'
    self.uiPoolType = UIPoolType.UITreasureItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function UITreasureItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UITreasureItemConfig
    self.config = UIBaseConfig(transform)

end

---@param treasureRewardConfig TreasureRewardConfig
function UITreasureItemView:SetData(treasureRewardConfig, callbackSelect)
    self.treasureRewardConfig = treasureRewardConfig
    self.callbackSelect = callbackSelect

    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(function ()
        if self.callbackSelect ~= nil then
            self.callbackSelect()
        end
    end)
end

---@param indexUnlock number
function UITreasureItemView:UpdateState(indexUnlock)
    self.config.icon:SetActive(false)
    self.config.iconLock:SetActive(false)
    self.config.iconUnlock:SetActive(false)
    if self.treasureRewardConfig.index <= indexUnlock then
        self.config.iconUnlock:SetActive(true)
    elseif self.treasureRewardConfig.index > indexUnlock + 1 then
        self.config.iconLock:SetActive(true)
    else
        self.config.icon:SetActive(true)
    end
end

return UITreasureItemView
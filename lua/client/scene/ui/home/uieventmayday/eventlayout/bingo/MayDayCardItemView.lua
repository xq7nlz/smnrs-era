--- @class MayDayCardItemView : MotionIconView
MayDayCardItemView = Class(MayDayCardItemView, MotionIconView)

--- @return void
function MayDayCardItemView:Ctor()
    MotionIconView.Ctor(self)
    ---@type RootIconView
    self.itemView = nil
end
--- @return void
function MayDayCardItemView:SetPrefabName()
    self.prefabName = 'may_day_card_item_view'
    self.uiPoolType = UIPoolType.MayDayCardItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function MayDayCardItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type MayDayCardItemConfig
    self.config = UIBaseConfig(transform)
end

function MayDayCardItemView:ShowEffect(isActive)
    self.config.resetEffect.gameObject:SetActive(isActive)
end

function MayDayCardItemView:ShowEffectOpenCardRegularReward()
    local fxOpenCardStartPos = self.config.fxOpenCard.transform.localPosition
    ---@type UnityEngine_Vector3
    local fxOpenCardPos = fxOpenCardStartPos
    self.coroutine = Coroutine.start(function()
        self.config.fxOpenCard.gameObject:SetActive(true)
        while true do
            coroutine.waitforendofframe()
            if fxOpenCardPos.y >= 75 then
                fxOpenCardStartPos.y = 0
                self.config.fxOpenCard.transform.localPosition = fxOpenCardStartPos
                self.config.fxOpenCard.gameObject:SetActive(false)
                break
            else
                fxOpenCardPos.y = fxOpenCardPos.y + 2
                self.config.fxOpenCard.transform.localPosition = fxOpenCardPos
            end
        end
    end)
end

--- @return void
--- @param iconData ItemIconData
function MayDayCardItemView:SetIconData(iconData)
    if self.itemView == nil then
        self.itemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.item)
    end
    self.itemView:SetIconData(iconData)
    self.itemView:RegisterShowInfo()
    self.config.card.gameObject:SetActive(false)
    self.config.requireText.text = string.format("%s %s", "+", iconData.quantity)
end

--- @return void
function MayDayCardItemView:HideItem()
    if self.itemView ~= nil then
        self.itemView:ReturnPool()
        self.itemView = nil
    end
    self.config.card.gameObject:SetActive(true)
end

--- @return void
---@param func function
function MayDayCardItemView:AddListener(func)
    self:EnableButton(true)
    self.config.button.onClick:AddListener(func)
end

--- @return void
function MayDayCardItemView:RemoveAllListeners()
    self:EnableButton(false)
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
function MayDayCardItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
end


return MayDayCardItemView



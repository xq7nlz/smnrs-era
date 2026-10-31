--- @class LunarNewYear2024CardItemView : MotionIconView
LunarNewYear2024CardItemView = Class(LunarNewYear2024CardItemView, MotionIconView)

--- @return void
function LunarNewYear2024CardItemView:Ctor()
    MotionIconView.Ctor(self)
    ---@type RootIconView
    self.itemView = nil
end
--- @return void
function LunarNewYear2024CardItemView:SetPrefabName()
    self.prefabName = 'lunar_new_year_2024_card_item_view'
    self.uiPoolType = UIPoolType.LunarNewYear2024CardItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function LunarNewYear2024CardItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type LunarNewYear2024CardItemConfig
    self.config = UIBaseConfig(transform)
end

function LunarNewYear2024CardItemView:ShowEffect(isActive)
    self.config.resetEffect.gameObject:SetActive(isActive)
end

function LunarNewYear2024CardItemView:ShowEffectOpenCardRegularReward()
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
function LunarNewYear2024CardItemView:SetIconData(iconData)
    if self.itemView == nil then
        self.itemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.item)
    end
    self.itemView:SetIconData(iconData)
    self.itemView:RegisterShowInfo()
    self.config.card.gameObject:SetActive(false)
    self.config.requireText.text = string.format("%s %s", "+", iconData.quantity)
end

--- @return void
function LunarNewYear2024CardItemView:HideItem()
    if self.itemView ~= nil then
        self.itemView:ReturnPool()
        self.itemView = nil
    end
    self.config.card.gameObject:SetActive(true)
end

--- @return void
---@param func function
function LunarNewYear2024CardItemView:AddListener(func)
    self:EnableButton(true)
    self.config.button.onClick:AddListener(func)
end

--- @return void
function LunarNewYear2024CardItemView:RemoveAllListeners()
    self:EnableButton(false)
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
function LunarNewYear2024CardItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
end


return LunarNewYear2024CardItemView



--- @class PieceAdventureOpenCardItemView : MotionIconView
PieceAdventureOpenCardItemView = Class(PieceAdventureOpenCardItemView, MotionIconView)

--- @return void
function PieceAdventureOpenCardItemView:Ctor()
    MotionIconView.Ctor(self)
    ---@type RootIconView
    self.itemView = nil
end
--- @return void
function PieceAdventureOpenCardItemView:SetPrefabName()
    self.prefabName = 'piece_adventure_open_card_item_view'
    self.uiPoolType = UIPoolType.PieceAdventureOpenCardItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function PieceAdventureOpenCardItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type PieceAdventureOpenCardItemConfig
    self.config = UIBaseConfig(transform)
end

function PieceAdventureOpenCardItemView:ShowEffect(isActive)
    self.config.resetEffect.gameObject:SetActive(isActive)
end

function PieceAdventureOpenCardItemView:ShowEffectOpenCardRegularReward()
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
function PieceAdventureOpenCardItemView:SetIconData(iconData)
    if self.itemView == nil then
        self.itemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.item)
    end
    self.itemView:SetIconData(iconData)
    self.itemView:RegisterShowInfo()
    self.config.card.gameObject:SetActive(false)
    self.config.requireText.text = string.format("%s %s", "+", iconData.quantity)
end

--- @return void
function PieceAdventureOpenCardItemView:HideItem()
    if self.itemView ~= nil then
        self.itemView:ReturnPool()
        self.itemView = nil
    end
    self.config.card.gameObject:SetActive(true)
end

--- @return void
---@param func function
function PieceAdventureOpenCardItemView:AddListener(func)
    self:EnableButton(true)
    self.config.button.onClick:AddListener(func)
end

--- @return void
function PieceAdventureOpenCardItemView:RemoveAllListeners()
    self:EnableButton(false)
    self.config.button.onClick:RemoveAllListeners()
end

--- @return void
function PieceAdventureOpenCardItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
end


return PieceAdventureOpenCardItemView



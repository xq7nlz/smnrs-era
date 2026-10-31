--- @class PuzzleSlotItemView : MotionIconView
PuzzleSlotItemView = Class(PuzzleSlotItemView, MotionIconView)
function PuzzleSlotItemView:Ctor()
    --- @type UIPuzzleSlotConfig
    self.config = nil
    --- @type boolean
    self.isUnlock = nil
    MotionIconView.Ctor(self)
end

function PuzzleSlotItemView:SetPrefabName()
    self.prefabName = 'puzzle_slot'
    self.uiPoolType = UIPoolType.PuzzleSlotItem
end


function PuzzleSlotItemView:SetSlotState(isUnlock)
    self.config.Image.enabled = not isUnlock
    self.isUnlock = isUnlock
end

function PuzzleSlotItemView:EnableButton()
    self.config.Button.onClick:AddListener(function()
        self:SetSlotState( self.config.Image.enabled)
    end)
end

function PuzzleSlotItemView:SetImage(image)
    self.config.Image.sprite = image
end

--- @param transform UnityEngine_Transform
function PuzzleSlotItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type UIPuzzleSlotConfig
    self.config = UIBaseConfig(transform)
end

function PuzzleSlotItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
end



return PuzzleSlotItemView
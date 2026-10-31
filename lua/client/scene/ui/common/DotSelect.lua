--- @class DotSelect : MotionIconView
DotSelect = Class(DotSelect, MotionIconView)

--- @return void
function DotSelect:Ctor()
    ---@type DotSelectConfig
    self.config = nil
    MotionIconView.Ctor(self)
end

function DotSelect:SetPrefabName()
    self.prefabName = 'dot_select'
    self.uiPoolType = UIPoolType.DotSelect
end

--- @param transform UnityEngine_Transform
function DotSelect:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type DotSelectConfig
    self.config = UIBaseConfig(transform)
end

function DotSelect:AddListener(func)
    self.config.button.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func then
            func()
        end
        self:SetActiveState(true)
    end)
end

function DotSelect:SetButton(isInteractable)
    self.config.button.interactable = isInteractable
end

function DotSelect:RemoveAllListeners()
    self.config.button.onClick:RemoveAllListeners()
end

function DotSelect:SetActiveState(isHighlight)
    self.config.iconNormal.gameObject:SetActive(not isHighlight)
    self.config.iconHighlight.gameObject:SetActive(isHighlight)
end

function DotSelect:ReturnPool()
    MotionIconView.ReturnPool(self)
    self:SetActiveState(false)
    self:RemoveAllListeners()
end

return DotSelect
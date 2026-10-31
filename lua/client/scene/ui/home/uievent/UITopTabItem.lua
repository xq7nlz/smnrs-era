--- @class UITopTabItem : MotionIconView
UITopTabItem = Class(UITopTabItem, MotionIconView)

function UITopTabItem:Ctor()
    MotionIconView.Ctor(self)
end

function UITopTabItem:SetPrefabName()
    self.prefabName = 'top_tab'
    self.uiPoolType = UIPoolType.UITopTabItem
end

--- @param transform UnityEngine_Transform
function UITopTabItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type TopTabConfig
    self.config = UIBaseConfig(transform)
end

function UITopTabItem:AddOnSelectListener(listener)
    self.config.buttonSelect.onClick:RemoveAllListeners()
    self.config.buttonSelect.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        listener()
    end)
end

---@param name string
function UITopTabItem:SetTabName(name)
    self.config.textTabName.text = LanguageUtils.LocalizeCommon(name)
end

--- @param sprite UnityEngine_Sprite
function UITopTabItem:SetIcon(sprite)
    self.config.iconOff.sprite = sprite
    self.config.iconOn.sprite = sprite
    --self.config.iconOn:SetNativeSize()
end

--- @param isSelect boolean
function UITopTabItem:SetSelectState(isSelect)
    self.config.bgOff.gameObject:SetActive(not isSelect)
    self.config.bgOn.gameObject:SetActive(isSelect)
end

function UITopTabItem:SetPivot(pivot)
    self.config.transform.pivot = pivot
end

function UITopTabItem:ReturnPool()
    self:SetSelectState(false)
    MotionIconView.ReturnPool(self)
end

function UITopTabItem:EnableNoti(isOn)
    self.config.notify.gameObject:SetActive(isOn)
end

return UITopTabItem
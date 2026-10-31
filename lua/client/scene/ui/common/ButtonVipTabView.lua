--- @class ButtonVipTabView : UIPrefabView
ButtonVipTabView = Class(ButtonVipTabView, UIPrefabView)

function ButtonVipTabView:Ctor(transform)
    UIPrefabView.Ctor(self, transform)
end

--- @return void
--- @param transform UnityEngine_Transform
function ButtonVipTabView:SetConfig(transform)
    ---@type ButtonVipTabConfig
    self.config = UIBaseConfig(transform)
end

function ButtonVipTabView:SetPrefabName()
    self.prefabName = 'button_vip_tab'
    self.uiPoolType = UIPoolType.ButtonVipTabView
end

function ButtonVipTabView:AddListener(func)
    self.config.activeButton.onClick:AddListener(function()
        func()
    end)
    self.config.disableButton.onClick:AddListener(function()
        func()
    end)
end

function ButtonVipTabView:SetTextTab(vipLevel)
    self.config.textTab.text = vipLevel
end

function ButtonVipTabView:SetButtonState(isActive)
    self.config.activeButton.gameObject:SetActive(isActive)
    self.config.disableButton.gameObject:SetActive(not isActive)
end

--- @return void
function ButtonVipTabView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    self.config.activeButton.gameObject:SetActive(false)
    self.config.disableButton.gameObject:SetActive(false)
end

return ButtonVipTabView

--- @class ModeShopIconView : MotionIconView
ModeShopIconView = Class(ModeShopIconView, MotionIconView)

function ModeShopIconView:Ctor()
    --- @type IconView
    self.iconView = nil
    --- @type ButtonBuyView
    self.buttonBuyView = nil
    --- @type ItemIconData
    self.itemIconData = nil
    --- @type ButtonHelpRandomView
    self.buttonHelpRandomView = nil
    MotionIconView.Ctor(self)
end

--- @return void
function ModeShopIconView:SetPrefabName()
    self.prefabName = 'root_info'
    self.uiPoolType = UIPoolType.ModeShopIconView
end

--- @return void
--- @param transform UnityEngine_RectTransform
function ModeShopIconView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type {transform, gameObject, rectTransform, visual : UnityEngine_RectTransform}
    self.config = {}
    self.config.transform = transform
    self.config.gameObject = transform.gameObject
    self.config.visual = transform:Find("visual"):GetComponent(ComponentName.UnityEngine_RectTransform)
end

--- @return void
--- @param iconData MarketItemInBound
function ModeShopIconView:SetIconData(iconData)
    self.iconData = iconData
    self.itemIconData = iconData.reward:GetIconData()
    self.iconView = SmartPoolUtils.GetIconViewByIconData(self.itemIconData, self.config.visual)
    self.iconView:RegisterShowInfo()
    self.buttonBuyView:SetIconData(iconData.cost)
    self.buttonBuyView:SetPrice()
    self.buttonBuyView:ShowStock(true, iconData.numberItemCanBuy, iconData.maxItem)
    self:SetRelease(self.iconData:CanBuy())
end

function ModeShopIconView:ActiveButtonHelp(isActive, listener)
    if isActive == true then
        self.buttonHelpRandomView:AddListener(listener)
    end
    self.buttonHelpRandomView:EnableButton(isActive)
end

--- @return void
--- @param func function
function ModeShopIconView:AddBuyListener(func)
    self.buttonBuyView:AddListener(function()
        if self.iconData.numberItemCanBuy > 0 then
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            BuyUtils.InitListener(function()
                self.iconData.numberItemCanBuy = self.iconData.numberItemCanBuy - 1
                if self.iconData.numberItemCanBuy == 0 then
                    self:SetRelease(false)
                end
                self.itemIconData:AddToInventory()
            end)
            func()
        else
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
        end
    end)
end

--- @return void
--- @param isRelease boolean
function ModeShopIconView:SetRelease(isRelease)
    self.buttonBuyView:EnableButton(isRelease)
    UIUtils.SetInteractableButton(self.buttonBuyView.config.buttonBuy, true)
    self.iconView:EnableButton(isRelease)
    self.iconView:ActiveMaskSelect(not isRelease, UIUtils.sizeItem)
end

--- @return void
function ModeShopIconView:ShowInfo()
    self.iconView:ShowInfo()
end

--- @return void
function ModeShopIconView:Show()
    MotionIconView.Show(self)
    self.buttonBuyView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ButtonBuyView, self.config.visual)
    self.buttonBuyView.config.transform.localPosition = U_Vector3(0, -120, 0)

    self.buttonHelpRandomView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ButtonHelpRandomView, self.config.transform)
    self.buttonHelpRandomView.config.transform.localPosition = U_Vector3(90, 40, 0)
    self.buttonHelpRandomView.config.transform:SetAsLastSibling()
end

--- @return void
function ModeShopIconView:ReturnPool()
    MotionIconView.ReturnPool(self)

    self.iconView:ReturnPool()
    self.iconView = nil

    self.buttonBuyView:ReturnPool()
    self.buttonBuyView = nil

    self.buttonHelpRandomView:ReturnPool()
    self.buttonHelpRandomView = nil
end

return ModeShopIconView

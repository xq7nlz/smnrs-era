require "lua.client.scene.ui.home.uiEvent.UIEventPackageTabItem"
--- @class UIFlashSaleNewPackageTabItem : UIEventPackageTabItem
UIFlashSaleNewPackageTabItem = Class(UIFlashSaleNewPackageTabItem, UIEventPackageTabItem)

function UIFlashSaleNewPackageTabItem:Ctor()
    UIEventPackageTabItem.Ctor(self)
end

function UIFlashSaleNewPackageTabItem:SetPrefabName()
    self.prefabName = 'flash_sale_new_package_tab'
    self.uiPoolType = UIPoolType.FlashSaleNewPackageTabItem
end

return UIFlashSaleNewPackageTabItem

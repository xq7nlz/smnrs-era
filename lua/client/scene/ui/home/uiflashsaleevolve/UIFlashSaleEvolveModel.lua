
--- @class UIFlashSaleEvolveModel : UIBaseModel
UIFlashSaleEvolveModel = Class(UIFlashSaleEvolveModel, UIBaseModel)

--- @return void
function UIFlashSaleEvolveModel:Ctor()

	UIBaseModel.Ctor(self, UIPopupName.UIFlashSaleEvolve, "flash_sale_evolve")
	self.type = UIPopupType.BLUR_POPUP
	self.bgDark = true
end



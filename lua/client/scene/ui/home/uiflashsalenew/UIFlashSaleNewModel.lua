--- @class UIFlashSaleNewModel : UIBaseModel
UIFlashSaleNewModel = Class(UIFlashSaleNewModel, UIBaseModel)

--- @return void
function UIFlashSaleNewModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIFlashSaleNew, "ui_flash_sale_new")
    --- @type List
    self.listNewFlashSaleGroup = nil
    --- @type number -- groupId
    self.currentTab = nil
    --- @type GroupProductConfig
    self.groupProductConfig = nil
    --- @type Dictionary
    self.flashSaleDataDict = nil
    --- @type UIPopupType
    self.type = UIPopupType.BLUR_POPUP
    --- @type UIPopupType
    self.bgDark = true
end

function UIFlashSaleNewModel:GetData()
    self.listNewFlashSaleGroup = IapDataInBound.GetListNewFlashSaleGroup()
    self.flashSaleDataDict = Dictionary()
    for _, v in pairs(self.listNewFlashSaleGroup:GetItems()) do
        self.flashSaleDataDict:Add(v.groupId, v)
    end
end

function UIFlashSaleNewModel:SetTab(groupID)
    self.currentTab = groupID
    self.groupProductConfig = self.flashSaleDataDict:Get(groupID)
end

--- @return boolean
function UIFlashSaleNewModel:IsCurrentTab(groupID)
    return self.currentTab == groupID
end

---@class FlashSaleNewPackageType
FlashSaleNewPackageType = {
    SUPPER_SUPPORT_PACKAGE_1 = 1,
    SUPPER_SUPPORT_PACKAGE_2 = 2,
    SUPPER_SUPPORT_PACKAGE_3 = 3,
    SUPPER_SUPPORT_PACKAGE_4 = 4,
    SUPPER_SUPPORT_PACKAGE_5 = 5,
    SUPPER_SUPPORT_PACKAGE_6 = 6,
    SUPPER_SUPPORT_PACKAGE_7 = 7
}
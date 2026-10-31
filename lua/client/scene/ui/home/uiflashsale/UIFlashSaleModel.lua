--- @class UIFlashSaleModel : UIBaseModel
UIFlashSaleModel = Class(UIFlashSaleModel, UIBaseModel)

--- @return void
function UIFlashSaleModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIFlashSale, "ui_flash_sale")
    --- @type List
    self.listNewFlashSaleGroup = nil
    --- @type number -- groupId
    self.currentTab = nil
    --- @type GroupProductConfig
    self.groupProductConfig = nil
    --- @type Dictionary
    self.flashSaleDataDict = nil
end

function UIFlashSaleModel:GetData()
    self.listNewFlashSaleGroup = IapDataInBound.GetListFlashSaleGroup()
    self.flashSaleDataDict = Dictionary()
    for _, v in pairs(self.listNewFlashSaleGroup:GetItems()) do
        self.flashSaleDataDict:Add(v.groupId, v)
    end
end

function UIFlashSaleModel:SetTab(groupID)
    self.currentTab = groupID
    self.groupProductConfig = self.flashSaleDataDict:Get(groupID)
end

--- @return boolean
function UIFlashSaleModel:IsCurrentTab(groupID)
    return self.currentTab == groupID
end

---@class FlashSalePackageType
FlashSalePackageType = {
    WELCOME_PACKAGE = 13,
    SUMMONER_PACKAGE = 14,
    CHOSEN_PACKAGE = 15,
    UPGRADE_PACKAGE = 16,
    STONE_PACKAGE = 17,
    DESTINY_PACKAGE = 18,
    RESOURCE_PACKAGE = 19
}
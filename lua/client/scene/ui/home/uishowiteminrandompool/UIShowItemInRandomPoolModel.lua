--- @class UIShowItemInRandomPoolModel : UIBaseModel
UIShowItemInRandomPoolModel = Class(UIShowItemInRandomPoolModel, UIBaseModel)

--- @return void
function UIShowItemInRandomPoolModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIShowItemInRandomPool, "show_item_in_random_pool")

    self.bgDark = true
end

